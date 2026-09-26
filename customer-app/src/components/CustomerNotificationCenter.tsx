import React, { useEffect, useRef } from 'react';
import {
  ChevronRight,
  ChevronLeft,
  BellOff,
  AlertCircle,
  RefreshCw,
  LogIn,
  Clock,
  CheckCircle2,
  XCircle,
} from 'lucide-react';
import type {
  CustomerNotificationItem,
  CustomerNotificationLoadState,
} from '../utils/customerNotifications';
import {
  CUSTOMER_NOTIFICATIONS_COPY,
  getNotificationTitle,
  getNotificationBody,
  formatNotificationTime,
  shouldRenderNotificationFeed,
} from '../utils/customerScreen16Notifications';

export interface CustomerNotificationCenterProps {
  loadState: CustomerNotificationLoadState;
  notifications: CustomerNotificationItem[];
  hasMore: boolean;
  isLoadingMore: boolean;
  error?: string | null;
  onBack: () => void;
  onSelectNotification: (item: CustomerNotificationItem) => void;
  onLoadMore: () => void;
  onRetry: () => void;
  onReauthenticate: () => void;
}

function NotificationCardSkeleton() {
  return (
    <div
      className="bg-white rounded-2xl border border-slate-200/80 p-4 shadow-xs animate-pulse space-y-3"
      aria-hidden="true"
    >
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-2.5">
          <div className="w-8 h-8 rounded-xl bg-slate-200" />
          <div className="h-4 rounded bg-slate-200 w-32" />
        </div>
        <div className="h-3 rounded bg-slate-200 w-16" />
      </div>
      <div className="h-3.5 rounded bg-slate-200 w-4/5" />
      <div className="h-3 rounded bg-slate-200 w-2/5" />
    </div>
  );
}

