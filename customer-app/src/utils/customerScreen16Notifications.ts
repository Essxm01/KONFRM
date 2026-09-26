import type {
  CustomerNotificationEventType,
  CustomerNotificationItem,
} from './customerNotifications';

export const CUSTOMER_NOTIFICATIONS_COPY = {
  title: 'الإشعارات',
  subtitle: 'تحديثات مهمة على طلباتك وحجوزاتك.',
  backToAccount: 'العودة إلى الحساب',
  accountRowTitle: 'الإشعارات',
  accountRowSubtitle: 'تحديثات مهمة على طلباتك وحجوزاتك',
  accountSectionTitle: 'النشاط',
  emptyTitle: 'لا توجد إشعارات حتى الآن',
  emptyDescription: 'ستظهر هنا التحديثات الخاصة بطلبات الحجز وحالتها فور وصولها.',
  loading: 'جارٍ تحميل الإشعارات...',
  loadingMore: 'جارٍ تحميل المزيد...',
  loadMore: 'تحميل المزيد',
  errorTitle: 'تعذر تحميل الإشعارات',
  errorDescription: 'تحقق من اتصالك بالإنترنت وحاول مرة أخرى.',
  errorAction: 'إعادة المحاولة',
  stale: 'تعذر تحديث الإشعارات. تظهر آخر قائمة تم استرجاعها.',
  sessionTitle: 'انتهت جلسة تسجيل الدخول',
  sessionDescription: 'سجّل الدخول مرة أخرى لعرض الإشعارات.',
  sessionAction: 'تسجيل الدخول',
  unreadBadgeText: 'جديد',
  actionRequiredBadge: 'مطلوب إجراء: دفع العربون',
  // Event Titles
  approvalTitle: 'وافق المالك على طلب الحجز',
  approvalSuffix: 'أصبح دفع العربون الخطوة التالية لتأكيد الحجز.',
  rejectionTitle: 'لم يوافق المالك على طلب الحجز',
  rejectionSuffix: 'افتح الحجز لمراجعة التفاصيل.',
} as const;

/**
 * Returns canonical title for notification event.
 */
export function getNotificationTitle(eventType: CustomerNotificationEventType): string {
  switch (eventType) {
    case 'BOOKING_APPROVED_PENDING_PAYMENT':
      return CUSTOMER_NOTIFICATIONS_COPY.approvalTitle;
    case 'BOOKING_REJECTED':
      return CUSTOMER_NOTIFICATIONS_COPY.rejectionTitle;
    default:
      return 'تحديث على طلب الحجز';
  }
}

/**
 * Returns truthful copy for notification body.
 * Invariant: NEVER outputs that booking is already confirmed for approval because booking is pending deposit.
 */
export function getNotificationBody(item: Pick<CustomerNotificationItem, 'eventType' | 'propertyTitle'>): string {
  if (item.eventType === 'BOOKING_APPROVED_PENDING_PAYMENT') {
    if (item.propertyTitle && item.propertyTitle.trim().length > 0) {
      return `${item.propertyTitle.trim()} · ${CUSTOMER_NOTIFICATIONS_COPY.approvalSuffix}`;
    }
    return CUSTOMER_NOTIFICATIONS_COPY.approvalSuffix;
  }

  if (item.eventType === 'BOOKING_REJECTED') {
    if (item.propertyTitle && item.propertyTitle.trim().length > 0) {
      return `${item.propertyTitle.trim()} · ${CUSTOMER_NOTIFICATIONS_COPY.rejectionSuffix}`;
    }
    return CUSTOMER_NOTIFICATIONS_COPY.rejectionSuffix;
  }

  return '';
}

/**
 * Formats unread count badge:
 * - count === null or count <= 0: null (hidden)
 * - count > 9: '9+'
 * - otherwise: string count
 */
export function formatUnreadCountBadge(count: number | null): string | null {
  if (count === null || count <= 0) return null;
  if (count > 9) return '9+';
  return String(count);
}

/**
 * Formats notification creation timestamp in Arabic.
 * Does NOT use date grouping like "اليوم" or "أمس" in V1.
 */
export function formatNotificationTime(isoString: string): string {
  try {
    const date = new Date(isoString);
    if (Number.isNaN(date.getTime())) return '';
    return new Intl.DateTimeFormat('ar-EG', {
      day: 'numeric',
      month: 'short',
      year: 'numeric',
      hour: 'numeric',
      minute: 'numeric',
      hour12: true,
    }).format(date);
  } catch {
    return '';
  }
}

/**
 * Resolves list state after loading items: LOADED if length > 0, else EMPTY.
 */
export function notificationListStateAfterLoad(items: CustomerNotificationItem[]): 'LOADED' | 'EMPTY' {
  return items.length > 0 ? 'LOADED' : 'EMPTY';
}

/**
 * Merges paginated notification results with existing items, de-duplicating by notificationId.
 */
export function mergeNotificationPages(
  existing: CustomerNotificationItem[],
  incoming: CustomerNotificationItem[],
): CustomerNotificationItem[] {
  const existingMap = new Map<string, CustomerNotificationItem>();
  for (const item of existing) {
    existingMap.set(item.notificationId, item);
  }
  for (const item of incoming) {
    existingMap.set(item.notificationId, item);
  }
  // Newest first based on ISO createdAt timestamp
  return Array.from(existingMap.values()).sort(
    (a, b) => new Date(b.createdAt).getTime() - new Date(a.createdAt).getTime(),
  );
}

/**
 * Optimistically marks a notification as read locally.
 */
export function markNotificationReadLocally(
  items: CustomerNotificationItem[],
  notificationId: string,
): CustomerNotificationItem[] {
  return items.map((item) =>
    item.notificationId === notificationId ? { ...item, isRead: true } : item,
  );
}

/**
 * Optimistically decrements local unread count if positive, floored at 0.
 */
export function decrementUnreadCountLocally(current: number | null): number | null {
  if (current === null) return null;
  return Math.max(0, current - 1);
}

/**
 * Determines whether to keep existing notification items on refresh failure.
 */
export function shouldKeepNotificationsAfterRefreshFailure(
  items: CustomerNotificationItem[],
  unauthorized: boolean,
): boolean {
  return items.length > 0 && !unauthorized;
}
