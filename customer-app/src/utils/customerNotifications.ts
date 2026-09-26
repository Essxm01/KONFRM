import { getApiUrl } from './api';

export const CUSTOMER_NOTIFICATION_EVENT_TYPES = [
  'BOOKING_APPROVED_PENDING_PAYMENT',
  'BOOKING_REJECTED',
] as const;

export type CustomerNotificationEventType = typeof CUSTOMER_NOTIFICATION_EVENT_TYPES[number];

export interface CustomerNotificationItem {
  notificationId: string;
  eventType: CustomerNotificationEventType;
  bookingId: string;
  propertyTitle: string | null;
  createdAt: string;
  isRead: boolean;
  actionRequired: boolean;
}

export interface CustomerNotificationsPage {
  items: CustomerNotificationItem[];
  nextCursor: string | null;
}

export type CustomerNotificationLoadState =
  | 'INITIAL_LOADING'
  | 'LOADED'
  | 'EMPTY'
  | 'REFRESHING'
  | 'STALE_ERROR'
  | 'ERROR'
  | 'SESSION_EXPIRED';

export type CustomerFetch = (input: RequestInfo | URL, init?: RequestInit) => Promise<Response>;
export type GetUrlFn = (path: string) => string;

/** Thrown when access token is missing, expired, or invalid (HTTP 401/403). */
export class CustomerNotificationsUnauthorizedError extends Error {
  constructor(message = 'Customer Notifications session expired') {
    super(message);
    this.name = 'CustomerNotificationsUnauthorizedError';
  }
}

function throwIfUnauthorized(status: number): void {
  if (status === 401 || status === 403) {
    throw new CustomerNotificationsUnauthorizedError();
  }
}

const UUID_REGEX = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;

function isIsoDate(value: unknown): value is string {
  return typeof value === 'string' && value.trim().length > 0 && !Number.isNaN(Date.parse(value));
}

export function validateNotificationItem(item: any): CustomerNotificationItem {
  if (!item || typeof item !== 'object') throw new Error('ITEM_NOT_OBJECT');
  if (typeof item.notificationId !== 'string' || !UUID_REGEX.test(item.notificationId)) {
    throw new Error('INVALID_NOTIFICATION_ID');
  }
  if (!CUSTOMER_NOTIFICATION_EVENT_TYPES.includes(item.eventType)) {
    throw new Error('INVALID_EVENT_TYPE');
  }
  if (typeof item.bookingId !== 'string' || !UUID_REGEX.test(item.bookingId)) {
    throw new Error('INVALID_BOOKING_ID');
  }
  if (item.propertyTitle !== null && typeof item.propertyTitle !== 'string') {
    throw new Error('INVALID_PROPERTY_TITLE');
  }
  if (!isIsoDate(item.createdAt)) {
    throw new Error('INVALID_CREATED_AT');
  }
  if (typeof item.isRead !== 'boolean') {
    throw new Error('INVALID_IS_READ');
  }
  if (typeof item.actionRequired !== 'boolean') {
    throw new Error('INVALID_ACTION_REQUIRED');
  }

  return {
    notificationId: item.notificationId,
    eventType: item.eventType,
    bookingId: item.bookingId,
    propertyTitle: typeof item.propertyTitle === 'string' ? item.propertyTitle.trim() : null,
    createdAt: item.createdAt,
    isRead: item.isRead,
    actionRequired: item.actionRequired,
  };
}

