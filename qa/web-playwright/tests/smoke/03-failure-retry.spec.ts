import { test, expect } from '@playwright/test';
import {
  seedReturningCustomer,
  captureEvidenceScreenshot,
  loadSearchFixture,
} from '../helpers/test-harness';

test.describe('Smoke 03 — API Failure & Truthful Retry Recovery', () => {
  test.beforeEach(async ({ page }) => {
    await seedReturningCustomer(page);
  });

  test('Controlled 500 error displays truthful error view, and retry recovers valid inventory', async ({ page }, testInfo) => {
    let returnError = true;
    const searchData = loadSearchFixture();

    // 1. Intercept search route with controllable error switch
    await page.route('**/api/v1/customer/properties/search*', async (route) => {
      if (returnError) {
        await route.fulfill({
          status: 500,
          contentType: 'application/json',
          body: JSON.stringify({
            success: false,
            error: { message: 'تعذر الاتصال بالخادم حالياً. يرجى المحاولة لاحقاً.' },
          }),
        });
      } else {
        await route.fulfill({
          status: 200,
          contentType: 'application/json',
          body: JSON.stringify(searchData),
        });
      }
    });

    // Block external images cleanly
    await page.route('https://images.unsplash.com/**', async (route) => {
      await route.fulfill({
        status: 200,
        contentType: 'image/gif',
        body: Buffer.from('R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7', 'base64'),
      });
    });

    // 2. Navigate to Explore
    await page.goto('/');

    // 3. Verify Truthful Error View is rendered
    const errorHeading = page.getByRole('heading', { name: 'تعذر تحميل الإقامات' });
    await expect(errorHeading).toBeVisible({ timeout: 5000 });
    await expect(page.getByText('تعذر الاتصال بالخادم حالياً')).toBeVisible();

    // Verify retry button exists and zero property cards are rendered
    const retryBtn = page.getByRole('button', { name: 'إعادة المحاولة' });
    await expect(retryBtn).toBeVisible();
    await expect(page.getByText(searchData.data[0].title)).not.toBeVisible();

    // Capture visual evidence of the error view
    const viewportTag = `${testInfo.project.name.replace(/[^a-zA-Z0-9_-]/g, '_')}`;
    await captureEvidenceScreenshot(page, `03_api_failure_error_view_${viewportTag}.png`);

    // 4. Resolve the backend issue: toggle switch to return 200 SUCCESS
    returnError = false;

    // 5. Click "إعادة المحاولة" (Retry)
    await retryBtn.click();

    // 6. Verify error view disappears and valid property inventory is restored
    await expect(errorHeading).not.toBeVisible({ timeout: 5000 });
    await expect(page.getByRole('heading', { name: 'اكتشف الإقامات' })).toBeVisible();
    await expect(page.getByText(searchData.data[0].title)).toBeVisible();
    await expect(page.getByText(searchData.data[1].title)).toBeVisible();

    // Verify count label
    await expect(page.getByText('إقامتان')).toBeVisible();

    // Capture visual evidence of recovered state
    await captureEvidenceScreenshot(page, `03_api_failure_recovered_${viewportTag}.png`);
  });
});
