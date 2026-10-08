import type { Page } from '@playwright/test';
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

export const FIXTURES_DIR = path.resolve(__dirname, '../../fixtures');
export const EVIDENCE_SCREENSHOTS_DIR = path.resolve(__dirname, '../../evidence/screenshots');

export function loadSearchFixture(): any {
  const filePath = path.join(FIXTURES_DIR, 'publishedPropertySearchFixture.json');
  return JSON.parse(fs.readFileSync(filePath, 'utf-8'));
}

export function loadDetailFixture(): any {
  const filePath = path.join(FIXTURES_DIR, 'propertyDetailFixture.json');
  return JSON.parse(fs.readFileSync(filePath, 'utf-8'));
}

export interface SetupApiOptions {
  searchResponse?: any;
  searchStatus?: number;
  detailResponse?: any;
  detailStatus?: number;
}

/**
 * Configure 100% deterministic offline network routing.
 * Intercepts Customer property search and detail APIs with controlled synthetic data.
 * Blocks unhandled external requests to ensure offline zero-leakage test runs.
 */
export async function setupDeterministicApi(page: Page, options: SetupApiOptions = {}): Promise<void> {
  const searchPayload = options.searchResponse ?? loadSearchFixture();
  const searchStatus = options.searchStatus ?? 200;
  const detailPayload = options.detailResponse ?? loadDetailFixture();
  const detailStatus = options.detailStatus ?? 200;

  // Single unified route handler for all customer properties endpoints
  await page.route('**/api/v1/customer/properties/**', async (route) => {
    const url = new URL(route.request().url());
    const pathname = url.pathname;

    if (pathname.includes('/search')) {
      if (searchStatus >= 400) {
        await route.fulfill({
          status: searchStatus,
          contentType: 'application/json',
          body: JSON.stringify({
            success: false,
            error: { message: 'تعذر الاتصال بالخادم. يرجى المحاولة مرة أخرى.' },
          }),
        });
      } else {
        await route.fulfill({
          status: 200,
          contentType: 'application/json',
          body: JSON.stringify(searchPayload),
        });
      }
      return;
    }

    // Detail endpoint: /api/v1/customer/properties/:id
    if (detailStatus >= 400) {
      await route.fulfill({
        status: detailStatus,
        contentType: 'application/json',
        body: JSON.stringify({
          success: false,
          error: { message: 'تعذر تحميل بيانات الإقامة المطلوبة' },
        }),
      });
    } else {
      await route.fulfill({
        status: 200,
        contentType: 'application/json',
        body: JSON.stringify(detailPayload),
      });
    }
  });

  // Block external third-party image requests gracefully with a transparent 1x1 GIF
  await page.route('https://images.unsplash.com/**', async (route) => {
    const transparentGif = Buffer.from(
      'R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7',
      'base64'
    );
    await route.fulfill({
      status: 200,
      contentType: 'image/gif',
      body: transparentGif,
    });
  });
}

/**
 * Pre-seed localStorage to represent a returning customer who has already
 * seen the First-Entry Splash & Welcome screen.
 */
export async function seedReturningCustomer(page: Page): Promise<void> {
  await page.addInitScript(() => {
    window.localStorage.setItem('konfrm_customer_entry_seen_v1', 'true');
  });
}

/**
 * Clear customer first-entry state to simulate a fresh, clean-slate visitor.
 */
export async function clearCustomerEntryState(page: Page): Promise<void> {
  await page.addInitScript(() => {
    window.localStorage.removeItem('konfrm_customer_entry_seen_v1');
  });
}

/**
 * Capture evidence screenshot to disk under qa/web-playwright/evidence/screenshots/
 */
export async function captureEvidenceScreenshot(page: Page, filename: string): Promise<string> {
  if (!fs.existsSync(EVIDENCE_SCREENSHOTS_DIR)) {
    fs.mkdirSync(EVIDENCE_SCREENSHOTS_DIR, { recursive: true });
  }
  const screenshotPath = path.join(EVIDENCE_SCREENSHOTS_DIR, filename);
  await page.screenshot({ path: screenshotPath, fullPage: false });
  return screenshotPath;
}
