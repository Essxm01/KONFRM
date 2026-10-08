import { test, expect } from '@playwright/test';
import {
  setupDeterministicApi,
  seedReturningCustomer,
} from '../helpers/test-harness';

test.describe('Negative Control — Controlled UI Assertion Proof', () => {
  test('Controlled assertion behavior under corrupted vs cured expectation', async ({ page }) => {
    await seedReturningCustomer(page);
    await setupDeterministicApi(page);

    await page.goto('/');

    const mode = process.env.TAMPERED_NEGATIVE_TEST || 'CURED';

    if (mode === 'CORRUPTED') {
      // Deliberately assert a non-existent heading to prove the assertion fails and cannot pass vacuously
      const badHeading = page.getByRole('heading', { name: 'عنوان غير موجود نهائياً في النظام' });
      await expect(badHeading).toBeVisible({ timeout: 2000 });
    } else {
      // Cured expectation: asserts the true heading
      const trueHeading = page.getByRole('heading', { name: 'هتصيف فين؟' });
      await expect(trueHeading).toBeVisible({ timeout: 5000 });
    }
  });
});
