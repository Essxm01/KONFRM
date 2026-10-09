import { test, expect } from '@playwright/test';
import {
  setupDeterministicApi,
  seedReturningCustomer,
  captureEvidenceScreenshot,
  loadSearchFixture,
  loadDetailFixture,
  assertEffectiveRtl,
  assertNoHorizontalOverflow,
  assertMinimumTouchTarget,
  assertZeroUnexpectedRequests,
} from '../helpers/test-harness';

test.describe('Smoke 02 — Property Details & Canonical Server Precedence', () => {
  test.beforeEach(async ({ page }) => {
    await seedReturningCustomer(page);
  });

  test('Selecting a property renders canonical detail with precedence, amenities, and clean back navigation', async ({ page }, testInfo) => {
    const searchSummary = loadSearchFixture().data[0];
    const detailData = loadDetailFixture().data;

    // Both fixtures share the exact same canonical property ID
    expect(searchSummary.id).toBe(detailData.id);

    // Intentional divergence: search summary has teaser fields, detail has authoritative server DTO
    expect(searchSummary.title).not.toBe(detailData.title);
    expect(searchSummary.basePricePerNight).not.toBe(detailData.basePricePerNight);
    expect(searchSummary.bedrooms).not.toBe(detailData.bedrooms);
    expect(searchSummary.maxGuests).not.toBe(detailData.maxGuests);

    // 1. Setup deterministic API with search, detail, and availability fixtures
    await setupDeterministicApi(page);

    // 2. Navigate to Explore
    await page.goto('/');
    const exploreHeading = page.getByRole('heading', { name: 'هتصيف فين؟' });
    await expect(exploreHeading).toBeVisible({ timeout: 5000 });

    // 3. Verify card in Explore displays SEARCH summary identity
    await expect(page.getByText(searchSummary.title)).toBeVisible();
    await expect(page.getByText(/٨[٬,]٥٠٠|8,500/).first()).toBeVisible();
    await expect(page.getByText(`${searchSummary.maxGuests} ضيوف`).first()).toBeVisible();

    // 4. Click the primary action on the property card matching the SEARCH title
    const firstCardAction = page.getByRole('button', { name: `عرض تفاصيل ${searchSummary.title}` });
    await expect(firstCardAction).toBeVisible();
    await assertMinimumTouchTarget(firstCardAction, 44, 44);
    await firstCardAction.click();

    // 5. Verify Property Details modal opens
    const backBtn = page.getByRole('button', { name: 'العودة' });
    await expect(backBtn).toBeVisible({ timeout: 5000 });
    await assertMinimumTouchTarget(backBtn, 44, 44);

    // Mobile measurements on Detail screen
    const detailTitle = page.getByRole('heading', { level: 1, name: detailData.title });
    await expect(detailTitle).toBeVisible();
    await assertEffectiveRtl(detailTitle);
    await assertNoHorizontalOverflow(page);

    // 6. PROVE CANONICAL DETAIL PRECEDENCE OVER SUMMARY:
    // A. Title: rendered modal reflects authoritative DETAIL title, NOT stale search summary
    await expect(page.getByRole('heading', { level: 1, name: searchSummary.title })).not.toBeVisible();

    // B. Nightly price: rendered price reflects authoritative DETAIL price (9,500 / ٩٬٥٠٠)
    await expect(page.getByText(/٩[٬,]٥٠٠|9,500/).first()).toBeVisible();

    // C. Property facts: rendered facts reflect authoritative DETAIL facts (8 guests, 4 bedrooms, 3 bathrooms)
    const factsRow = page.locator('.border-y.border-slate-100');
    await expect(factsRow.getByText(`${detailData.maxGuests} ضيوف`)).toBeVisible();
    await expect(factsRow.getByText(`${detailData.bedrooms} غرف`)).toBeVisible();
    await expect(factsRow.getByText(`${detailData.bathrooms} حمام`)).toBeVisible();

    // Stale summary facts must NOT be retained in the authoritative modal facts row
    await expect(factsRow.getByText(`${searchSummary.maxGuests} ضيوف`)).not.toBeVisible();
    await expect(factsRow.getByText(`${searchSummary.bedrooms} غرف`)).not.toBeVisible();

    // D. Description: detail-only field rendered truthfully
    await expect(page.getByRole('heading', { name: 'عن هذه الإقامة' })).toBeVisible();
    await expect(page.getByText(detailData.description)).toBeVisible();

    // E. Amenities: detail-only field rendered with localized Arabic labels
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

    // 7. Verify Sticky Decision Bar is visible and usable without covering critical content
    const selectDatesBtn = page.getByRole('button', { name: 'اختيار التواريخ' });
    await expect(selectDatesBtn).toBeVisible();
    await expect(selectDatesBtn).toBeEnabled();
    await assertMinimumTouchTarget(selectDatesBtn, 44, 44);
    await expect(page.getByText('السعر في الليلة').first()).toBeVisible();

    // Capture visual evidence of details view
    const viewportTag = `${testInfo.project.name.replace(/[^a-zA-Z0-9_-]/g, '_')}`;
    await captureEvidenceScreenshot(page, `02_property_details_view_${viewportTag}.png`);

    // 8. Test back button navigation
    await backBtn.click();

    // 9. Verify return to Explore screen preserving feed and original search summary identity
    await expect(exploreHeading).toBeVisible({ timeout: 5000 });
    await expect(detailTitle).not.toBeVisible();
    await expect(page.getByText(searchSummary.title)).toBeVisible();
    await expect(firstCardAction).toBeVisible();

    // 10. Verify zero unexpected network egress occurred
    assertZeroUnexpectedRequests(page);
  });

  test('Fail-closed error representation when detail API fails with 500', async ({ page }, testInfo) => {
    const searchSummary = loadSearchFixture().data[0];

    // 1. Setup API with 500 status on detail fetch
    await setupDeterministicApi(page, { detailStatus: 500 });

    // 2. Navigate to Explore
    await page.goto('/');
    const firstCardAction = page.getByRole('button', { name: `عرض تفاصيل ${searchSummary.title}` });
    await expect(firstCardAction).toBeVisible({ timeout: 5000 });

    // 3. Click property card
    await firstCardAction.click();

    // 4. Verify detail error alert is displayed truthfully without crashing
    const backBtn = page.getByRole('button', { name: 'العودة' });
    await expect(backBtn).toBeVisible({ timeout: 5000 });
    await assertMinimumTouchTarget(backBtn, 44, 44);
    await expect(page.getByText('تعذر تحميل بيانات الإقامة المطلوبة')).toBeVisible();

    // Disambiguated retry button on error view
    const retryBtn = page.getByRole('button', { name: 'إعادة المحاولة' }).first();
    await expect(retryBtn).toBeVisible();
    await expect(retryBtn).toBeEnabled();
    await assertMinimumTouchTarget(retryBtn, 44, 44);

    // Mobile measurements on error view
    await assertNoHorizontalOverflow(page);

    // Capture visual evidence of fail-closed error
    const viewportTag = `${testInfo.project.name.replace(/[^a-zA-Z0-9_-]/g, '_')}`;
    await captureEvidenceScreenshot(page, `02_detail_error_fail_closed_${viewportTag}.png`);

    // 5. Verify user can safely navigate back to Explore via the back button
    await backBtn.click();
    await expect(page.getByRole('heading', { name: 'هتصيف فين؟' })).toBeVisible({ timeout: 5000 });

    // 6. Verify zero unexpected network egress
    assertZeroUnexpectedRequests(page);
  });
});
