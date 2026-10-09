import { defineConfig, devices } from '@playwright/test';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

export default defineConfig({
  testDir: './tests',
  fullyParallel: false,
  forbidOnly: Boolean(process.env.CI),
  retries: process.env.CI ? 1 : 0,
  workers: 1,
  reporter: [
    ['list'],
    ['html', { outputFolder: 'playwright-report', open: 'never' }],
    ['junit', { outputFile: 'test-results/junit.xml' }],
  ],
  use: {
    baseURL: 'http://localhost:5175',
    trace: 'retain-on-failure',
    screenshot: 'only-on-failure',
    locale: 'ar-EG',
    timezoneId: 'Africa/Cairo',
    serviceWorkers: 'block',
  },
  projects: [
    {
      name: 'Mobile-390x844-Default',
      use: {
        ...devices['Desktop Chrome'],
        viewport: { width: 390, height: 844 },
        deviceScaleFactor: 2,
        isMobile: true,
        hasTouch: true,
      },
    },
    {
      name: 'Mobile-360x800-Compact',
      use: {
        ...devices['Desktop Chrome'],
        viewport: { width: 360, height: 800 },
        deviceScaleFactor: 2,
        isMobile: true,
        hasTouch: true,
      },
    },
    {
      name: 'Mobile-430x932-Max',
      use: {
        ...devices['Desktop Chrome'],
        viewport: { width: 430, height: 932 },
        deviceScaleFactor: 3,
        isMobile: true,
        hasTouch: true,
      },
    },
  ],
  webServer: {
    command: 'npm run dev -- --port 5175',
    cwd: path.resolve(__dirname, '../../customer-app'),
    url: 'http://localhost:5175',
    reuseExistingServer: false,
    timeout: 60000,
  },
});
