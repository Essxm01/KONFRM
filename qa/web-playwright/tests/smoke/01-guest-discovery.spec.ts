import { test, expect } from '@playwright/test';
import {
  setupDeterministicApi,
  seedReturningCustomer,
  clearCustomerEntryState,
  captureEvidenceScreenshot,
  loadSearchFixture,
  assertEffectiveRtl,
  assertNoHorizontalOverflow,
  assertMinimumTouchTarget,
  assertZeroUnexpectedRequests,
} from '../helpers/test-harness';

test.describe('Smoke 01 — Guest Discovery & Mobile First-Entry Measurements', () => {
  test('Fresh guest experiences Splash -> Welcome -> Guest Browse -> Explore with mobile measurements', async ({ page }, testInfo) => {
    // 1. Ensure clean slate (no seen flag)
    await clearCustomerEntryState(page);
    await setupDeterministicApi(page);

    // 2. Navigate to customer application
    await page.goto('/');

    // 3. Splash screen appears and displays brand recognition
    const splashOrWelcome = page.locator('[role="status"][aria-label="كونفرم"], [role="main"][aria-label="مرحبًا بك في كونفرم"]');
    await expect(splashOrWelcome.first()).toBeVisible({ timeout: 5000 });

    // 4. Welcome screen appears
    const welcomeScreen = page.locator('[role="main"][aria-label="مرحبًا بك في كونفرم"]');
    await expect(welcomeScreen).toBeVisible({ timeout: 7000 });

    // Measurements on Welcome screen
    await assertEffectiveRtl(welcomeScreen);
    await assertNoHorizontalOverflow(page);

    // Verify Arabic copy and brand elements on Welcome screen
    await expect(page.getByRole('heading', { name: 'اكتشف إقامتك المثالية على الساحل' })).toBeVisible();
    await expect(page.getByText('أسعار حقيقية وتواريخ متاحة بوضوح')).toBeVisible();

    // Verify Welcome CTAs and measure touch-target dimensions (>=44x44px)
    const guestBrowseBtn = page.getByRole('button', { name: 'تصفح كضيف', exact: true });
    const createAccountBtn = page.getByRole('button', { name: 'إنشاء حساب' });
    const loginBtn = page.getByRole('button', { name: 'تسجيل الدخول' });

    await assertMinimumTouchTarget(guestBrowseBtn, 44, 44);
    await assertMinimumTouchTarget(createAccountBtn, 44, 44);
    await assertMinimumTouchTarget(loginBtn, 44, 44);

    await expect(guestBrowseBtn).toBeEnabled();
    await expect(createAccountBtn).toBeEnabled();
    await expect(loginBtn).toBeEnabled();

    // Capture representative Welcome screenshot
    const viewportTag = `${testInfo.project.name.replace(/[^a-zA-Z0-9_-]/g, '_')}`;
    await captureEvidenceScreenshot(page, `01_guest_welcome_${viewportTag}.png`);

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
    const exploreHeading = page.getByRole('heading', { name: 'هتصيف فين؟' });
    await expect(exploreHeading).toBeVisible({ timeout: 5000 });
    await expect(page.getByRole('heading', { name: 'اكتشف الإقامات' })).toBeVisible();

    // Explore screen mobile measurements
    await assertEffectiveRtl(exploreHeading);
    await assertNoHorizontalOverflow(page);

    // 8. Verify property cards rendered from canonical search fixture
    const searchData = loadSearchFixture();
    const firstProperty = searchData.data[0];
    const secondProperty = searchData.data[1];

    await expect(page.getByText(firstProperty.title)).toBeVisible();
    await expect(page.getByText(secondProperty.title)).toBeVisible();

    // Verify card primary hit target satisfies touch dimension >= 44x44px
    const firstCardAction = page.getByRole('button', { name: `عرض تفاصيل ${firstProperty.title}` });
    await assertMinimumTouchTarget(firstCardAction, 44, 44);

    // Verify Arabic pricing format (Arabic-Indic numeral ٨٬٥٠٠ or 8,500, with currency and unit)
    await expect(page.getByText(/٨[٬,]٥٠٠|8,500/).first()).toBeVisible();
    await expect(page.getByText('ج.م').first()).toBeVisible();
    await expect(page.getByText('/ ليلة').first()).toBeVisible();

    // Verify facts row
    await expect(page.getByText(/6 ضيوف/).first()).toBeVisible();
    await expect(page.getByText(/3 غرف/).first()).toBeVisible();

    // Verify bottom navigation exists and does not obscure the page
    const bottomNav = page.locator('nav').last();
    if (await bottomNav.isVisible()) {
      await assertMinimumTouchTarget(page.getByRole('button', { name: 'استكشف' }), 44, 44);
    }

    // 9. Capture visual evidence of Explore feed
    await captureEvidenceScreenshot(page, `01_guest_discovery_explore_${viewportTag}.png`);

    // 10. Verify zero unexpected network egress occurred
    assertZeroUnexpectedRequests(page);
  });

  test('Returning guest with entry flag bypasses Splash and Welcome directly to Explore', async ({ page }, testInfo) => {
    // 1. Pre-seed returning customer flag
    await seedReturningCustomer(page);
    await setupDeterministicApi(page);

    // 2. Navigate to application
    await page.goto('/');

    // 3. Directly renders Explore view without presenting Welcome screen
    const exploreHeading = page.getByRole('heading', { name: 'هتصيف فين؟' });
    await expect(exploreHeading).toBeVisible({ timeout: 5000 });
    await expect(page.locator('[role="main"][aria-label="مرحبًا بك في كونفرم"]')).not.toBeVisible();

    // Measurements
    await assertEffectiveRtl(exploreHeading);
    await assertNoHorizontalOverflow(page);

    // Verify card is visible immediately
    const searchData = loadSearchFixture();
    await expect(page.getByText(searchData.data[0].title)).toBeVisible();

    // Capture visual evidence
    const viewportTag = `${testInfo.project.name.replace(/[^a-zA-Z0-9_-]/g, '_')}`;
    await captureEvidenceScreenshot(page, `01_returning_guest_bypass_${viewportTag}.png`);

    // Verify zero unexpected network egress
    assertZeroUnexpectedRequests(page);
  });
});
