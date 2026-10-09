import type { Page, Locator } from '@playwright/test';
import { expect } from '@playwright/test';
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

export function loadAvailabilityFixture(): any {
  const filePath = path.join(FIXTURES_DIR, 'propertyAvailabilityFixture.json');
  return JSON.parse(fs.readFileSync(filePath, 'utf-8'));
}

export interface NetworkAudit {
  authorizedRequests: string[];
  blockedRequests: string[];
  unexpectedRequests: string[];
  searchRequestCount: number;
  detailRequestCount: number;
  availabilityRequestCount: number;
}

const pageAudits = new WeakMap<Page, NetworkAudit>();

export function getNetworkAudit(page: Page): NetworkAudit {
  let audit = pageAudits.get(page);
  if (!audit) {
    audit = {
      authorizedRequests: [],
      blockedRequests: [],
      unexpectedRequests: [],
      searchRequestCount: 0,
      detailRequestCount: 0,
      availabilityRequestCount: 0,
    };
    pageAudits.set(page, audit);
  }
  return audit;
}

export interface SetupApiOptions {
  searchResponse?: any;
  searchStatus?: number;
  detailResponse?: any;
  detailStatus?: number;
  availabilityResponse?: any;
  availabilityStatus?: number;
  expectedPropertyId?: string;
  onRequest?: (type: 'search' | 'detail' | 'availability', count: number) => { status?: number; body?: any } | void;
}

/**
 * Configure 100% deterministic offline fail-closed network routing.
 * - Allows ONLY explicitly authorized local Vite document/static development resources.
 * - Intercepts ALL /api requests before they can reach Vite's backend proxy.
 * - Rejects unknown API endpoints and unexpected HTTP methods.
 * - Mocks search, exact property detail, and property availability as distinct endpoints.
 * - Matches exact paths and expected property IDs, not catch-all responses.
 * - Blocks outbound production API, Supabase, Cloudflare Worker, and 3rd-party network requests.
 * - Tracks all network requests and flags unexpected egress.
 */