export const CustomerNotificationCenter: React.FC<CustomerNotificationCenterProps> = ({
  loadState,
  notifications,
  hasMore,
  isLoadingMore,
  onBack,
  onSelectNotification,
  onLoadMore,
  onRetry,
  onReauthenticate,
}) => {
  const headingRef = useRef<HTMLHeadingElement | null>(null);

  // Focus heading on mount for screen-reader and keyboard accessibility
  useEffect(() => {
    headingRef.current?.focus();
  }, []);

  const isInitialLoading = loadState === 'INITIAL_LOADING';
  const isStaleError = loadState === 'STALE_ERROR';
  const isEmpty = loadState === 'EMPTY';
  const isError = loadState === 'ERROR';
  const isSessionExpired = loadState === 'SESSION_EXPIRED';
  const hasNotifications = shouldRenderNotificationFeed(loadState, notifications.length);

  return (
    <section
      dir="rtl"
      aria-labelledby="customer-notifications-heading"
      className="w-full max-w-[430px] mx-auto px-4 pt-3 pb-28 text-slate-900"
    >
      {/* Header */}
      <header className="mb-4">
        <div className="flex items-center gap-2 mb-2">
          <button
            type="button"
            onClick={onBack}
            aria-label={CUSTOMER_NOTIFICATIONS_COPY.backToAccount}
            className="min-h-[44px] min-w-[44px] -mr-2 p-2.5 rounded-xl text-slate-600 hover:text-slate-900 hover:bg-slate-100 transition-colors flex items-center justify-center focus:outline-none focus-visible:ring-2 focus-visible:ring-[#0059FF]/40"
          >
            <ChevronRight className="w-5 h-5 text-slate-700" />
          </button>
          <h1
            id="customer-notifications-heading"
            ref={headingRef}
            tabIndex={-1}
            className="text-[20px] font-black text-slate-950 tracking-tight leading-tight focus:outline-none"
          >
            {CUSTOMER_NOTIFICATIONS_COPY.title}
          </h1>
        </div>
        <p className="text-xs font-semibold text-slate-500 mr-1">
          {CUSTOMER_NOTIFICATIONS_COPY.subtitle}
        </p>
      </header>

      {/* Stale Error Notice (Preserves loaded list) */}
      {isStaleError && (
        <div
          role="status"
          className="mb-3 p-3 bg-amber-50 border border-amber-200 text-amber-900 rounded-2xl text-xs font-bold flex items-center justify-between shadow-xs"
        >
          <div className="flex items-center gap-2">
            <AlertCircle className="w-4 h-4 text-amber-600 shrink-0" />
            <span>{CUSTOMER_NOTIFICATIONS_COPY.stale}</span>
          </div>
          <button
            type="button"
            onClick={onRetry}
            className="px-2.5 py-1 bg-amber-600 hover:bg-amber-700 text-white font-black text-[11px] rounded-lg shrink-0 transition-colors"
          >
            {CUSTOMER_NOTIFICATIONS_COPY.errorAction}
          </button>
        </div>
      )}

      {/* State: INITIAL_LOADING */}
      {isInitialLoading && (
        <div className="space-y-3" aria-label={CUSTOMER_NOTIFICATIONS_COPY.loading}>
          <NotificationCardSkeleton />
          <NotificationCardSkeleton />
          <NotificationCardSkeleton />
        </div>
      )}

      {/* State: SESSION_EXPIRED */}
      {isSessionExpired && (
        <div className="bg-white rounded-3xl border border-slate-200 p-6 text-center space-y-4 shadow-xs">
          <div className="w-14 h-14 bg-amber-50 rounded-2xl flex items-center justify-center mx-auto text-amber-600 border border-amber-100">
            <AlertCircle className="w-7 h-7" aria-hidden="true" />
          </div>
          <div>
            <h2 className="text-base font-black text-slate-900 mb-1">
              {CUSTOMER_NOTIFICATIONS_COPY.sessionTitle}
            </h2>
            <p className="text-xs text-slate-500 font-bold max-w-xs mx-auto leading-relaxed">
              {CUSTOMER_NOTIFICATIONS_COPY.sessionDescription}
            </p>
          </div>
          <button
            type="button"
            onClick={onReauthenticate}
            className="w-full min-h-[52px] py-3.5 bg-[#0059FF] hover:bg-blue-600 text-white font-black text-xs rounded-xl shadow-lg shadow-blue-500/25 transition-all flex items-center justify-center gap-2"
          >
            <LogIn className="w-4 h-4" />
            <span>{CUSTOMER_NOTIFICATIONS_COPY.sessionAction}</span>
          </button>
        </div>
      )}

      {/* State: ERROR (hard error with zero data) */}
      {isError && (
        <div className="bg-white rounded-3xl border border-rose-200 bg-rose-50/40 p-6 text-center space-y-4 shadow-xs">
          <div className="w-14 h-14 bg-rose-100 rounded-2xl flex items-center justify-center mx-auto text-rose-600">
            <AlertCircle className="w-7 h-7" aria-hidden="true" />
          </div>
          <div>
            <h2 className="text-base font-black text-slate-900 mb-1">
              {CUSTOMER_NOTIFICATIONS_COPY.errorTitle}
            </h2>
            <p className="text-xs text-slate-500 font-bold max-w-xs mx-auto leading-relaxed">
              {CUSTOMER_NOTIFICATIONS_COPY.errorDescription}
            </p>
          </div>
          <button
            type="button"
            onClick={onRetry}
            className="w-full min-h-[52px] py-3.5 bg-[#0059FF] hover:bg-blue-600 text-white font-black text-xs rounded-xl shadow-lg shadow-blue-500/25 transition-all flex items-center justify-center gap-2"
          >
            <RefreshCw className="w-4 h-4" />
            <span>{CUSTOMER_NOTIFICATIONS_COPY.errorAction}</span>
          </button>
        </div>
      )}

      {/* State: EMPTY */}
      {isEmpty && (
        <div className="py-14 sm:py-20 text-center space-y-4">
          <div className="w-16 h-16 bg-blue-50 rounded-3xl flex items-center justify-center mx-auto text-[#0059FF] border border-blue-100 shadow-xs">
            <BellOff className="w-8 h-8" aria-hidden="true" />
          </div>
          <div>
            <h2 className="text-base font-black text-slate-900 mb-1">
              {CUSTOMER_NOTIFICATIONS_COPY.emptyTitle}
            </h2>
            <p className="text-xs text-slate-500 font-bold max-w-xs mx-auto leading-relaxed">
              {CUSTOMER_NOTIFICATIONS_COPY.emptyDescription}
            </p>
          </div>
        </div>
      )}

      {/* State: LOADED / REFRESHING / STALE (with items) */}
      {hasNotifications && (
        <div className="space-y-3" role="feed" aria-label="قائمة الإشعارات">
          {notifications.map((item) => {
            const isUnread = !item.isRead;
            const isApproval = item.eventType === 'BOOKING_APPROVED_PENDING_PAYMENT';
            const isActionRequired = isApproval && item.actionRequired;
            const title = getNotificationTitle(item.eventType);
            const body = getNotificationBody(item);
            const formattedTime = formatNotificationTime(item.createdAt);

            return (
              <button
                key={item.notificationId}
                type="button"
                onClick={() => onSelectNotification(item)}
                aria-label={`${isUnread ? 'إشعار غير مقروء: ' : 'إشعار: '}${title} - ${body}${isActionRequired ? ' - مطلوب إجراء دفع العربون' : ''}`}
                className={`w-full text-right p-4 rounded-2xl border transition-all text-slate-900 min-h-[48px] flex flex-col gap-2.5 focus:outline-none focus-visible:ring-2 focus-visible:ring-[#0059FF]/50 relative ${
                  isUnread
                    ? 'bg-blue-50/40 border-blue-200/90 shadow-xs'
                    : 'bg-white border-slate-200/90 hover:bg-slate-50/80 shadow-xs'
                }`}
              >
                {/* Top Row: Event Icon + Title + Action Badges + Chevron */}
                <div className="flex items-start justify-between gap-3 w-full">
                  <div className="flex items-start gap-2.5 min-w-0">
                    {/* Event Icon */}
                    <div
                      className={`w-8 h-8 rounded-xl flex items-center justify-center shrink-0 mt-0.5 ${
                        isApproval
                          ? 'bg-blue-100/70 text-[#0059FF]'
                          : 'bg-slate-100 text-slate-600'
                      }`}
                    >
                      {isApproval ? (
                        <CheckCircle2 className="w-4 h-4" />
                      ) : (
                        <XCircle className="w-4 h-4" />
                      )}
                    </div>

                    {/* Title & Badges */}
                    <div className="min-w-0">
                      <div className="flex items-center gap-2 flex-wrap">
                        <h2 className="text-xs font-black text-slate-900 leading-snug">
                          {title}
                        </h2>
                        {isUnread && (
                          <span className="inline-flex items-center px-1.5 py-0.5 rounded-full text-[10px] font-black bg-[#0059FF]/10 text-[#0059FF] border border-[#0059FF]/20">
                            {CUSTOMER_NOTIFICATIONS_COPY.unreadBadgeText}
                          </span>
                        )}
                        {isActionRequired && (
                          <span className="inline-flex items-center px-2 py-0.5 rounded-full text-[10px] font-black bg-amber-50 text-amber-800 border border-amber-200">
                            {CUSTOMER_NOTIFICATIONS_COPY.actionRequiredBadge}
                          </span>
                        )}
                      </div>
                    </div>
                  </div>

                  <ChevronLeft className="w-4 h-4 text-slate-400 shrink-0 mt-1" />
                </div>

                {/* Notification Body Copy */}
                {body && (
                  <p className="text-xs font-semibold text-slate-600 leading-relaxed pr-10.5">
                    {body}
                  </p>
                )}

                {/* Footer: Timestamp */}
                {formattedTime && (
                  <div className="flex items-center gap-1.5 text-[11px] font-bold text-slate-400 pr-10.5 pt-0.5">
                    <Clock className="w-3 h-3" />
                    <span>{formattedTime}</span>
                  </div>
                )}
              </button>
            );
          })}

          {/* Keyset Pagination — Load More Button */}
          {hasMore && (
            <div className="pt-2 pb-1">
              <button
                type="button"
                onClick={onLoadMore}
                disabled={isLoadingMore}
                className="w-full min-h-[48px] py-3 bg-white hover:bg-slate-50 text-slate-700 font-black text-xs rounded-xl border border-slate-200 shadow-xs transition-colors flex items-center justify-center gap-2 disabled:opacity-60 disabled:cursor-not-allowed"
              >
                {isLoadingMore ? (
                  <>
                    <RefreshCw className="w-4 h-4 animate-spin text-[#0059FF]" />
                    <span>{CUSTOMER_NOTIFICATIONS_COPY.loadingMore}</span>
                  </>
                ) : (
                  <span>{CUSTOMER_NOTIFICATIONS_COPY.loadMore}</span>
                )}
              </button>
            </div>
          )}
        </div>
      )}
    </section>
  );
};
