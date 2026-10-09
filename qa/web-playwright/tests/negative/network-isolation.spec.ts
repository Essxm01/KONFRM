import { test, expect } from '@playwright/test';
import {
  setupDeterministicApi,
  seedReturningCustomer,
  getNetworkAudit,
  loadDetailFixture,
} from '../helpers/test-harness';

test.describe('Negative Control — Network Isolation & Fail-Closed Route Security', () => {
  test.beforeEach(async ({ page }) => {
    await seedReturningCustomer(page);
    await setupDeterministicApi(page);
    await page.goto('/');
    await expect(page.getByRole('heading', { name: 'هتصيف فين؟' })).toBeVisible({ timeout: 5000 });
  });

  test('1. Unexpected /api endpoint and invalid HTTP method are rejected with 404 / 405', async ({ page }) => {
    // A. Unexpected endpoint returns 404
    const unknownRes = await page.evaluate(async () => {
      const res = await fetch('/api/v1/customer/unauthorized-endpoint');
      return { status: res.status, body: await res.json() };
    });
    expect(unknownRes.status).toBe(404);
    expect(unknownRes.body.success).toBe(false);

    // B. Unexpected method (POST on GET search) returns 405
    const postRes = await page.evaluate(async () => {
      const res = await fetch('/api/v1/customer/properties/search', { method: 'POST' });
      return { status: res.status, body: await res.json() };
    });
    expect(postRes.status).toBe(405);
    expect(postRes.body.success).toBe(false);
  });

  test('2. External production API egress is blocked by browser-level client policy', async ({ page }) => {
    const egressBlocked = await page.evaluate(async () => {
      try {
        await fetch('https://sola-backend-api.essxm01.workers.dev/api/v1/customer/properties/search', {
          mode: 'cors',
        });
        return { blocked: false };
      } catch (err: any) {
        return { blocked: true, message: err?.message || String(err) };
      }
    });

    expect(egressBlocked.blocked).toBe(true);

    const audit = getNetworkAudit(page);
    const hasBlockedEgress = audit.blockedRequests.some((r) => r.includes('sola-backend-api.essxm01.workers.dev'));
    expect(hasBlockedEgress).toBe(true);
  });

  test('3. Incorrect property ID is rejected with 404 and does not leak fixture data', async ({ page }) => {
    // Detail endpoint with invalid ID
    const detail404 = await page.evaluate(async () => {
      const res = await fetch('/api/v1/customer/properties/prop-nonexistent-999');
      return { status: res.status, body: await res.json() };
    });
    expect(detail404.status).toBe(404);
    expect(detail404.body.success).toBe(false);
    expect(detail404.body.error.message).toContain('غير موجودة');

    // Availability endpoint with invalid ID
    const avail404 = await page.evaluate(async () => {
      const res = await fetch('/api/v1/customer/properties/prop-nonexistent-999/availability');
      return { status: res.status, body: await res.json() };
    });
    expect(avail404.status).toBe(404);
    expect(avail404.body.success).toBe(false);
  });

  test('4. Availability endpoint returns availability contract and cannot accidentally receive detail fixture', async ({ page }) => {
    const availData = await page.evaluate(async () => {
      const res = await fetch('/api/v1/customer/properties/prop-marassi-01/availability');
      return { status: res.status, body: await res.json() };
    });

    expect(availData.status).toBe(200);
    expect(availData.body.success).toBe(true);

    // Verifies canonical availability contract
    const data = availData.body.data;
    expect(data.propertyId).toBe('prop-marassi-01');
    expect(Array.isArray(data.unavailableRanges)).toBe(true);
    expect(typeof data.minStay).toBe('number');
    expect(typeof data.maxStay).toBe('number');

    // STRICT PROOF: Availability response must NOT contain detail DTO fields
    expect((data as any).description).toBeUndefined();
    expect((data as any).amenities).toBeUndefined();
    expect((data as any).houseRules).toBeUndefined();
    expect((data as any).unitType).toBeUndefined();
    expect((data as any).bedsCount).toBeUndefined();
    expect((data as any).areaSqM).toBeUndefined();
  });

  test('5. Valid authorized API fixtures continue to pass and return canonical schemas', async ({ page }) => {
    const detailFixture = loadDetailFixture().data;

    // A. Authorized search
    const searchRes = await page.evaluate(async () => {
      const res = await fetch('/api/v1/customer/properties/search');
      return { status: res.status, body: await res.json() };
    });
    expect(searchRes.status).toBe(200);
    expect(searchRes.body.success).toBe(true);
    expect(Array.isArray(searchRes.body.data)).toBe(true);
    expect(searchRes.body.data.length).toBeGreaterThanOrEqual(1);

    // B. Authorized detail
    const detailRes = await page.evaluate(async () => {
      const res = await fetch('/api/v1/customer/properties/prop-marassi-01');
      return { status: res.status, body: await res.json() };
    });
    expect(detailRes.status).toBe(200);
    expect(detailRes.body.success).toBe(true);
    expect(detailRes.body.data.id).toBe('prop-marassi-01');
    expect(detailRes.body.data.title).toBe(detailFixture.title);
    expect(detailRes.body.data.currency).toBe('EGP');
  });

  test('6. Unauthorized localhost port is rejected fail-closed and recorded in audit', async ({ page }) => {
    const unapprovedPortBlocked = await page.evaluate(async () => {
      try {
        await fetch('http://localhost:4000/api/v1/customer/properties/search', {
          mode: 'cors',
        });
        return { blocked: false };
      } catch (err: any) {
        return { blocked: true, message: err?.message || String(err) };
      }
    });

    expect(unapprovedPortBlocked.blocked).toBe(true);

    const audit = getNetworkAudit(page);
    const hasBlockedPort = audit.blockedRequests.some((r) => r.includes('http://localhost:4000'));
    expect(hasBlockedPort).toBe(true);
  });

  test('7. Context-wide route interception protects newly spawned pages against egress and serves authorized routes', async ({ page }) => {
    const newPage = await page.context().newPage();
    try {
      // Navigate new page to authorized origin
      await newPage.goto('/');
      await expect(newPage.getByRole('heading', { name: 'هتصيف فين؟' })).toBeVisible({ timeout: 5000 });

      // Authorized API request works on new page
      const searchRes = await newPage.evaluate(async () => {
        const res = await fetch('/api/v1/customer/properties/search');
        return { status: res.status, body: await res.json() };
      });
      expect(searchRes.status).toBe(200);
      expect(searchRes.body.success).toBe(true);

      // Unauthorized egress is blocked fail-closed on new page
      const egressBlocked = await newPage.evaluate(async () => {
        try {
          await fetch('https://sola-backend-api.essxm01.workers.dev/api/v1/customer/properties/search', {
            mode: 'cors',
          });
          return { blocked: false };
        } catch (err: any) {
          return { blocked: true, message: err?.message || String(err) };
        }
      });
      expect(egressBlocked.blocked).toBe(true);

      const audit = getNetworkAudit(newPage);
      const hasBlockedEgress = audit.blockedRequests.some((r) => r.includes('sola-backend-api.essxm01.workers.dev'));
      expect(hasBlockedEgress).toBe(true);
    } finally {
      await newPage.close();
    }
  });

  test('8. Vite /api proxy prefix boundary intercepts /api, query probes, and unslashed prefixes fail-closed', async ({ page }) => {
    // A. Exact `/api` path without trailing slash
    const exactApiRes = await page.evaluate(async () => {
      const res = await fetch('/api');
      return {
        status: res.status,
        contentType: res.headers.get('content-type'),
        body: await res.json(),
      };
    });
    expect(exactApiRes.status).toBe(404);
    expect(exactApiRes.contentType).toContain('application/json');
    expect(exactApiRes.body.success).toBe(false);
    expect(exactApiRes.body.error.message).toBe('UNKNOWN_API_ENDPOINT: /api');

    // B. `/api` with query parameters (`/api?probe=1`)
    const probeApiRes = await page.evaluate(async () => {
      const res = await fetch('/api?probe=1');
      return {
        status: res.status,
        contentType: res.headers.get('content-type'),
        body: await res.json(),
      };
    });
    expect(probeApiRes.status).toBe(404);
    expect(probeApiRes.contentType).toContain('application/json');
    expect(probeApiRes.body.success).toBe(false);
    expect(probeApiRes.body.error.message).toBe('UNKNOWN_API_ENDPOINT: /api');

    // C. Unexpected path beginning with `/api` lacking slash separator (e.g. `/api-unslashed-probe`)
    const unslashedApiRes = await page.evaluate(async () => {
      const res = await fetch('/api-unslashed-probe');
      return {
        status: res.status,
        contentType: res.headers.get('content-type'),
        body: await res.json(),
      };
    });
    expect(unslashedApiRes.status).toBe(404);
    expect(unslashedApiRes.contentType).toContain('application/json');
    expect(unslashedApiRes.body.success).toBe(false);
    expect(unslashedApiRes.body.error.message).toBe('UNKNOWN_API_ENDPOINT: /api-unslashed-probe');

    // D. Assert all requests were intercepted by the Playwright mock dispatcher rather than leaking to Vite proxy
    const audit = getNetworkAudit(page);
    expect(audit.unexpectedRequests).toContain('UNKNOWN_API_ENDPOINT: GET /api');
    expect(audit.unexpectedRequests).toContain('UNKNOWN_API_ENDPOINT: GET /api-unslashed-probe');
  });
});


