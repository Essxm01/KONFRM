import { test, expect } from '@playwright/test';
import {
  setupDeterministicApi,
  seedReturningCustomer,
  clearCustomerEntryState,
  captureEvidenceScreenshot,
  loadSearchFixture,
} from '../helpers/test-harness';

test.describe('Smoke 01 — Guest Discovery & First-Entry Semantics', () => {
  test('Fresh guest experiences Splash -> Welcome -> Guest Browse -> Explore, persisting entry flag', async ({ page }, testInfo) => {
    // 1. Ensure clean slate (no seen flag)
    await clearCustomerEntryState(page);
    await setupDeterministicApi(page);

    // 2. Navigate to customer application
    await page.goto('/');

    // 3. Splash screen appears and displays brand recognition
    const splashOrWelcome = page.locator('[role="status"][aria-label="كونفرم"], [role="main"][aria-label="مرحبًا بك في كونفرم"]');
    await expect(splashOrWelcome.first()).toBeVisible({ timeout: 5000 });

    // 4. Welcome screen appears (or transitions from splash within SPLASH_DURATION_MS = 1200ms)
    const welcomeScreen = page.locator('[role="main"][aria-label="مرحبًا بك في كونفرم"]');
    await expect(welcomeScreen).toBeVisible({ timeout: 7000 });

    // Verify Arabic copy and brand elements on Welcome screen
    await expect(page.getByRole('heading', { name: 'اكتشف إقامتك المثالية على الساحل' })).toBeVisible();
    await expect(page.getByText('أسعار حقيقية وتواريخ متاحة بوضوح')).toBeVisible();

    // Verify CTAs
    const guestBrowseBtn = page.getByRole('button', { name: 'تصفح كضيف', exact: true });
    await expect(guestBrowseBtn).toBeVisible();
    await expect(page.getByRole('button', { name: 'إنشاء حساب' })).toBeVisible();
    await expect(page.getByRole('button', { name: 'تسجيل الدخول' })).toBeVisible();

    // Verify storage before click is still empty
    const flagBefore = await page.evaluate(() => window.localStorage.getItem('konfrm_customer_entry_seen_v1'));
    expect(flagBefore).toBeNull();

    // 5. Click "تصفح كضيف" (Browse as Guest)
    await guestBrowseBtn.click();

    // 6. Verify entry flag is now persisted in localStorage
    await expect.poll(async () => {
      return await page.evaluate(() => window.localStorage.getItem('konfrm_customer_entry_seen_v1'));
    }).toBe('true');

    // 7. Verify Explore screen is rendered
    await expect(page.getByRole('heading', { name: 'هتصيف فين؟' })).toBeVisible({ timeout: 5000 });
    await expect(page.getByRole('heading', { name: 'اكتشف الإقامات' })).toBeVisible();

    // 8. Verify property cards rendered from canonical search fixture
    const searchData = loadSearchFixture();
    const firstProperty = searchData.data[0];
    const secondProperty = searchData.data[1];

    await expect(page.getByText(firstProperty.title)).toBeVisible();
    await expect(page.getByText(secondProperty.title)).toBeVisible();

    // Verify Arabic pricing format (Arabic-Indic numeral ٨٬٥٠٠ or 8,500, with currency and unit)
    await expect(page.getByText(/٨[٬,]٥٠٠|8,500/).first()).toBeVisible();
    await expect(page.getByText('ج.م').first()).toBeVisible();
    await expect(page.getByText('/ ليلة').first()).toBeVisible();

    // Verify facts row
    await expect(page.getByText(/6 ضيوف/).first()).toBeVisible();
    await expect(page.getByText(/3 غرف/).first()).toBeVisible();

    // 9. Verify RTL presentation
    const htmlDir = await page.getAttribute('html', 'dir');
    const bodyDir = await page.getAttribute('body', 'dir');
    const hasRtl = htmlDir === 'rtl' || bodyDir === 'rtl' || (await page.locator('[dir="rtl"]').count()) > 0;
    expect(hasRtl).toBe(true);

    // 10. Capture visual evidence
    const viewportTag = `${testInfo.project.name.replace(/[^a-zA-Z0-9_-]/g, '_')}`;
    await captureEvidenceScreenshot(page, `01_guest_discovery_explore_${viewportTag}.png`);
  });

  test('Returning guest with entry flag bypasses Splash and Welcome directly to Explore', async ({ page }, testInfo) => {
    // 1. Pre-seed returning customer flag
    await seedReturningCustomer(page);
    await setupDeterministicApi(page);

    // 2. Navigate to application
    await page.goto('/');

    // 3. Directly renders Explore view without presenting Welcome screen
    await expect(page.getByRole('heading', { name: 'هتصيف فين؟' })).toBeVisible({ timeout: 5000 });
    await expect(page.locator('[role="main"][aria-label="مرحبًا بك في كونفرم"]')).not.toBeVisible();

    // Verify cards are visible immediately
    await expect(page.getByText('شاليه فاخر بإطلالة مباشرة على اللاجون في مراسي')).toBeVisible();

    // Capture visual evidence
    const viewportTag = `${testInfo.project.name.replace(/[^a-zA-Z0-9_-]/g, '_')}`;
    await captureEvidenceScreenshot(page, `01_returning_guest_bypass_${viewportTag}.png`);
  });
});
