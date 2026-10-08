import { test, expect } from '@playwright/test';
import {
  setupDeterministicApi,
  seedReturningCustomer,
  captureEvidenceScreenshot,
  loadDetailFixture,
} from '../helpers/test-harness';

test.describe('Smoke 02 — Property Details & Server Precedence', () => {
  test.beforeEach(async ({ page }) => {
    await seedReturningCustomer(page);
  });

  test('Selecting a property renders canonical detail with precedence, amenities, and clean back navigation', async ({ page }, testInfo) => {
    const detailData = loadDetailFixture().data;

    // 1. Setup deterministic API with search and detail fixtures
    await setupDeterministicApi(page);

    // 2. Navigate to Explore
    await page.goto('/');
    await expect(page.getByRole('heading', { name: 'هتصيف فين؟' })).toBeVisible({ timeout: 5000 });

    // 3. Click the primary action on the first property card
    const firstCardAction = page.getByRole('button', { name: `عرض تفاصيل ${detailData.title}` });
    await expect(firstCardAction).toBeVisible();
    await firstCardAction.click();

    // 4. Verify Property Details modal opens
    const backBtn = page.getByRole('button', { name: 'العودة' });
    await expect(backBtn).toBeVisible({ timeout: 5000 });

    // 5. Verify Detail Title (h1) and Pricing inside details screen
    const detailTitle = page.getByRole('heading', { level: 1, name: detailData.title });
    await expect(detailTitle).toBeVisible();
    await expect(page.getByText(/٨[٬,]٥٠٠|8,500/).first()).toBeVisible();

    // 6. Verify Detail Precedence Over Summary:
    // Description exists in the detail DTO but not in the search summary
    await expect(page.getByRole('heading', { name: 'عن هذه الإقامة' })).toBeVisible();
    await expect(page.getByText(detailData.description)).toBeVisible();

    // Amenities exist in the detail DTO and render localized Arabic labels
    await expect(page.getByRole('heading', { name: 'المميزات والخدمات' })).toBeVisible();
    await expect(page.getByText('حمام سباحة')).toBeVisible();
    await expect(page.getByText('تكييف مركزي')).toBeVisible();
    await expect(page.getByText('واي فاي')).toBeVisible();
    await expect(page.getByText('مطبخ مجهز')).toBeVisible();

    // Verify amenities expansion toggle
    const expandAmenitiesBtn = page.getByRole('button', { name: /عرض كل المرافق/ });
    if (await expandAmenitiesBtn.isVisible()) {
      await expandAmenitiesBtn.click();
      await expect(page.getByText('أمن وحراسة')).toBeVisible();
    }

    // 7. Verify Sticky Decision Bar is visible with truthful initial state (Select Dates CTA)
    await expect(page.getByRole('button', { name: 'اختيار التواريخ' })).toBeVisible();
    await expect(page.getByText('السعر في الليلة').first()).toBeVisible();

    // Capture visual evidence of details view
    const viewportTag = `${testInfo.project.name.replace(/[^a-zA-Z0-9_-]/g, '_')}`;
    await captureEvidenceScreenshot(page, `02_property_details_view_${viewportTag}.png`);

    // 8. Test back button navigation
    await backBtn.click();

    // 9. Verify return to Explore screen preserving feed
    await expect(page.getByRole('heading', { name: 'هتصيف فين؟' })).toBeVisible({ timeout: 5000 });
    await expect(detailTitle).not.toBeVisible();
    await expect(firstCardAction).toBeVisible();
  });

  test('Fail-closed error representation when detail API fails with 500', async ({ page }, testInfo) => {
    const detailData = loadDetailFixture().data;

    // 1. Setup API with 500 status on detail fetch
    await setupDeterministicApi(page, { detailStatus: 500 });

    // 2. Navigate to Explore
    await page.goto('/');
    const firstCardAction = page.getByRole('button', { name: `عرض تفاصيل ${detailData.title}` });
    await expect(firstCardAction).toBeVisible({ timeout: 5000 });

    // 3. Click property card
    await firstCardAction.click();

    // 4. Verify detail error alert is displayed truthfully without crashing
    const backBtn = page.getByRole('button', { name: 'العودة' });
    await expect(backBtn).toBeVisible({ timeout: 5000 });
    await expect(page.getByText('تعذر تحميل بيانات الإقامة المطلوبة')).toBeVisible();

    // Disambiguated retry button on error view
    const retryBtn = page.getByRole('button', { name: 'إعادة المحاولة' }).first();
    await expect(retryBtn).toBeVisible();

    // Capture visual evidence of fail-closed error
    const viewportTag = `${testInfo.project.name.replace(/[^a-zA-Z0-9_-]/g, '_')}`;
    await captureEvidenceScreenshot(page, `02_detail_error_fail_closed_${viewportTag}.png`);

    // 5. Verify user can safely navigate back to Explore via the back button
    await backBtn.click();
    await expect(page.getByRole('heading', { name: 'هتصيف فين؟' })).toBeVisible({ timeout: 5000 });
  });
});
