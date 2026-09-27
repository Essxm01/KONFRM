// @ts-ignore The lightweight script runs under Node through the repository's tsx harness.
import { readFileSync } from 'node:fs';
import {
  CustomerNotificationsUnauthorizedError,
  fetchCustomerNotifications,
  fetchCustomerUnreadNotificationCount,
  markCustomerNotificationRead,
  validateNotificationItem,
  type CustomerNotificationItem,
} from './customerNotifications';
import {
  CUSTOMER_NOTIFICATIONS_COPY,
  getNotificationTitle,
  getNotificationBody,
  formatUnreadCountBadge,
  formatNotificationTime,
  notificationListStateAfterLoad,
  mergeNotificationPages,
  markNotificationReadLocally,
  decrementUnreadCountLocally,
  shouldKeepNotificationsAfterRefreshFailure,
  notificationFailureState,
  shouldRenderNotificationFeed,
  shouldApplyNotificationResponse,
  notificationInitialStateForSession,
  notificationListStateAfterLoadMore,
  applySuccessfulNotificationRead,
} from './customerScreen16Notifications';

declare const process: { exitCode?: number };

function assert(condition: unknown, message: string): asserts condition {
  if (!condition) throw new Error(message);
}

function jsonResponse(status: number, body: unknown): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { 'Content-Type': 'application/json' },
  });
}

const mockItem = (overrides: Partial<CustomerNotificationItem> = {}): CustomerNotificationItem => ({
  notificationId: '11111111-1111-4111-8111-111111111111',
  eventType: 'BOOKING_APPROVED_PENDING_PAYMENT',
  bookingId: '22222222-2222-4222-8222-222222222222',
  propertyTitle: 'شاليه لؤلؤة البحر',
  createdAt: '2026-09-26T18:00:00.000Z',
  isRead: false,
  actionRequired: true,
  ...overrides,
});