export async function setupDeterministicApi(page: Page, options: SetupApiOptions = {}): Promise<NetworkAudit> {
  const audit = getNetworkAudit(page);
  const expectedPropertyId = options.expectedPropertyId ?? 'prop-marassi-01';

  const defaultSearchPayload = options.searchResponse ?? loadSearchFixture();
  const defaultSearchStatus = options.searchStatus ?? 200;

  const defaultDetailPayload = options.detailResponse ?? loadDetailFixture();
  const defaultDetailStatus = options.detailStatus ?? 200;

  const defaultAvailabilityPayload = options.availabilityResponse ?? loadAvailabilityFixture();
  const defaultAvailabilityStatus = options.availabilityStatus ?? 200;

  // Single unified route handler at ** enforcing fail-closed network isolation
  await page.route('**', async (route) => {
    const request = route.request();
    const rawUrl = request.url();
    const method = request.method();
    let url: URL;
    try {
      url = new URL(rawUrl);
    } catch {
      audit.unexpectedRequests.push(`MALFORMED_URL: ${rawUrl}`);
      await route.abort('blockedbyclient');
      return;
    }

    // 1. Authorized external static assets: 1x1 transparent GIF stub for Unsplash, offline font stubs
    if (url.hostname === 'images.unsplash.com') {
      audit.authorizedRequests.push(`${method} ${rawUrl}`);
      const transparentGif = Buffer.from(
        'R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7',
        'base64'
      );
      await route.fulfill({
        status: 200,
        contentType: 'image/gif',
        body: transparentGif,
      });
      return;
    }

    if (url.hostname === 'fonts.googleapis.com' || url.hostname === 'fonts.gstatic.com') {
      audit.authorizedRequests.push(`${method} ${rawUrl}`);
      await route.fulfill({
        status: 200,
        contentType: 'text/css',
        body: '/* offline font stub */',
      });
      return;
    }

    // 2. Strict Origin Boundary: Any non-localhost request that is not an authorized asset is BLOCKED
    const isLocalhost = (url.hostname === 'localhost' || url.hostname === '127.0.0.1');

    if (!isLocalhost) {
      audit.blockedRequests.push(`BLOCKED_EXTERNAL_EGRESS: ${method} ${rawUrl}`);
      audit.unexpectedRequests.push(`BLOCKED_EXTERNAL_EGRESS: ${method} ${rawUrl}`);
      await route.abort('blockedbyclient');
      return;
    }

    // 3. Localhost Vite Static & Dev Resources (HTML, JS, CSS, fonts, SVG, client HMR)
    const isApiRequest = url.pathname.startsWith('/api/') || url.pathname.startsWith('/customer/properties');

    if (!isApiRequest) {
      // Allowed local Vite static development resource
      audit.authorizedRequests.push(`${method} ${url.pathname}`);
      await route.continue();
      return;
    }

    // 4. Localhost API Request Handling (Strict Mocking Dispatcher)
    if (isApiRequest) {
      let apiPath = url.pathname;
      if (!apiPath.startsWith('/api/v1')) {
        apiPath = `/api/v1${apiPath.startsWith('/') ? '' : '/'}${apiPath}`;
      }

      // A. Search Endpoint: GET /api/v1/customer/properties/search
      if (apiPath === '/api/v1/customer/properties/search') {
        if (method !== 'GET') {
          audit.unexpectedRequests.push(`UNEXPECTED_METHOD: ${method} on ${apiPath}`);
          await route.fulfill({
            status: 405,
            contentType: 'application/json',
            body: JSON.stringify({ success: false, error: { message: 'METHOD_NOT_ALLOWED' } }),
          });
          return;
        }

        audit.searchRequestCount++;
        audit.authorizedRequests.push(`${method} ${apiPath} (count: ${audit.searchRequestCount})`);

        const override = options.onRequest ? options.onRequest('search', audit.searchRequestCount) : undefined;
        const status = override?.status ?? defaultSearchStatus;
        const payload = override?.body ?? defaultSearchPayload;

        if (status >= 400) {
          await route.fulfill({
            status,
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
            body: JSON.stringify(payload),
          });
        }
        return;
      }

      // B. Availability Endpoint: GET /api/v1/customer/properties/:id/availability
      const availMatch = apiPath.match(/^\/api\/v1\/customer\/properties\/([^\/]+)\/availability$/);
      if (availMatch) {
        const requestedId = decodeURIComponent(availMatch[1]);
        if (method !== 'GET') {
          audit.unexpectedRequests.push(`UNEXPECTED_METHOD: ${method} on ${apiPath}`);
          await route.fulfill({
            status: 405,
            contentType: 'application/json',
            body: JSON.stringify({ success: false, error: { message: 'METHOD_NOT_ALLOWED' } }),
          });
          return;
        }

        if (requestedId !== expectedPropertyId) {
          audit.blockedRequests.push(`PROPERTY_ID_MISMATCH: ${requestedId} != ${expectedPropertyId}`);
          await route.fulfill({
            status: 404,
            contentType: 'application/json',
            body: JSON.stringify({
              success: false,
              error: { message: 'الوحدة المطلوبة غير موجودة' },
            }),
          });
          return;
        }

        audit.availabilityRequestCount++;
        audit.authorizedRequests.push(`${method} ${apiPath} (count: ${audit.availabilityRequestCount})`);

        const override = options.onRequest ? options.onRequest('availability', audit.availabilityRequestCount) : undefined;
        const status = override?.status ?? defaultAvailabilityStatus;
        const payload = override?.body ?? defaultAvailabilityPayload;

        if (status >= 400) {
          await route.fulfill({
            status,
            contentType: 'application/json',
            body: JSON.stringify({
              success: false,
              error: { message: 'تعذر تحميل بيانات الإتاحة' },
            }),
          });
        } else {
          await route.fulfill({
            status: 200,
            contentType: 'application/json',
            body: JSON.stringify(payload),
          });
        }
        return;
      }

      // C. Detail Endpoint: GET /api/v1/customer/properties/:id
      const detailMatch = apiPath.match(/^\/api\/v1\/customer\/properties\/([^\/]+)$/);
      if (detailMatch) {
        const requestedId = decodeURIComponent(detailMatch[1]);
        if (method !== 'GET') {
          audit.unexpectedRequests.push(`UNEXPECTED_METHOD: ${method} on ${apiPath}`);
          await route.fulfill({
            status: 405,
            contentType: 'application/json',
            body: JSON.stringify({ success: false, error: { message: 'METHOD_NOT_ALLOWED' } }),
          });
          return;
        }

        if (requestedId !== expectedPropertyId) {
          audit.blockedRequests.push(`PROPERTY_ID_MISMATCH: ${requestedId} != ${expectedPropertyId}`);
          await route.fulfill({
            status: 404,
            contentType: 'application/json',
            body: JSON.stringify({
              success: false,
              error: { message: 'الوحدة المطلوبة غير موجودة' },
            }),
          });
          return;
        }

        audit.detailRequestCount++;
        audit.authorizedRequests.push(`${method} ${apiPath} (count: ${audit.detailRequestCount})`);

        const override = options.onRequest ? options.onRequest('detail', audit.detailRequestCount) : undefined;
        const status = override?.status ?? defaultDetailStatus;
        const payload = override?.body ?? defaultDetailPayload;

        if (status >= 400) {
          await route.fulfill({
            status,
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
            body: JSON.stringify(payload),
          });
        }
        return;
      }

      // D. Unknown API Endpoint: Fail-Closed 404
      audit.unexpectedRequests.push(`UNKNOWN_API_ENDPOINT: ${method} ${apiPath}`);
      await route.fulfill({
        status: 404,
        contentType: 'application/json',
        body: JSON.stringify({
          success: false,
          error: { message: `UNKNOWN_API_ENDPOINT: ${apiPath}` },
        }),
      });
      return;
    }

    // 4. Outbound External Requests (Supabase, Cloudflare Worker, 3rd party APIs, etc.): Blocked!
    audit.blockedRequests.push(`BLOCKED_EXTERNAL_EGRESS: ${method} ${rawUrl}`);
    audit.unexpectedRequests.push(`BLOCKED_EXTERNAL_EGRESS: ${method} ${rawUrl}`);
    await route.abort('blockedbyclient');
  });

  return audit;
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

/**
 * Assert that the computed CSS direction on the active container is 'rtl'.
 */
export async function assertEffectiveRtl(locator: Locator): Promise<void> {
  await expect(locator).toBeVisible();
  const dir = await locator.evaluate((el) => window.getComputedStyle(el).direction);
  expect(dir).toBe('rtl');
}

/**
 * Assert that the document does not suffer from horizontal overflow (scrollWidth <= clientWidth).
 */
export async function assertNoHorizontalOverflow(page: Page): Promise<void> {
  const hasOverflow = await page.evaluate(() => {
    const docWidth = document.documentElement.clientWidth;
    const scrollWidth = document.documentElement.scrollWidth;
    return scrollWidth > docWidth + 1; // 1px allowable rounding margin for subpixels
  });
  expect(hasOverflow).toBe(false);
}

/**
 * Assert that an interactive touch target satisfies the minimum 44x44px boundary.
 */
export async function assertMinimumTouchTarget(
  locator: Locator,
  minWidth = 44,
  minHeight = 44
): Promise<void> {
  await expect(locator).toBeVisible();
  const box = await locator.boundingBox();
  expect(box).not.toBeNull();
  expect(box!.width).toBeGreaterThanOrEqual(minWidth);
  expect(box!.height).toBeGreaterThanOrEqual(minHeight);
}

/**
 * Assert zero unexpected network requests occurred during test execution.
 */
export function assertZeroUnexpectedRequests(page: Page): void {
  const audit = getNetworkAudit(page);
  expect(audit.unexpectedRequests).toEqual([]);
}
