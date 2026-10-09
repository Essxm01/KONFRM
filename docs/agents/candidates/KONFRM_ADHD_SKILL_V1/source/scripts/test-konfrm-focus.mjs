#!/usr/bin/env node
import fs from 'node:fs';import os from 'node:os';import path from 'node:path';import assert from 'node:assert/strict';import {fileURLToPath} from 'node:url';import {validateProject} from './check-konfrm-focus.mjs';
const base=fileURLToPath(new URL('../',import.meta.url)),tmp=fs.mkdtempSync(path.join(os.tmpdir(),'konfrm-focus-'));
const src=path.join(base,'docs/focus'),dst=path.join(tmp,'docs/focus');fs.mkdirSync(path.dirname(dst),{recursive:true});fs.cpSync(src,dst,{recursive:true});
const file=n=>path.join(dst,n), read=n=>JSON.parse(fs.readFileSync(file(n),'utf8')),write=(n,v)=>fs.writeFileSync(file(n),JSON.stringify(v,null,2)+'\n');
let count=0;const names=['FOCUS_NOW.json','IDEA_INBOX.json','EXECUTION_QUEUE.json','DECISION_LEDGER.jsonl'];
function negative(name,mutate,expected){const old=Object.fromEntries(names.map(n=>[n,fs.readFileSync(file(n),'utf8')]));try{mutate();const e=validateProject(tmp);assert.ok(e.some(s=>s.includes(expected)),name+' expected '+expected+' got '+e.join(';'));console.log('PASS negative: '+name);count++}finally{for(const [n,v] of Object.entries(old))fs.writeFileSync(file(n),v)}}
try{
 assert.deepEqual(validateProject(tmp),[]);count++;console.log('PASS baseline');
 negative('second active task',()=>{let x=read('FOCUS_NOW.json');x.additional_active_tasks=[{task_id:'other'}];write('FOCUS_NOW.json',x)},'WIP violation');
 negative('unapproved idea queued',()=>{let x=read('EXECUTION_QUEUE.json');x.queue.push({idea_id:'IDEA-20261008-002',phase_slot:'PHASE_5_GUEST_UX',status:'READY',dependencies:[]});write('EXECUTION_QUEUE.json',x)},'unapproved idea in queue');
 negative('unapproved priority promotion',()=>{let x=read('IDEA_INBOX.json');x.entries[1].approval.queue_approved=true;write('IDEA_INBOX.json',x)},'unapproved idea advanced');
 negative('Phase 8 bypass R2-R5',()=>{let x=read('IDEA_INBOX.json');x.entries[0].phase_slot='PHASE_8_PLUS';x.entries[0].approval.queue_approved=true;write('IDEA_INBOX.json',x);let y=read('EXECUTION_QUEUE.json');y.queue=[{idea_id:x.entries[0].id,phase_slot:'PHASE_8_PLUS',status:'READY',dependencies:[]}];write('EXECUTION_QUEUE.json',y)},'Phase 8+ gate absent');
 negative('duplicate idea',()=>{let x=read('IDEA_INBOX.json');x.entries.push({...x.entries[0]});write('IDEA_INBOX.json',x)},'duplicate idea ID');
 negative('duplicate normalized title',()=>{let x=read('IDEA_INBOX.json');const cp={...x.entries[1],id:'IDEA-20261008-099'};x.entries.push(cp);write('IDEA_INBOX.json',x)},'possible duplicate title');
 negative('fake current evidence',()=>{let x=read('FOCUS_NOW.json');x.verification='CURRENT_WITH_EVIDENCE';write('FOCUS_NOW.json',x)},'evidence_url');
 negative('fake queue approval without event',()=>{let x=read('IDEA_INBOX.json');x.entries[0].approval.queue_approved=true;write('IDEA_INBOX.json',x);let q=read('EXECUTION_QUEUE.json');q.queue=[{idea_id:x.entries[0].id,phase_slot:x.entries[0].phase_slot,status:'READY',dependencies:[]}];write('EXECUTION_QUEUE.json',q)},'queue approval needs recorded Founder decision event');
 negative('orphan decision',()=>{fs.appendFileSync(file('DECISION_LEDGER.jsonl'),JSON.stringify({event_id:'x',authority:'QA',date:'2026-10-08',status:'X',record_id:'IDEA-20000101-001'})+'\n')},'orphan decision');
 negative('execution without queue approval',()=>{let x=read('IDEA_INBOX.json');x.entries[0].approval.execution_approved=true;write('IDEA_INBOX.json',x)},'execution requires queue approval');
 assert.deepEqual(validateProject(tmp),[]);console.log(`ALL TESTS PASS: ${count} (1 baseline + ${count-1} negative controls)`);
}catch(e){console.error('TEST FAILURE:',e);process.exitCode=1}finally{fs.rmSync(tmp,{recursive:true,force:true})}