async function run(): Promise<void> {
  console.log('Running Customer Screen 16 Notifications Test Suite...');

  const appSource = readFileSync(new URL('../App.tsx', import.meta.url), 'utf8').replace(/\r\n/g, '\n');
  const componentSource = readFileSync(new URL('../components/CustomerNotificationCenter.tsx', import.meta.url), 'utf8').replace(/\r\n/g, '\n');
  const helperSource = readFileSync(new URL('./customerScreen16Notifications.ts', import.meta.url), 'utf8').replace(/\r\n/g, '\n');
  const clientSource = readFileSync(new URL('./customerNotifications.ts', import.meta.url), 'utf8').replace(/\r\n/g, '\n');
  const authSource = readFileSync(new URL('./customerAuthV2.ts', import.meta.url), 'utf8').replace(/\r\n/g, '\n');
  const headerSource = readFileSync(new URL('../components/CustomerHeader.tsx', import.meta.url), 'utf8').replace(/\r\n/g, '\n');
  const bottomNavSource = readFileSync(new URL('../components/CustomerBottomNav.tsx', import.meta.url), 'utf8').replace(/\r\n/g, '\n');

  // ==========================================
  // 1. ARCHITECTURE & SCREEN 03 PROTECTION CONTRACTS
  // ==========================================

  // App must delegate Screen 16 presentation to CustomerNotificationCenter
  assert(appSource.includes("import { CustomerNotificationCenter }"), 'App must import CustomerNotificationCenter');
  assert(appSource.includes('<CustomerNotificationCenter'), 'App must render CustomerNotificationCenter component');

  // Client source must use backend endpoints and never direct Supabase
  assert(clientSource.includes('/customer/notifications'), 'Client must query canonical /customer/notifications endpoint');
  assert(clientSource.includes('/customer/notifications/unread-count'), 'Client must query canonical unread-count endpoint');
  assert(!clientSource.includes('supabase') && !clientSource.includes('@supabase'), 'Client must never call Supabase directly');

  // Account entry section & row
  assert(appSource.includes('النشاط'), 'Account screen must contain Section: النشاط');
  assert(appSource.includes('الإشعارات'), 'Account screen must contain Row: الإشعارات');
  assert(appSource.includes('تحديثات مهمة على طلباتك وحجوزاتك'), 'Account screen must contain subtitle copy');

  // Strict Screen 03 (Explore) & Header Protection: NO bell icon or notification badge in Header or Explore
  assert(!headerSource.includes('Bell'), 'CustomerHeader must NOT contain Bell icon');
  assert(!headerSource.includes('notifications'), 'CustomerHeader must NOT contain notification navigation');
  assert(!appSource.includes('<Bell'), 'App.tsx must NOT contain <Bell tag directly (Screen 03 contract)');

  // Exactly 4 Bottom Nav tabs: EXPLORE, FAVORITES, BOOKINGS, ACCOUNT (NO 5th tab)
  assert(bottomNavSource.includes("'EXPLORE'") && bottomNavSource.includes("'FAVORITES'") && bottomNavSource.includes("'BOOKINGS'") && bottomNavSource.includes("'ACCOUNT'"), 'BottomNav must maintain the canonical 4 tabs');
  assert(!bottomNavSource.includes('NOTIFICATIONS') && !bottomNavSource.includes('NOTIFICATION'), 'BottomNav must NEVER contain a 5th notifications tab');

  // AuthOrigin extension
  assert(authSource.includes("{ type: 'NOTIFICATION_CENTER' }"), 'AuthOrigin must include NOTIFICATION_CENTER variant');
  assert(appSource.includes("origin.type === 'NOTIFICATION_CENTER'"), 'App must handle NOTIFICATION_CENTER origin resumption');

  // Screen 13 return contract
  assert(appSource.includes("const wasFromNotifications = bookingDetailOrigin === 'NOTIFICATION_CENTER'"), 'Screen 13 onBack must check if opened from Notification Center');

  // Privacy: Logout clears all notification state
  assert(appSource.includes('setIsNotificationCenterOpen(false)'), 'Logout must reset isNotificationCenterOpen');
  assert(appSource.includes('setNotifications([])'), 'Logout/Unauthorized must clear notifications list');
  assert(appSource.includes('setUnreadNotificationCount(null)'), 'Logout/Unauthorized must clear unread count');

  // ==========================================
  // 2. COPY & TRUTHFULNESS CONTRACTS
  // ==========================================

  // Canonical copy constants
  assert(CUSTOMER_NOTIFICATIONS_COPY.title === 'الإشعارات', 'Title copy must be الإشعارات');
  assert(CUSTOMER_NOTIFICATIONS_COPY.approvalTitle === 'وافق المالك على طلب الحجز', 'Approval title must be وافق المالك على طلب الحجز');
  assert(CUSTOMER_NOTIFICATIONS_COPY.rejectionTitle === 'لم يوافق المالك على طلب الحجز', 'Rejection title must be لم يوافق المالك على طلب الحجز');
  assert(CUSTOMER_NOTIFICATIONS_COPY.actionRequiredBadge === 'مطلوب إجراء: دفع العربون', 'Action required badge text must match');

  // Titles
  assert(getNotificationTitle('BOOKING_APPROVED_PENDING_PAYMENT') === 'وافق المالك على طلب الحجز', 'Title for approval event');
  assert(getNotificationTitle('BOOKING_REJECTED') === 'لم يوافق المالك على طلب الحجز', 'Title for rejection event');

  // Suffix & Body formatting
  const approvalItem = mockItem({
    eventType: 'BOOKING_APPROVED_PENDING_PAYMENT',
    propertyTitle: 'شاليه على البحر',
  });
  const approvalBody = getNotificationBody(approvalItem);
  assert(approvalBody.includes('شاليه على البحر'), 'Body must contain property title');
  assert(approvalBody.includes('أصبح دفع العربون الخطوة التالية لتأكيد الحجز.'), 'Body must contain approval suffix');
  // CRITICAL TRUTHFULNESS: NEVER say "تم تأكيد الحجز"
  assert(!approvalBody.includes('تم تأكيد الحجز'), 'Approval copy must NEVER state that booking is confirmed');
  assert(!helperSource.includes('تم تأكيد الحجز'), 'Helper file must NEVER state that booking is confirmed');
  assert(!componentSource.includes('تم تأكيد الحجز'), 'Component file must NEVER state that booking is confirmed');

  const rejectionItem = mockItem({
    eventType: 'BOOKING_REJECTED',
    propertyTitle: 'شاليه رقم 5',
  });
  const rejectionBody = getNotificationBody(rejectionItem);
  assert(rejectionBody.includes('شاليه رقم 5'), 'Rejection body must contain property title');
  assert(rejectionBody.includes('افتح الحجز لمراجعة التفاصيل.'), 'Rejection body must contain rejection suffix');

  // When property title is null or empty
  const noTitleApproval = mockItem({ propertyTitle: null });
  assert(getNotificationBody(noTitleApproval) === 'أصبح دفع العربون الخطوة التالية لتأكيد الحجز.', 'Approval body without title');

  // Badge formatting rules
  assert(formatUnreadCountBadge(null) === null, 'null unread count hides badge');
  assert(formatUnreadCountBadge(0) === null, '0 unread count hides badge');
  assert(formatUnreadCountBadge(-5) === null, 'negative unread count hides badge');
  assert(formatUnreadCountBadge(1) === '1', '1 unread count displays 1');
  assert(formatUnreadCountBadge(5) === '5', '5 unread count displays 5');
  assert(formatUnreadCountBadge(9) === '9', '9 unread count displays 9');
  assert(formatUnreadCountBadge(10) === '9+', '10 unread count displays 9+');
  assert(formatUnreadCountBadge(99) === '9+', '99 unread count displays 9+');

  // Timestamp formatting
  const formattedTime = formatNotificationTime('2026-09-26T18:00:00.000Z');
  assert(typeof formattedTime === 'string' && formattedTime.length > 0, 'Timestamp formatting must produce valid Arabic string');

  // ==========================================
  // 3. STRICT DTO VALIDATION (FAIL-CLOSED)
  // ==========================================

  // Valid item passes
  const valid = validateNotificationItem(mockItem());
  assert(valid.notificationId === '11111111-1111-4111-8111-111111111111', 'Valid item retained');
  assert(valid.actionRequired === true, 'Valid actionRequired retained');

  // Rejection item with actionRequired: false
  const validRejection = validateNotificationItem(mockItem({
    eventType: 'BOOKING_REJECTED',
    actionRequired: false,
  }));
  assert(validRejection.eventType === 'BOOKING_REJECTED', 'Valid rejection item parsed');

  // Invalid cases must throw fail-closed
  let threw = false;
  try { validateNotificationItem(null); } catch { threw = true; }
  assert(threw, 'null item throws');

  threw = false;
  try { validateNotificationItem({ ...mockItem(), notificationId: 'bad-uuid' }); } catch { threw = true; }
  assert(threw, 'invalid notificationId UUID throws');

  threw = false;
  try { validateNotificationItem({ ...mockItem(), bookingId: 'not-a-uuid' }); } catch { threw = true; }
  assert(threw, 'invalid bookingId UUID throws');

  threw = false;
  try { validateNotificationItem({ ...mockItem(), eventType: 'UNKNOWN_EVENT' as any }); } catch { threw = true; }
  assert(threw, 'unsupported eventType throws');

  threw = false;
  try { validateNotificationItem({ ...mockItem(), createdAt: 'not-a-date' }); } catch { threw = true; }
  assert(threw, 'invalid createdAt throws');

  threw = false;
  try { validateNotificationItem({ ...mockItem(), createdAt: 'September 26, 2026 18:00 UTC' }); } catch { threw = true; }
  assert(threw, 'human-readable date is rejected');

  threw = false;
  try { validateNotificationItem({ ...mockItem(), createdAt: '2026-09-26 18:00:00+00:00' }); } catch { threw = true; }
  assert(threw, 'non-RFC3339 timestamp is rejected');

  assert(validateNotificationItem(mockItem({ createdAt: '2026-09-26T18:00:00+03:00' })).createdAt.includes('T'), 'RFC3339 timestamp is accepted');

  threw = false;
  try { validateNotificationItem({ ...mockItem(), isRead: 'true' as any }); } catch { threw = true; }
  assert(threw, 'non-boolean isRead throws');

  threw = false;
  try { validateNotificationItem({ ...mockItem(), actionRequired: 'false' as any }); } catch { threw = true; }
  assert(threw, 'non-boolean actionRequired throws');

  // ==========================================
  // 4. API CLIENT CALLS & TYPED 401/403 HANDLING
  // ==========================================

  // fetchCustomerNotifications success
  const mockFetchNotifications = async (_url: RequestInfo | URL, init?: RequestInit) => {
    assert((init?.headers as any)?.Authorization === 'Bearer test-token', 'Bearer token passed');
    return jsonResponse(200, {
      success: true,
      data: {
        items: [mockItem()],
        nextCursor: 'cursor-123',
      },
    });
  };
  const testGetUrl = (path: string) => path;
  const pageResult = await fetchCustomerNotifications('test-token', { limit: 10 }, mockFetchNotifications, testGetUrl);
  assert(pageResult.items.length === 1, 'Page returns 1 item');
  assert(pageResult.nextCursor === 'cursor-123', 'nextCursor is cursor-123');

  // fetchCustomerNotifications 401
  let unauthorizedCaught = false;
  try {
    await fetchCustomerNotifications(
      'expired-token',
      {},
      async () => jsonResponse(401, { success: false, error: { message: 'Unauthorized' } }),
      testGetUrl,
    );
  } catch (err) {
    unauthorizedCaught = err instanceof CustomerNotificationsUnauthorizedError;
  }
  assert(unauthorizedCaught, 'fetchCustomerNotifications on 401 throws CustomerNotificationsUnauthorizedError');

  // fetchCustomerUnreadNotificationCount success
  const mockFetchCount = async () => jsonResponse(200, {
    success: true,
    data: { unreadCount: 3 },
  });
  const unreadCount = await fetchCustomerUnreadNotificationCount('test-token', mockFetchCount, testGetUrl);
  assert(unreadCount === 3, 'Unread count is 3');

  for (const malformed of [1.5, Number.NaN, Number.POSITIVE_INFINITY, -1]) {
    threw = false;
    try {
      await fetchCustomerUnreadNotificationCount('test-token', async () => jsonResponse(200, { success: true, data: { unreadCount: malformed } }), testGetUrl);
    } catch { threw = true; }
    assert(threw, `malformed unread count ${String(malformed)} is rejected`);
  }

  // fetchCustomerUnreadNotificationCount 403
  unauthorizedCaught = false;
  try {
    await fetchCustomerUnreadNotificationCount(
      'expired-token',
      async () => jsonResponse(403, { success: false, error: { message: 'Forbidden' } }),
      testGetUrl,
    );
  } catch (err) {
    unauthorizedCaught = err instanceof CustomerNotificationsUnauthorizedError;
  }
  assert(unauthorizedCaught, 'fetchCustomerUnreadNotificationCount on 403 throws CustomerNotificationsUnauthorizedError');

  // markCustomerNotificationRead success
  const mockMarkRead = async (url: RequestInfo | URL, init?: RequestInit) => {
    assert(String(url).includes('/11111111-1111-4111-8111-111111111111/read'), 'URL contains notificationId');
    assert(init?.method === 'POST', 'Method is POST');
    return jsonResponse(200, {
      success: true,
      data: {
        notificationId: '11111111-1111-4111-8111-111111111111',
        isRead: true,
      },
    });
  };
  const markResult = await markCustomerNotificationRead('test-token', '11111111-1111-4111-8111-111111111111', mockMarkRead, testGetUrl);
  assert(markResult.notificationId === '11111111-1111-4111-8111-111111111111', 'Notification marked read');
  assert(markResult.isRead === true, 'isRead is true');

  // markCustomerNotificationRead 401
  unauthorizedCaught = false;
  try {
    await markCustomerNotificationRead(
      'expired-token',
      '11111111-1111-4111-8111-111111111111',
      async () => jsonResponse(401, { success: false }),
      testGetUrl,
    );
  } catch (err) {
    unauthorizedCaught = err instanceof CustomerNotificationsUnauthorizedError;
  }
  assert(unauthorizedCaught, 'markCustomerNotificationRead on 401 throws CustomerNotificationsUnauthorizedError');

  // ==========================================
  // 5. LOCAL STATE & PAGINATION HELPERS
  // ==========================================

  // notificationListStateAfterLoad
  assert(notificationListStateAfterLoad([]) === 'EMPTY', 'Empty items give EMPTY state');
  assert(notificationListStateAfterLoad([mockItem()]) === 'LOADED', 'Non-empty items give LOADED state');

  // mergeNotificationPages: deduplication and ordering
  const itemA = mockItem({
    notificationId: 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa',
    createdAt: '2026-09-26T10:00:00.000Z',
  });
  const itemB = mockItem({
    notificationId: 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb',
    createdAt: '2026-09-26T12:00:00.000Z',
  });
  const itemAUpdated = mockItem({
    notificationId: 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa',
    createdAt: '2026-09-26T10:00:00.000Z',
    isRead: true,
  });

  const merged = mergeNotificationPages([itemA], [itemB, itemAUpdated]);
  assert(merged.length === 2, 'Deduplication by notificationId results in 2 items');
  assert(merged[0].notificationId === 'bbbbbbbb-bbbb-4bbb-8bbb-bbbbbbbbbbbb', 'Newer item B is first');
  assert(merged[1].notificationId === 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa', 'Older item A is second');
  assert(merged[1].isRead === true, 'Updated incoming item overwritten');

  // markNotificationReadLocally
  const readLocally = markNotificationReadLocally([itemA], 'aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa');
  assert(readLocally[0].isRead === true, 'Item marked as read locally');

  // decrementUnreadCountLocally
  assert(decrementUnreadCountLocally(null) === null, 'null stays null');
  assert(decrementUnreadCountLocally(0) === 0, '0 stays 0');
  assert(decrementUnreadCountLocally(1) === 0, '1 decrements to 0');
  assert(decrementUnreadCountLocally(5) === 4, '5 decrements to 4');

  // shouldKeepNotificationsAfterRefreshFailure
  assert(shouldKeepNotificationsAfterRefreshFailure([itemA], false) === true, 'Keep items on network error');
  assert(shouldKeepNotificationsAfterRefreshFailure([itemA], true) === false, 'Do not keep items on unauthorized');
  assert(shouldKeepNotificationsAfterRefreshFailure([], false) === false, 'Do not keep if list was empty');
  assert(notificationFailureState(true, false).loadState === 'STALE_ERROR', 'same-session safe list failure becomes STALE_ERROR');
  assert(notificationFailureState(true, false).preserveItems === true, 'STALE_ERROR preserves the safe list');
  assert(notificationFailureState(false, false).loadState === 'ERROR', 'failure without a safe list becomes ERROR');
  assert(notificationFailureState(false, false).preserveItems === false, 'ERROR does not preserve unavailable data');
  assert(notificationFailureState(true, true).loadState === 'SESSION_EXPIRED', 'unauthorized failure becomes SESSION_EXPIRED');
  assert(notificationFailureState(true, true).preserveItems === false, 'SESSION_EXPIRED clears private data');
  assert(shouldRenderNotificationFeed('ERROR', 1) === false, 'ERROR never renders notification cards');
  assert(shouldRenderNotificationFeed('STALE_ERROR', 1) === true, 'STALE_ERROR preserves notification cards');
  assert(shouldRenderNotificationFeed('EMPTY', 0) === false, 'EMPTY has no notification cards');

  // P9.2 executable authority guards: old sessions, old requests, and older
  // mutations cannot overwrite a newer canonical response.
  assert(shouldApplyNotificationResponse(2, 2, 4, 4, 'token-b', 'token-b'), 'current response is applicable');
  assert(!shouldApplyNotificationResponse(1, 2, 4, 4, 'token-a', 'token-b'), 'stale session response is ignored');
  assert(!shouldApplyNotificationResponse(1, 2, 4, 4, 'token-b', 'token-b'), 'older request response is ignored');
  assert(!shouldApplyNotificationResponse(2, 2, 3, 4, 'token-b', 'token-b'), 'response before newer mutation is ignored');
  assert(notificationInitialStateForSession('token-a', 'token-b', [itemA]) === 'INITIAL_LOADING', 'new session clears old list before loading');
  assert(notificationInitialStateForSession('token-b', 'token-b', [itemA]) === 'REFRESHING', 'same-session refresh preserves safe list');
  assert(notificationListStateAfterLoadMore([]) === 'EMPTY', 'load-more empty canonical list resolves EMPTY');
  assert(notificationListStateAfterLoadMore([itemA]) === 'LOADED', 'load-more non-empty canonical list resolves LOADED');

  // Read truthfulness: a read item does not decrement the count; an unread
  // item decrements once only after the server mutation succeeds.
  const alreadyRead = applySuccessfulNotificationRead([itemAUpdated], 2, itemAUpdated.notificationId, false);
  assert(alreadyRead.items[0].isRead === true && alreadyRead.unreadCount === 2, 'already-read notification does not decrement count');
  const newlyRead = applySuccessfulNotificationRead([itemA], 2, itemA.notificationId, true);
  assert(newlyRead.items[0].isRead === true && newlyRead.unreadCount === 1, 'successful unread mutation decrements exactly once');
  assert(decrementUnreadCountLocally(0) === 0, 'unread count never becomes negative');

  // ==========================================
  // 6. ACCESSIBILITY & TOUCH TARGETS
  // ==========================================

  // Heading focus
  assert(componentSource.includes('headingRef.current?.focus()'), 'Component must focus heading on mount');
  assert(componentSource.includes('id="customer-notifications-heading"'), 'Heading must have id for aria-labelledby');
  assert(componentSource.includes('aria-labelledby="customer-notifications-heading"'), 'Section must reference heading');

  // Touch targets >= 44px
  assert(componentSource.includes('min-h-[44px] min-w-[44px]'), 'Back button must have min 44x44px touch target');
  assert(componentSource.includes('min-h-[48px]'), 'Feed cards must have min 48px height');
  assert(componentSource.includes('min-h-[52px]'), 'Primary CTAs must have min 52px height');

  // Source-level guard complements the pure state tests: navigation is
  // scheduled before the async mutation and optimistic local read updates do
  // not occur in the click handler.
  assert(appSource.indexOf("setBookingDetailId(item.bookingId)") < appSource.indexOf('markCustomerNotificationRead(token'), 'Screen 13 navigation is immediate');
  assert(appSource.includes('notificationReadInFlightRef'), 'read mutations are de-duplicated');
  assert(appSource.includes('setIsLoadingMoreNotifications(false)'), 'load-more terminal state is reset');
  assert(appSource.includes("clearNotificationPrivateState('SESSION_EXPIRED')"), 'unauthorized notification work enters SESSION_EXPIRED');
  assert(appSource.includes('preserveSafeListOnFailure'), 'load failure remembers whether a safe list existed at request start');
  assert(componentSource.includes('shouldRenderNotificationFeed'), 'notification feed rendering is guarded by truthful load state');
  assert(!componentSource.includes('error || CUSTOMER_NOTIFICATIONS_COPY.errorDescription'), 'technical error details never render as customer copy');
  assert(componentSource.includes('CUSTOMER_NOTIFICATIONS_COPY.errorDescription'), 'hard errors use customer-safe Arabic copy');
  assert(!componentSource.includes('FETCH_CUSTOMER_NOTIFICATIONS_FAILED: HTTP 500'), 'internal fetch exception text never reaches customer UI');
  assert(!appSource.includes('setUnreadNotificationCount((prev) => decrementUnreadCountLocally(prev))'), 'unread count is not optimistically decremented');
  assert(!componentSource.includes('amber'), 'CustomerNotificationCenter must NOT contain any amber classes');
  assert(componentSource.includes('CUSTOMER_NOTIFICATIONS_COPY.actionRequiredBadge'), 'actionRequired badge must be present');
  const actionBadgeClass = ['bg-white text-[', '#', '0059FF] border border-[', '#', '0059FF]'].join('');
  assert(componentSource.includes(actionBadgeClass), 'actionRequired badge must have distinct outlined action styling');
  assert(componentSource.includes('aria-label={CUSTOMER_NOTIFICATIONS_COPY.backToAccount}'), 'Compact header must expose accessible back label');
  assert(componentSource.includes('ChevronRight'), 'Compact nested header must use ChevronRight');
  assert(componentSource.includes('text-lg font-black'), 'Compact header uses restrained text-lg font-black title');
  assert(!appSource.includes('text-amber-800') && !appSource.includes('bg-amber-50') && !appSource.includes('text-amber-600') && !appSource.includes('bg-amber-600'), 'App.tsx must not contain legacy amber Account Home patterns');

  console.log('ALL CUSTOMER SCREEN 16 NOTIFICATIONS TESTS PASSED (100%)!');
}

run().catch((error) => {
  console.error('SCREEN 16 TEST SUITE FAILURE:', error);
  process.exitCode = 1;
});
