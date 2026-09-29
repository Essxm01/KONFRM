import React, { useState } from 'react';
import {
  CalendarCheck,
  Heart,
  Bell,
  CreditCard,
  User,
  HelpCircle,
  LogOut,
  ChevronLeft,
  AlertCircle,
  Edit3,
} from 'lucide-react';
import type { CustomerUserProfile } from './CustomerAuthModal';

export interface CustomerAccountHomeScreenProps {
  isAuthenticated: boolean;
  userProfile: CustomerUserProfile | null;
  unreadNotificationCount?: number | null;
  onEditProfile: () => void;
  onOpenBookings: () => void;
  onOpenFavorites: () => void;
  onOpenNotifications: () => void;
  onOpenPayments: () => void;
  onOpenSupport: () => void;
  onLogout: () => void;
  onLogin: () => void;
  isSessionExpired?: boolean;
  identityIntegrityFailed?: boolean;
  accountError?: string | null;
  onRetryAccount?: () => void;
}

export function deriveUserInitials(name?: string | null): string {
  if (!name || name.trim().length === 0) return 'م';
  const parts = name.trim().split(/\s+/).filter(Boolean);
  if (parts.length === 1) return parts[0].slice(0, 2);
  return `${parts[0][0]}.${parts[1][0]}`;
}

/**
 * Deterministic safe phone masking helper for Account Home.
 * Normalized Egyptian numbers (+201012341234) -> +20 10••••1234.
 * Fails safely to a generic masked representation rather than exposing full value.
 */
export function maskDisplayPhone(phone: string): string {
  if (!phone || typeof phone !== 'string') return '+•• •••• ••••';
  const clean = phone.trim().replace(/\s+/g, '');

  // Egyptian standard: +20 followed by 10/11/12/15 and 8 digits
  const egMatch = clean.match(/^\+20(1[0125])(\d{4})(\d{4})$/);
  if (egMatch) {
    const [, operator, , last4] = egMatch;
    return `+20 ${operator}••••${last4}`;
  }

  // Egyptian with leading 0 (010..., 011...)
  const egLocalMatch = clean.match(/^0(1[0125])(\d{4})(\d{4})$/);
  if (egLocalMatch) {
    const [, operator, , last4] = egLocalMatch;
    return `+20 ${operator}••••${last4}`;
  }

  // General international with area/operator recognition
  const intlMatch = clean.match(/^(\+\d{1,3})(\d{2,3})\d{3,}(\d{4})$/);
  if (intlMatch) {
    const [, countryCode, opCode, last4] = intlMatch;
    return `${countryCode} ${opCode}••••${last4}`;
  }

  // Generic fallback if ends with 4 digits
  const genericMatch = clean.match(/^\+?(\d{1,3})?\d{2,}(\d{4})$/);
  if (genericMatch && genericMatch[2]) {
    const country = genericMatch[1] ? `+${genericMatch[1]} ` : '+';
    return `${country}••••••••${genericMatch[2]}`;
  }

  return '+•• •••• ••••';
}

/**
 * The displayed login identity derives ONLY from canonical verified
 * identifiers (public.user_identifiers). Legacy users.email, the cached
 * phone display key, and fabricated placeholders are never presented as
 * verified identity.
 *
 * When masked is true (default for Account Home), phone is masked.
 * Screen 18 requests masked: false to show full canonical verified phone.
 */
export function resolveDisplayIdentifier(
  userProfile: CustomerUserProfile | null,
  options?: { masked?: boolean }
): string | null {
  const verifiedPhone = userProfile?.verifiedIdentifiers?.phone?.value;
  const verifiedEmail = userProfile?.verifiedIdentifiers?.email?.value;

  // Dual verified: prioritize phone for primary account home identity
  if (verifiedPhone) {
    return options?.masked ? maskDisplayPhone(verifiedPhone) : verifiedPhone;
  }
  if (verifiedEmail) return verifiedEmail;
  return null;
}

export function formatNotificationBadge(count?: number | null): string | null {
  if (!count || count <= 0) return null;
  if (count > 9) return '9+';
  return String(count);
}

export function isCustomerProfileIncomplete(fullName?: string | null): boolean {
  return !fullName || fullName.trim().length === 0;
}

