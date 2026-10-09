import { test, expect } from '@playwright/test';
import {
  setupDeterministicApi,
  seedReturningCustomer,
  captureEvidenceScreenshot,
  loadSearchFixture,
  assertEffectiveRtl,
  assertNoHorizontalOverflow,
  assertMinimumTouchTarget,
  assertZeroUnexpectedRequests,
} from '../helpers/test-harness';

test.describe('Smoke 03 — API Failure & Truthful Retry Recovery', () => {
  test.beforeEach(async ({ page }) => {
    await seedReturningCustomer(page);
  });

  test('Controlled 500 error displays truthful error view, and retry creates verified second request restoring inventory', async ({ page }, testInfo) => {
    const searchData = loadSearchFixture();
    let isInitialFailurePhase = true;
    let initialRequestsCount = 0;
    let retryRequestsCount = 0;

    // 1. Setup deterministic API with controlled request-level behavior:
    // Initial phase: returns 500 server error
    // Retry phase: returns 200 with recovered inventory
    await setupDeterministicApi(page, {
      onRequest: (type) => {
        if (type === 'search') {
          if (isInitialFailurePhase) {
            initialRequestsCount++;
            return {
              status: 500,
              body: {
                success: false,
                error: { message: 'تعذر الاتصال بالخادم حالياً. يرجى المحاولة لاحقاً.' },
              },
            };
          } else {
            retryRequestsCount++;
            return {
              status: 200,
              body: searchData,
            };
          }
        }
      },
    });

    // 2. Navigate to Explore
    await page.goto('/');

    // 3. Verify Truthful Error View is rendered on initial failure
    const errorHeading = page.getByRole('heading', { name: 'تعذر تحميل الإقامات' });
    await expect(errorHeading).toBeVisible({ timeout: 5000 });
    await expect(page.getByText(/تعذر الاتصال بالخادم/)).toBeVisible();

    // Verify initial search requests were made and were all failures
    expect(initialRequestsCount).toBeGreaterThanOrEqual(1);
    expect(retryRequestsCount).toBe(0);

    // Mobile measurements on error view
    await assertEffectiveRtl(errorHeading);
    await assertNoHorizontalOverflow(page);

    // Verify retry button exists and satisfies minimum touch-target size >= 44x44px
    const retryBtn = page.getByRole('button', { name: 'إعادة المحاولة' });
    await expect(retryBtn).toBeVisible();
    await expect(retryBtn).toBeEnabled();
    await assertMinimumTouchTarget(retryBtn, 44, 44);

    // Verify zero property cards are rendered during error state
    await expect(page.getByText(searchData.data[0].title)).not.toBeVisible();

    // Capture visual evidence of the error view
    const viewportTag = `${testInfo.project.name.replace(/[^a-zA-Z0-9_-]/g, '_')}`;
    await captureEvidenceScreenshot(page, `03_api_failure_error_view_${viewportTag}.png`);

    // 4. Resolve the simulated server issue before clicking retry
    isInitialFailurePhase = false;

    // Click "إعادة المحاولة" (Retry)
    await retryBtn.click();

    // 5. Verify error view disappears and valid property inventory is restored
    await expect(errorHeading).not.toBeVisible({ timeout: 5000 });
    await expect(page.getByRole('heading', { name: 'اكتشف الإقامات' })).toBeVisible();

    // STRICT PROOF: Verify the retry button triggered a distinct second request
    expect(retryRequestsCount).toBe(1);

    // Assert that the rendered inventory reflects the recovered response
    await expect(page.getByText(searchData.data[0].title)).toBeVisible();
    await expect(page.getByText(searchData.data[1].title)).toBeVisible();

    // Verify count label and Arabic numerals
    await expect(page.getByText('إقامتان')).toBeVisible();

    // Mobile measurements on recovered view
    await assertNoHorizontalOverflow(page);

    // Capture visual evidence of recovered state
    await captureEvidenceScreenshot(page, `03_api_failure_recovered_${viewportTag}.png`);

    // 6. Verify zero unexpected network egress occurred
    assertZeroUnexpectedRequests(page);
  });
});
