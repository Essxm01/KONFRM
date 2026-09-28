import React from 'react';
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
  customerPhone?: string | null;
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
  accountError?: string | null;
  onRetryAccount?: () => void;
}

export function deriveUserInitials(name?: string | null): string {
  if (!name || name.trim().length === 0) return 'م';
  const parts = name.trim().split(/\s+/).filter(Boolean);
  if (parts.length === 1) return parts[0].slice(0, 2);
  return `${parts[0][0]}.${parts[1][0]}`;
}

export function resolveDisplayIdentifier(
  userProfile: CustomerUserProfile | null,
  fallbackPhone?: string | null
): string {
  const verifiedPhone = userProfile?.verifiedIdentifiers?.phone?.value;
  const verifiedEmail = userProfile?.verifiedIdentifiers?.email?.value;

  // Dual verified: prioritize phone for primary account home identity
  if (verifiedPhone) return verifiedPhone;
  if (verifiedEmail) return verifiedEmail;

  // Fallback to legacy fields if verifiedIdentifiers missing
  if (userProfile?.phoneNumber) return userProfile.phoneNumber;
  if (fallbackPhone) return fallbackPhone;
  if (userProfile?.email) return userProfile.email;

  return 'حساب نشط';
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

const AccountNavigationRow: React.FC<AccountNavigationRowProps> = ({
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
    className="w-full min-h-[56px] p-3.5 flex items-center justify-between hover:bg-slate-50 transition-colors text-right cursor-pointer"
  >
    <div className="flex items-center gap-3 min-w-0">
      <div
        className={`w-9 h-9 ${iconBgColor} ${iconColor} rounded-xl flex items-center justify-center shrink-0`}
      >
        {icon}
      </div>
      <div className="min-w-0">
        <h5 className="font-black text-slate-900 text-xs truncate">{title}</h5>
        <p className="text-[11px] text-slate-400 font-bold truncate">{subtitle}</p>
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
  customerPhone,
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
  accountError,
  onRetryAccount,
}) => {
  // 1. Session Expired Recovery State
  if (isSessionExpired) {
    return (
      <div className="max-w-[430px] mx-auto px-4 py-8 text-right space-y-4 animate-fade-in">
        <div className="bg-white p-6 rounded-3xl border border-slate-200 text-center space-y-4 shadow-xs">
          <div className="w-14 h-14 bg-blue-50 text-[#0059FF] rounded-2xl flex items-center justify-center mx-auto mb-2">
            <AlertCircle className="w-7 h-7" />
          </div>
          <div>
            <h3 className="font-black text-slate-900 text-base mb-1">
              انتهت جلسة تسجيل الدخول
            </h3>
            <p className="text-xs text-slate-500 font-bold max-w-xs mx-auto leading-relaxed">
              سجّل الدخول مرة أخرى للوصول إلى حسابك.
            </p>
          </div>
          <button
            type="button"
            onClick={onLogin}
            className="w-full min-h-[44px] py-3 bg-[#0059FF] hover:bg-blue-600 text-white font-black text-xs rounded-xl shadow-md transition-all cursor-pointer"
          >
            تسجيل الدخول مجددًا
          </button>
        </div>
      </div>
    );
  }

  // 2. Hard Account Error State
  if (accountError) {
    return (
      <div className="max-w-[430px] mx-auto px-4 py-8 text-right space-y-4 animate-fade-in">
        <div className="bg-white p-6 rounded-3xl border border-slate-200 text-center space-y-4 shadow-xs">
          <div className="w-14 h-14 bg-rose-50 text-rose-600 rounded-2xl flex items-center justify-center mx-auto mb-2">
            <AlertCircle className="w-7 h-7" />
          </div>
          <div>
            <h3 className="font-black text-slate-900 text-base mb-1">
              تعذر تحميل الحساب
            </h3>
            <p className="text-xs text-slate-500 font-bold max-w-xs mx-auto leading-relaxed">
              تحقق من الاتصال وحاول مرة أخرى.
            </p>
          </div>
          {onRetryAccount && (
            <button
              type="button"
              onClick={onRetryAccount}
              className="w-full min-h-[44px] py-3 bg-[#0059FF] hover:bg-blue-600 text-white font-black text-xs rounded-xl shadow-md transition-all cursor-pointer"
            >
              إعادة المحاولة
            </button>
          )}
        </div>
      </div>
    );
  }

  // 3. Guest (Logged-Out) State
  if (!isAuthenticated) {
    return (
      <div className="max-w-[430px] mx-auto px-4 py-6 text-right space-y-6 animate-fade-in">
        <h1 className="text-xl font-black text-slate-900">حسابي</h1>
        <div className="bg-white p-6 rounded-3xl border border-slate-200 text-center space-y-4 shadow-xs">
          <div className="w-16 h-16 bg-blue-50 text-[#0059FF] rounded-3xl flex items-center justify-center mx-auto mb-2 shadow-xs">
            <User className="w-8 h-8" />
          </div>
          <div>
            <h3 className="font-black text-slate-900 text-base mb-1">
              سجّل الدخول إلى حسابك
            </h3>
            <p className="text-xs text-slate-500 font-bold max-w-xs mx-auto leading-relaxed">
              تابع حجوزاتك ومفضلاتك وبيانات حسابك من مكان واحد.
            </p>
          </div>
          <button
            type="button"
            onClick={onLogin}
            className="w-full min-h-[44px] py-3.5 bg-[#0059FF] hover:bg-blue-600 active:scale-[0.99] text-white font-black text-xs rounded-xl shadow-md transition-all cursor-pointer"
          >
            تسجيل الدخول أو إنشاء حساب
          </button>
        </div>
      </div>
    );
  }

  // 4. Authenticated Customer State
  const initials = deriveUserInitials(userProfile?.fullName);
  const displayName = userProfile?.fullName?.trim() || 'مستأجر';
  const displayIdentifier = resolveDisplayIdentifier(userProfile, customerPhone);
  const isProfileIncomplete = isCustomerProfileIncomplete(userProfile?.fullName);
  const unreadBadgeText = formatNotificationBadge(unreadNotificationCount);

  return (
    <div className="max-w-[430px] mx-auto px-4 py-5 text-right space-y-6 animate-fade-in pb-16">
      {/* Page Title */}
      <h1 className="text-xl font-black text-slate-900">حسابي</h1>

      {/* 1. Identity Block */}
      <div className="bg-white p-4 rounded-3xl border border-slate-200/90 shadow-none space-y-4">
        <div className="flex items-center justify-between gap-3">
          <div className="flex items-center gap-3.5 min-w-0">
            {/* 56x56 Circular Initials Avatar */}
            <div
              className="w-14 h-14 rounded-full bg-slate-900 text-white font-black text-xl flex items-center justify-center shrink-0 select-none shadow-xs"
              aria-hidden="true"
            >
              {initials}
            </div>
            <div className="min-w-0">
              <h2 className="text-lg font-black text-slate-900 line-clamp-2 leading-tight">
                {displayName}
              </h2>
              <div className="mt-1 flex items-center">
                <bdi
                  dir="ltr"
                  style={{ direction: 'ltr', unicodeBidi: 'isolate' }}
                  className="text-xs text-slate-500 font-bold tracking-wide"
                >
                  {displayIdentifier}
                </bdi>
              </div>
            </div>
          </div>

          {/* CTA: تعديل البيانات */}
          <button
            type="button"
            onClick={onEditProfile}
            aria-label="تعديل البيانات الشخصية"
            className="min-h-[44px] min-w-[44px] px-3.5 py-2 bg-slate-50 hover:bg-slate-100 text-slate-700 font-black text-xs rounded-xl border border-slate-200 transition-colors flex items-center gap-1.5 shrink-0 cursor-pointer"
          >
            <Edit3 className="w-3.5 h-3.5" />
            <span>تعديل البيانات</span>
          </button>
        </div>

        {/* 2. Incomplete Profile Prompt (Shown ONLY when fullName is genuinely empty) */}
        {isProfileIncomplete && (
          <div className="p-3.5 bg-blue-50/70 border border-blue-200/80 rounded-2xl flex items-center justify-between gap-3 text-xs font-bold text-slate-800">
            <div className="flex items-center gap-2 min-w-0">
              <AlertCircle className="w-4 h-4 text-[#0059FF] shrink-0" />
              <div className="min-w-0">
                <p className="font-black text-slate-900 text-xs">أكمل بيانات حسابك</p>
                <p className="text-[11px] text-slate-600 truncate">
                  أضف اسمك الكامل ليظهر حسابك بشكل صحيح.
                </p>
              </div>
            </div>
            <button
              type="button"
              onClick={onEditProfile}
              className="min-h-[44px] px-3.5 py-2 bg-[#0059FF] hover:bg-blue-600 text-white font-black text-xs rounded-xl shrink-0 transition-colors cursor-pointer"
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
          <h4 className="text-xs font-black text-slate-400 px-1">رحلاتك</h4>
          <div className="bg-white rounded-2xl border border-slate-200/80 shadow-none divide-y divide-slate-100 overflow-hidden">
            <AccountNavigationRow
              icon={<CalendarCheck className="w-4 h-4" />}
              title="حجوزاتي"
              subtitle="تابع حجوزاتك الحالية والسابقة"
              onClick={onOpenBookings}
              iconBgColor="bg-blue-50"
              iconColor="text-[#0059FF]"
            />
            <AccountNavigationRow
              icon={<Heart className="w-4 h-4" />}
              title="المفضلة"
              subtitle="الوحدات التي حفظتها للرجوع إليها"
              onClick={onOpenFavorites}
              iconBgColor="bg-rose-50"
              iconColor="text-rose-600"
            />
          </div>
        </div>

        {/* Section: النشاط */}
        <div className="space-y-2">
          <h4 className="text-xs font-black text-slate-400 px-1">النشاط</h4>
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
                  <span className="min-w-[20px] h-5 px-1.5 bg-[#0059FF] text-white text-[10px] font-black rounded-full flex items-center justify-center shadow-xs">
                    {unreadBadgeText}
                  </span>
                ) : null
              }
            />
          </div>
        </div>

        {/* Section: المدفوعات (Strictly المدفوعات - no wallet internals) */}
        <div className="space-y-2">
          <h4 className="text-xs font-black text-slate-400 px-1">المدفوعات</h4>
          <div className="bg-white rounded-2xl border border-slate-200/80 shadow-none overflow-hidden">
            <AccountNavigationRow
              icon={<CreditCard className="w-4 h-4" />}
              title="المدفوعات"
              subtitle="العربون والمدفوعات والمبالغ المتعلقة بحجوزاتك"
              onClick={onOpenPayments}
              iconBgColor="bg-emerald-50"
              iconColor="text-emerald-600"
            />
          </div>
        </div>

        {/* Section: الحساب */}
        <div className="space-y-2">
          <h4 className="text-xs font-black text-slate-400 px-1">الحساب</h4>
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

        {/* Section: المساعدة والقانون (Only real functional routes - no dead Settings or Legal links) */}
        <div className="space-y-2">
          <h4 className="text-xs font-black text-slate-400 px-1">المساعدة والقانون</h4>
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
            className="min-h-[44px] w-full py-3 bg-slate-50 hover:bg-rose-50 text-slate-600 hover:text-rose-600 font-bold text-xs rounded-xl border border-slate-200 hover:border-rose-200 transition-colors flex items-center justify-center gap-2 cursor-pointer"
          >
            <LogOut className="w-4 h-4" />
            <span>تسجيل الخروج</span>
          </button>
        </div>
      </div>
    </div>
  );
};