interface AccountNavigationRowProps {
  icon: React.ReactNode;
  title: string;
  subtitle: string;
  onClick: () => void;
  badge?: React.ReactNode;
  iconBgColor?: string;
  iconColor?: string;
}

export const AccountNavigationRow: React.FC<AccountNavigationRowProps> = ({
  icon,
  title,
  subtitle,
  onClick,
  badge,
  iconBgColor = 'bg-blue-50',
  iconColor = 'text-[#0059FF]',
}) => (
  <button
    type="button"
    onClick={onClick}
    className="w-full min-h-[64px] px-4 py-3.5 flex items-center justify-between hover:bg-slate-50 active:bg-slate-100 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-inset focus-visible:ring-[#0059FF]/40 transition-colors text-right cursor-pointer"
  >
    <div className="flex items-center gap-3.5 min-w-0">
      <div
        className={`w-10 h-10 ${iconBgColor} ${iconColor} rounded-xl flex items-center justify-center shrink-0 shadow-2xs`}
      >
        {icon}
      </div>
      <div className="min-w-0">
        <h5 className="font-bold text-slate-900 text-sm truncate leading-snug">{title}</h5>
        <p className="text-xs text-slate-500 font-normal truncate mt-0.5">{subtitle}</p>
      </div>
    </div>
    <div className="flex items-center gap-2 shrink-0">
      {badge}
      <ChevronLeft className="w-4 h-4 text-slate-400" />
    </div>
  </button>
);