export async function fetchCustomerNotifications(
  token: string,
  options: { limit?: number; cursor?: string | null } = {},
  fetchFn: CustomerFetch = fetch,
  getUrl: GetUrlFn = getApiUrl,
): Promise<CustomerNotificationsPage> {
  if (!token) throw new CustomerNotificationsUnauthorizedError('CUSTOMER_TOKEN_REQUIRED');

  const params = new URLSearchParams();
  if (options.limit !== undefined && options.limit > 0) {
    params.set('limit', String(options.limit));
  }
  if (options.cursor) {
    params.set('cursor', options.cursor);
  }

  const queryStr = params.toString();
  const endpoint = `/customer/notifications${queryStr ? `?${queryStr}` : ''}`;

  let res: Response;
  try {
    res = await fetchFn(getUrl(endpoint), {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    });
  } catch (err: any) {
    throw new Error(`FETCH_CUSTOMER_NOTIFICATIONS_NETWORK_ERROR: ${err?.message || String(err)}`);
  }

  throwIfUnauthorized(res.status);

  if (!res.ok) {
    throw new Error(`FETCH_CUSTOMER_NOTIFICATIONS_FAILED: HTTP ${res.status}`);
  }

  const json = await res.json().catch(() => null);
  if (!json || !json.success || !json.data || !Array.isArray(json.data.items)) {
    throw new Error('FETCH_CUSTOMER_NOTIFICATIONS_MALFORMED');
  }

  const nextCursor = typeof json.data.nextCursor === 'string' ? json.data.nextCursor : null;

  try {
    const items = json.data.items.map(validateNotificationItem);
    return { items, nextCursor };
  } catch (err: any) {
    throw new Error(`FETCH_CUSTOMER_NOTIFICATIONS_VALIDATION_ERROR: ${err?.message || String(err)}`);
  }
}

export async function fetchCustomerUnreadNotificationCount(
  token: string,
  fetchFn: CustomerFetch = fetch,
  getUrl: GetUrlFn = getApiUrl,
): Promise<number> {
  if (!token) throw new CustomerNotificationsUnauthorizedError('CUSTOMER_TOKEN_REQUIRED');

  let res: Response;
  try {
    res = await fetchFn(getUrl('/customer/notifications/unread-count'), {
      headers: {
        Authorization: `Bearer ${token}`,
      },
    });
  } catch (err: any) {
    throw new Error(`FETCH_UNREAD_COUNT_NETWORK_ERROR: ${err?.message || String(err)}`);
  }

  throwIfUnauthorized(res.status);

  if (!res.ok) {
    throw new Error(`FETCH_UNREAD_COUNT_FAILED: HTTP ${res.status}`);
  }

  const json = await res.json().catch(() => null);
  if (!json || !json.success || !json.data || typeof json.data.unreadCount !== 'number' || json.data.unreadCount < 0) {
    throw new Error('FETCH_UNREAD_COUNT_MALFORMED');
  }

  return Math.floor(json.data.unreadCount);
}

export async function markCustomerNotificationRead(
  token: string,
  notificationId: string,
  fetchFn: CustomerFetch = fetch,
  getUrl: GetUrlFn = getApiUrl,
): Promise<{ notificationId: string; isRead: boolean }> {
  if (!token) throw new CustomerNotificationsUnauthorizedError('CUSTOMER_TOKEN_REQUIRED');
  if (!notificationId || !UUID_REGEX.test(notificationId)) {
    throw new Error('INVALID_NOTIFICATION_ID');
  }

  let res: Response;
  try {
    res = await fetchFn(getUrl(`/customer/notifications/${encodeURIComponent(notificationId)}/read`), {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${token}`,
        'Content-Type': 'application/json',
      },
    });
  } catch (err: any) {
    throw new Error(`MARK_NOTIFICATION_READ_NETWORK_ERROR: ${err?.message || String(err)}`);
  }

  throwIfUnauthorized(res.status);

  if (!res.ok) {
    throw new Error(`MARK_NOTIFICATION_READ_FAILED: HTTP ${res.status}`);
  }

  const json = await res.json().catch(() => null);
  if (!json || !json.success || !json.data || json.data.notificationId !== notificationId || json.data.isRead !== true) {
    throw new Error('MARK_NOTIFICATION_READ_MALFORMED');
  }

  return { notificationId: json.data.notificationId, isRead: json.data.isRead };
}