export const CustomerAccountHomeScreen: React.FC<CustomerAccountHomeScreenProps> = ({
  isAuthenticated,
  userProfile,
  unreadNotificationCount,
  onEditProfile,
  onOpenBookings,
  onOpenFavorites,
  onOpenNotifications,
  onOpenPayments,
  onOpenSupport,
  onLogout,
  onLogin,
  isSessionExpired,
  identityIntegrityFailed,
  accountError,
  onRetryAccount,
}) => {
  const [imgError, setImgError] = useState<boolean>(false);

  // Fail-closed identity integrity: an authenticated Customer whose canonical
  // profile carries zero verified PHONE/EMAIL identifiers is an integrity
  // failure — never a normal Account state and never shown fabricated identity.
  const hasVerifiedIdentifier =
    Boolean(userProfile?.verifiedIdentifiers?.phone?.value) ||
    Boolean(userProfile?.verifiedIdentifiers?.email?.value);
  const identityIntegrity =
    identityIntegrityFailed ||
    (isAuthenticated && Boolean(userProfile) && !hasVerifiedIdentifier);

  // 1. Session Expired Recovery State
  if (isSessionExpired) {
    return (
      <div className="max-w-[430px] mx-auto px-4 py-8 text-right space-y-4 animate-fade-in">
        <div className="bg-white p-6 rounded-3xl border border-slate-200 text-center space-y-4 shadow-xs">
          <div className="w-14 h-14 bg-blue-50 text-[#0059FF] rounded-2xl flex items-center justify-center mx-auto mb-2">
            <AlertCircle className="w-7 h-7" />
          </div>
          <div>
            <h3 className="font-bold text-slate-900 text-base mb-1">
              انتهت جلسة تسجيل الدخول
            </h3>
            <p className="text-xs text-slate-500 font-medium max-w-xs mx-auto leading-relaxed">
              سجّل الدخول مرة أخرى للوصول إلى حسابك.
            </p>
          </div>
          <button
            type="button"
            onClick={onLogin}
            className="w-full min-h-[44px] py-3 bg-[#0059FF] hover:bg-blue-600 text-white font-bold text-xs rounded-xl shadow-md focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-[#0059FF]/40 focus-visible:ring-offset-2 transition-all cursor-pointer"
          >
            تسجيل الدخول مجددًا
          </button>
        </div>
      </div>
    );
  }

  // 2. Identity Integrity Fail-Closed State
  if (identityIntegrity) {
    return (
      <div className="max-w-[430px] mx-auto px-4 py-8 text-right space-y-4 animate-fade-in">
        <div className="bg-white p-6 rounded-3xl border border-slate-200 text-center space-y-4 shadow-xs">
          <div className="w-14 h-14 bg-blue-50 text-[#0059FF] rounded-2xl flex items-center justify-center mx-auto mb-2">
            <AlertCircle className="w-7 h-7" />
          </div>
          <div>
            <h3 className="font-bold text-slate-900 text-base mb-1">
              لا يمكن التحقق من هوية الحساب
            </h3>
            <p className="text-xs text-slate-500 font-medium max-w-xs mx-auto leading-relaxed">
              لم نتمكن من التحقق من معرفات تسجيل الدخول الموثقة لهذا الحساب. سجّل الدخول مرة أخرى لإعادة التحقق.
            </p>
          </div>
          <button
            type="button"
            onClick={onLogin}
            className="w-full min-h-[44px] py-3 bg-[#0059FF] hover:bg-blue-600 text-white font-bold text-xs rounded-xl shadow-md focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-[#0059FF]/40 focus-visible:ring-offset-2 transition-all cursor-pointer"
          >
            تسجيل الدخول مجددًا
          </button>
        </div>
      </div>
    );
  }

  // 3. Hard Account Error State
  if (accountError) {
    return (
      <div className="max-w-[430px] mx-auto px-4 py-8 text-right space-y-4 animate-fade-in">
        <div className="bg-white p-6 rounded-3xl border border-slate-200 text-center space-y-4 shadow-xs">
          <div className="w-14 h-14 bg-rose-50 text-rose-600 rounded-2xl flex items-center justify-center mx-auto mb-2">
            <AlertCircle className="w-7 h-7" />
          </div>
          <div>
            <h3 className="font-bold text-slate-900 text-base mb-1">
              تعذر تحميل الحساب
            </h3>
            <p className="text-xs text-slate-500 font-medium max-w-xs mx-auto leading-relaxed">
              تحقق من الاتصال وحاول مرة أخرى.
            </p>
          </div>
          {onRetryAccount && (
            <button
              type="button"
              onClick={onRetryAccount}
              className="w-full min-h-[44px] py-3 bg-[#0059FF] hover:bg-blue-600 text-white font-bold text-xs rounded-xl shadow-md focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-[#0059FF]/40 focus-visible:ring-offset-2 transition-all cursor-pointer"
            >
              إعادة المحاولة
            </button>
          )}
        </div>
      </div>
    );
  }

  // 4. Guest / Unauthenticated State
  if (!isAuthenticated) {
    return (
      <div className="max-w-[430px] mx-auto px-4 py-5 text-right space-y-6 animate-fade-in pb-20">
        <h1 className="text-xl font-bold text-slate-900">حسابي</h1>
        <div className="bg-white p-6 rounded-3xl border border-slate-200 text-center space-y-4 shadow-xs">
          <div className="w-16 h-16 bg-blue-50 text-[#0059FF] rounded-3xl flex items-center justify-center mx-auto mb-2 shadow-xs">
            <User className="w-8 h-8" />
          </div>
          <div>
            <h3 className="font-bold text-slate-900 text-base mb-1">
              تسجيل الدخول أو إنشاء حساب
            </h3>
            <p className="text-xs text-slate-500 font-medium max-w-xs mx-auto leading-relaxed">
              ادخل رقم هاتفك لتتمكن من تقديم طلبات الحجز المباشرة وحفظ شاليهاتك المفضلة ومتابعة التأكيدات.
            </p>
          </div>
          <button
            type="button"
            onClick={onLogin}
            className="w-full min-h-[48px] py-3.5 bg-[#0059FF] hover:bg-blue-600 active:scale-[0.99] text-white font-bold text-xs rounded-xl shadow-lg shadow-blue-500/25 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-[#0059FF]/40 focus-visible:ring-offset-2 transition-all cursor-pointer"
          >
            دخول برقم الجوال
          </button>
        </div>
      </div>
    );
  }

  // 5. Authenticated State
  const initials = deriveUserInitials(userProfile?.fullName);
  // Phone is masked on Account Home (+20 10••••1234); email wraps fully without truncation
  const displayIdentifier = resolveDisplayIdentifier(userProfile, { masked: true });
  const isProfileIncomplete = isCustomerProfileIncomplete(userProfile?.fullName);
  const unreadBadgeText = formatNotificationBadge(unreadNotificationCount);
  const displayName = userProfile?.fullName?.trim() || 'مستأجر';
  const hasAvatar = Boolean(userProfile?.avatarUrl && !imgError);

  return (
    <div className="max-w-[430px] mx-auto px-4 py-5 text-right space-y-6 animate-fade-in pb-20">
      {/* Page Title */}
      <h1 className="text-xl font-bold text-slate-900">حسابي</h1>

      {/* 1. Identity Block */}
      <div className="bg-white p-4 rounded-3xl border border-slate-200/90 shadow-none space-y-4">
        <div className="flex items-center justify-between gap-3">
          <div className="flex items-center gap-3.5 min-w-0 flex-1">
            {/* 56x56 Circular Avatar / Initials / Fallback (Display only — no upload/edit affordance) */}
            {hasAvatar ? (
              <img
                src={userProfile?.avatarUrl || ''}
                alt={displayName}
                onError={() => setImgError(true)}
                className="w-14 h-14 rounded-full object-cover shrink-0 select-none shadow-xs border border-slate-100"
              />
            ) : initials ? (
              <div
                className="w-14 h-14 rounded-full bg-slate-900 text-white font-bold text-xl flex items-center justify-center shrink-0 select-none shadow-xs"
                aria-hidden="true"
              >
                {initials}
              </div>
            ) : (
              <div
                className="w-14 h-14 rounded-full bg-slate-100 text-slate-600 flex items-center justify-center shrink-0 select-none shadow-xs"
                aria-hidden="true"
              >
                <User className="w-6 h-6" />
              </div>
            )}

            <div className="min-w-0 flex-1">
              <h2 className="text-lg font-bold text-slate-900 leading-snug break-words">
                {displayName}
              </h2>
            </div>
          </div>

          {/* CTA: تعديل (Visible label exactly 'تعديل', accessible name 'تعديل البيانات الشخصية') */}
          <button
            type="button"
            onClick={onEditProfile}
            aria-label="تعديل البيانات الشخصية"
            className="min-h-[44px] min-w-[44px] px-3.5 py-2.5 bg-slate-50 hover:bg-slate-100 text-slate-700 font-bold text-xs rounded-xl border border-slate-200 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-[#0059FF]/40 transition-colors flex items-center gap-1.5 shrink-0 cursor-pointer"
          >
            <Edit3 className="w-3.5 h-3.5" />
            <span>تعديل</span>
          </button>
        </div>

        {/* Verified login identity — full-width line so normal emails stay on one line */}
        {displayIdentifier && (
          <bdi
            dir="ltr"
            style={{ direction: 'ltr', unicodeBidi: 'isolate' }}
            className="block text-xs text-slate-500 font-medium tracking-normal [word-break:normal] [overflow-wrap:anywhere]"
          >
            {displayIdentifier}
          </bdi>
        )}

        {/* 2. Incomplete Profile Prompt (Shown ONLY when fullName is genuinely empty, soft blue notice) */}
        {isProfileIncomplete && (
          <div className="p-3.5 bg-blue-50/70 border border-blue-200/80 rounded-2xl flex items-center justify-between gap-3 text-xs font-medium text-slate-800">
            <div className="flex items-center gap-2 min-w-0">
              <AlertCircle className="w-4 h-4 text-[#0059FF] shrink-0" />
              <div className="min-w-0">
                <p className="font-bold text-slate-900 text-xs">أكمل بيانات حسابك</p>
                <p className="text-[11px] text-slate-600">
                  أضف اسمك الكامل ليظهر حسابك بشكل صحيح.
                </p>
              </div>
            </div>
            <button
              type="button"
              onClick={onEditProfile}
              className="min-h-[44px] px-3.5 py-2 bg-[#0059FF] hover:bg-blue-600 text-white font-bold text-xs rounded-xl shrink-0 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-[#0059FF]/40 transition-colors cursor-pointer"
            >
              إكمال البيانات
            </button>
          </div>
        )}
      </div>

      {/* NOTE: 3-stat KPI summary is 100% REMOVED per Founder Decision 1 */}

      {/* Grouped Navigation Sections */}
      <div className="space-y-6">
        {/* Section: رحلاتك */}
        <div className="space-y-2">
          <h4 className="text-[13px] font-bold text-slate-500 px-1">رحلاتك</h4>
          <div className="bg-white rounded-2xl border border-slate-200/80 shadow-none divide-y divide-slate-100 overflow-hidden">
            <AccountNavigationRow
              icon={<CalendarCheck className="w-4 h-4" />}
              title="حجوزاتي"
              subtitle="تابع حجوزاتك الحالية والسابقة"
              onClick={onOpenBookings}
              iconBgColor="bg-blue-50"
              iconColor="text-[#0059FF]"
            />
            {/* Favorites: Soft blue/neutral treatment, NO decorative rose well */}
            <AccountNavigationRow
              icon={<Heart className="w-4 h-4" />}
              title="المفضلة"
              subtitle="الوحدات التي حفظتها للرجوع إليها"
              onClick={onOpenFavorites}
              iconBgColor="bg-blue-50"
              iconColor="text-[#0059FF]"
            />
          </div>
        </div>

        {/* Section: النشاط */}
        <div className="space-y-2">
          <h4 className="text-[13px] font-bold text-slate-500 px-1">النشاط</h4>
          <div className="bg-white rounded-2xl border border-slate-200/80 shadow-none overflow-hidden">
            <AccountNavigationRow
              icon={<Bell className="w-4 h-4" />}
              title="الإشعارات"
              subtitle="تحديثات مهمة على طلباتك وحجوزاتك"
              onClick={onOpenNotifications}
              iconBgColor="bg-blue-50"
              iconColor="text-[#0059FF]"
              badge={
                unreadBadgeText ? (
                  <span className="min-w-[20px] h-5 px-1.5 bg-[#0059FF] text-white text-[10px] font-bold rounded-full flex items-center justify-center shadow-xs">
                    {unreadBadgeText}
                  </span>
                ) : null
              }
            />
          </div>
        </div>

        {/* Section: المدفوعات (Strictly المدفوعات - NO wallet internals, NO decorative emerald well) */}
        <div className="space-y-2">
          <h4 className="text-[13px] font-bold text-slate-500 px-1">المدفوعات</h4>
          <div className="bg-white rounded-2xl border border-slate-200/80 shadow-none overflow-hidden">
            <AccountNavigationRow
              icon={<CreditCard className="w-4 h-4" />}
              title="المدفوعات"
              subtitle="العربون والمدفوعات والمبالغ المتعلقة بحجوزاتك"
              onClick={onOpenPayments}
              iconBgColor="bg-blue-50"
              iconColor="text-[#0059FF]"
            />
          </div>
        </div>

        {/* Section: الحساب */}
        <div className="space-y-2">
          <h4 className="text-[13px] font-bold text-slate-500 px-1">الحساب</h4>
          <div className="bg-white rounded-2xl border border-slate-200/80 shadow-none overflow-hidden">
            <AccountNavigationRow
              icon={<User className="w-4 h-4" />}
              title="البيانات الشخصية"
              subtitle="تعديل الاسم وتحديث بيانات الحساب"
              onClick={onEditProfile}
              iconBgColor="bg-slate-100"
              iconColor="text-slate-700"
            />
          </div>
        </div>

        {/* Section: المساعدة (Strictly المساعدة - NO legal placeholder routes) */}
        <div className="space-y-2">
          <h4 className="text-[13px] font-bold text-slate-500 px-1">المساعدة</h4>
          <div className="bg-white rounded-2xl border border-slate-200/80 shadow-none overflow-hidden">
            <AccountNavigationRow
              icon={<HelpCircle className="w-4 h-4" />}
              title="المساعدة والدعم"
              subtitle="الأسئلة الشائعة وإرشادات الحجز"
              onClick={onOpenSupport}
              iconBgColor="bg-slate-100"
              iconColor="text-slate-700"
            />
          </div>
        </div>

        {/* Logout Action */}
        <div className="pt-2">
          <button
            type="button"
            onClick={onLogout}
            className="min-h-[44px] w-full py-3 bg-slate-50 hover:bg-rose-50 text-slate-600 hover:text-rose-600 font-bold text-xs rounded-xl border border-slate-200 hover:border-rose-200 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-[#0059FF]/40 transition-colors flex items-center justify-center gap-2 cursor-pointer"
          >
            <LogOut className="w-4 h-4" />
            <span>تسجيل الخروج</span>
          </button>
        </div>
      </div>
    </div>
  );
};
