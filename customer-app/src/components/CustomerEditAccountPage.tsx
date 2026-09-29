import React, { useState, useEffect, useRef } from 'react';
import {
  ChevronRight,
  User,
  Phone,
  Mail,
  CheckCircle2,
  AlertCircle,
} from 'lucide-react';
import type { CustomerUserProfile } from './CustomerAuthModal';
import { deriveUserInitials, resolveDisplayIdentifier } from './CustomerAccountHomeScreen';
import { getApiUrl } from '../utils/api';
import { mergeCustomerProfile } from '../utils/customerFavorites';
import {
  CustomerProfileIdentityIntegrityError,
  CustomerProfileUnauthorizedError,
  fetchCanonicalCustomerProfile,
} from '../utils/customerProfileSession';

export interface CustomerNestedAppBarProps {
  title: string;
  onBack: () => void;
  backButtonRef?: React.RefObject<HTMLButtonElement | null>;
}

export const CustomerNestedAppBar: React.FC<CustomerNestedAppBarProps> = ({
  title,
  onBack,
  backButtonRef,
}) => (
  <header className="sticky top-0 z-30 bg-white/95 backdrop-blur-md border-b border-slate-200/80">
    <div className="max-w-[430px] mx-auto h-12 px-2 flex items-center justify-between">
      <button
        ref={backButtonRef}
        type="button"
        onClick={onBack}
        aria-label="الرجوع إلى حسابي"
        className="w-12 h-12 flex items-center justify-center text-slate-700 hover:text-slate-900 hover:bg-slate-100 rounded-xl focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-[#0059FF]/40 transition-colors cursor-pointer shrink-0"
      >
        <ChevronRight className="w-5 h-5" />
      </button>
      <h1 className="font-bold text-slate-900 text-base truncate text-center flex-1">
        {title}
      </h1>
      <div className="w-12 h-12 shrink-0 pointer-events-none" aria-hidden="true" />
    </div>
  </header>
);

export interface VerifiedIdentityRowProps {
  icon: React.ReactNode;
  label: string;
  value: string;
}

/**
 * Flat verified-identity row inside the grouped login surface: label and
 * restrained verification badge share the header line, giving the full
 * canonical value the remaining width. Emails wrap naturally (LTR island,
 * no break-all, no ellipsis, no orphaned characters).
 */
export const VerifiedIdentityRow: React.FC<VerifiedIdentityRowProps> = ({
  icon,
  label,
  value,
}) => (
  <div className="flex items-start gap-3 py-3.5 min-w-0">
    <div className="w-9 h-9 bg-slate-50 border border-slate-200/60 rounded-xl flex items-center justify-center text-slate-600 shrink-0 mt-0.5">
      {icon}
    </div>
    <div className="min-w-0 flex-1">
      <div className="flex items-center justify-between gap-2">
        <span className="text-xs font-bold text-slate-500">{label}</span>
        <span className="flex items-center gap-1 px-2 py-0.5 bg-emerald-50 border border-emerald-200 rounded-full shrink-0 select-none">
          <CheckCircle2 className="w-3 h-3 text-emerald-600" />
          <span className="text-xs font-bold text-emerald-700">تم التحقق</span>
        </span>
      </div>
      <bdi
        dir="ltr"
        style={{ direction: 'ltr', unicodeBidi: 'isolate' }}
        className="block mt-1 text-[13px] font-bold text-slate-900 tracking-normal min-w-0 text-balance [word-break:normal] [overflow-wrap:anywhere]"
      >
        {value}
      </bdi>
    </div>
  </div>
);

export function validateCustomerFullName(name: string): { isValid: boolean; error: string | null } {
  const trimmed = name.trim();
  if (trimmed.length === 0) {
    return { isValid: false, error: 'أدخل اسمك الكامل.' };
  }
  if (trimmed.length < 2) {
    return { isValid: false, error: 'الاسم يجب أن يتكون من حرفين على الأقل' };
  }
  return { isValid: true, error: null };
}

export function isProfileFormDirty(initialName: string, currentName: string): boolean {
  return (initialName || '').trim() !== (currentName || '').trim();
}

interface CustomerEditAccountPageProps {
  user: CustomerUserProfile | null;
  authToken: string;
  onBack: () => void;
  onUpdated: (user: CustomerUserProfile, newAccessToken?: string) => void;
  onReLogin?: () => void;
  /** Canonical 401/403 detected on this screen: App must invalidate private Account/Profile state fail-closed. */
  onSessionExpired?: () => void;
}

export const CustomerEditAccountPage: React.FC<CustomerEditAccountPageProps> = ({
  user,
  authToken,
  onBack,
  onUpdated,
  onReLogin,
  onSessionExpired,
}) => {
  const [currentUser, setCurrentUser] = useState<CustomerUserProfile | null>(user);
  const [fullName, setFullName] = useState<string>(user?.fullName || '');
  const [nameTouched, setNameTouched] = useState<boolean>(false);
  const [loading, setLoading] = useState<boolean>(false);
  const [error, setError] = useState<string>('');
  const [successMsg, setSuccessMsg] = useState<string>('');
  const [sessionExpired, setSessionExpired] = useState<boolean>(false);
  const [showDiscardConfirm, setShowDiscardConfirm] = useState<boolean>(false);
  const [imgError, setImgError] = useState<boolean>(false);
  // Canonical profile load lifecycle: driven by screen/session lifecycle only,
  // never by user field interaction. NETWORK_ERROR is a truthful retryable state.
  const [profileLoadState, setProfileLoadState] = useState<'IDLE' | 'LOADING' | 'READY' | 'NETWORK_ERROR'>('IDLE');
  const [identityIntegrityFailed, setIdentityIntegrityFailed] = useState<boolean>(false);
  const [reloadNonce, setReloadNonce] = useState<number>(0);
  // First user edit marker: a late canonical response must never overwrite active edits.
  const userEditedRef = useRef<boolean>(false);

  // Focus management refs for accessibility
  const backButtonRef = useRef<HTMLButtonElement | null>(null);
  const discardKeepEditingRef = useRef<HTMLButtonElement | null>(null);
  const discardConfirmRef = useRef<HTMLButtonElement | null>(null);

  // Sync state if user prop updates
  useEffect(() => {
    if (user) {
      setCurrentUser(user);
      if (!nameTouched) {
        setFullName(user.fullName || '');
      }
    }
  }, [user, nameTouched]);

  // Canonical profile load: opens Screen 18 with server truth; 401/403 fails
  // closed to Session Expired; network failure exposes a truthful retry state.
  useEffect(() => {
    if (!authToken) return;
    const controller = new AbortController();
    let active = true;
    setProfileLoadState('LOADING');
    fetchCanonicalCustomerProfile(authToken, (input, init) =>
      fetch(input, { ...init, signal: controller.signal })
    )
      .then((canonical) => {
        if (!active) return;
        setCurrentUser(canonical);
        if (!userEditedRef.current) {
          setFullName(canonical.fullName || '');
        }
        setProfileLoadState('READY');
      })
      .catch((err: unknown) => {
        if (!active || controller.signal.aborted) return;
        if (err instanceof CustomerProfileUnauthorizedError) {
          setSessionExpired(true);
          onSessionExpired?.();
          return;
        }
        if (err instanceof CustomerProfileIdentityIntegrityError) {
          setIdentityIntegrityFailed(true);
          return;
        }
        // Keep any user-entered text; expose a truthful retryable state.
        setProfileLoadState('NETWORK_ERROR');
      });
    return () => {
      active = false;
      controller.abort();
    };
  }, [authToken, reloadNonce, onSessionExpired]);

  // Focus trap and focus restoration for Discard Changes modal
  useEffect(() => {
    if (showDiscardConfirm) {
      const timer = setTimeout(() => {
        discardKeepEditingRef.current?.focus();
      }, 50);
      return () => clearTimeout(timer);
    }
    if (userEditedRef.current && backButtonRef.current) {
      backButtonRef.current.focus();
    }
    return undefined;
  }, [showDiscardConfirm]);

  const handleDialogKeyDown = (e: React.KeyboardEvent) => {
    if (e.key === 'Escape') {
      e.preventDefault();
      setShowDiscardConfirm(false);
      return;
    }
    if (e.key === 'Tab') {
      const focusable = [discardKeepEditingRef.current, discardConfirmRef.current].filter(Boolean) as HTMLElement[];
      if (focusable.length < 2) return;
      const first = focusable[0];
      const last = focusable[focusable.length - 1];
      if (e.shiftKey) {
        if (document.activeElement === first) {
          e.preventDefault();
          last.focus();
        }
      } else {
        if (document.activeElement === last) {
          e.preventDefault();
          first.focus();
        }
      }
    }
  };

  // Derivations
  const initialName = (currentUser?.fullName || '').trim();
  const trimmedName = fullName.trim();
  const nameValidation = validateCustomerFullName(fullName);
  const isNameValid = nameValidation.isValid;
  const isDirty = isProfileFormDirty(initialName, fullName);
  const isSaveEnabled = isDirty && isNameValid && !loading;

  // Primary verified identity resolution — full verified phone on Screen 18 (NO masking)
  const verifiedPhone = currentUser?.verifiedIdentifiers?.phone?.value || null;
  const verifiedEmail = currentUser?.verifiedIdentifiers?.email?.value || null;
  const displayIdentifier = resolveDisplayIdentifier(currentUser, { masked: false });
  const initials = deriveUserInitials(trimmedName || currentUser?.fullName);
  const hasAvatar = Boolean(currentUser?.avatarUrl && !imgError);

  // Fail-closed identity integrity: an authenticated canonical Customer must
  // carry at least one verified PHONE or EMAIL identifier. Evaluated only
  // after the canonical load settles so in-flight loads are not misread.
  const identityIntegrity =
    identityIntegrityFailed ||
    (profileLoadState === 'READY' && !verifiedPhone && !verifiedEmail);

  // Navigation back handler with dirty-state safety
  const handleBackClick = () => {
    if (isDirty) {
      setShowDiscardConfirm(true);
    } else {
      onBack();
    }
  };

  const handleConfirmDiscard = () => {
    setShowDiscardConfirm(false);
    onBack();
  };

  const handleSave = async (e?: React.FormEvent) => {
    if (e) e.preventDefault();
    setNameTouched(true);

    if (!isNameValid) {
      setError(nameValidation.error || 'أدخل اسمك الكامل.');
      return;
    }

    if (!isDirty || loading) return;

    setLoading(true);
    setError('');
    setSuccessMsg('');

    try {
      const currentToken = localStorage.getItem('sola_customer_access_token') || authToken;

      // Protected payload: sends fullName only, NEVER sends email or phone
      const patchBody = {
        fullName: trimmedName,
      };

      const res = await fetch(getApiUrl('/customer/profile'), {
        method: 'PATCH',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${currentToken}`,
        },
        body: JSON.stringify(patchBody),
      });

      let json: any = null;
      try {
        json = await res.json();
      } catch {
        json = null;
      }

      if (!res.ok || (json && json.success === false)) {
        if (
          res.status === 401 ||
          res.status === 403 ||
          json?.error?.code === 'INVALID_TOKEN' ||
          json?.error?.code === 'UNAUTHORIZED' ||
          json?.error?.code === 'EXPIRED_ACCESS_TOKEN'
        ) {
          // Attempt refresh
          const refreshToken = localStorage.getItem('sola_customer_refresh_token');
          if (refreshToken) {
            try {
              const refreshRes = await fetch(getApiUrl('/auth/refresh'), {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ refreshToken }),
              });
              const refreshJson = await refreshRes.json();
              if (refreshRes.ok && refreshJson.success && refreshJson.data?.accessToken) {
                const newTok = refreshJson.data.accessToken;
                localStorage.setItem('sola_customer_access_token', newTok);

                // Retry PATCH with refreshed token
                const retryRes = await fetch(getApiUrl('/customer/profile'), {
                  method: 'PATCH',
                  headers: {
                    'Content-Type': 'application/json',
                    Authorization: `Bearer ${newTok}`,
                  },
                  body: JSON.stringify(patchBody),
                });
                const retryJson = await retryRes.json();
                if (retryRes.ok && retryJson.success) {
                  try {
                    const updatedCanonical: CustomerUserProfile = mergeCustomerProfile(retryJson.data);
                    setCurrentUser(updatedCanonical);
                    onUpdated(updatedCanonical, newTok);
                    setSuccessMsg('تم حفظ التغييرات');
                    setTimeout(() => onBack(), 700);
                  } catch {
                    setIdentityIntegrityFailed(true);
                  }
                  return;
                }
              }
            } catch {
              // Refresh failed
            }
          }
          setSessionExpired(true);
          onSessionExpired?.();
          throw new Error('انتهت جلسة تسجيل الدخول');
        }

        throw new Error(
          json?.error?.message || 'تعذر حفظ التغييرات. حاول مرة أخرى.'
        );
      }

      // Explicit Canonical Read-After-Write Verification
      let finalCanonical: CustomerUserProfile | null = null;
      try {
        finalCanonical = await fetchCanonicalCustomerProfile(currentToken);
      } catch (verifyErr: unknown) {
        if (verifyErr instanceof CustomerProfileUnauthorizedError) {
          setSessionExpired(true);
          onSessionExpired?.();
          throw new Error('انتهت جلسة تسجيل الدخول');
        }
        if (verifyErr instanceof CustomerProfileIdentityIntegrityError) {
          setIdentityIntegrityFailed(true);
          return;
        }
      }
      if (!finalCanonical) {
        try {
          finalCanonical = mergeCustomerProfile(json?.data);
        } catch {
          setIdentityIntegrityFailed(true);
          return;
        }
      }

      setCurrentUser(finalCanonical);
      onUpdated(finalCanonical);
      setSuccessMsg('تم حفظ التغييرات');

      setTimeout(() => {
        onBack();
      }, 700);
    } catch (err: any) {
      if (err.message !== 'انتهت جلسة تسجيل الدخول') {
        setError(err?.message || 'تعذر حفظ التغييرات. حاول مرة أخرى.');
      }
    } finally {
      setLoading(false);
    }
  };

  // Identity Integrity Fail-Closed State
  if (identityIntegrity) {
    return (
      <div className="min-h-screen bg-slate-50 text-right animate-fade-in flex flex-col justify-center px-4 py-8">
        <div className="max-w-[430px] w-full mx-auto bg-white p-6 rounded-3xl border border-slate-200 text-center space-y-4 shadow-xs">
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
            onClick={onReLogin || onBack}
            className="w-full min-h-[44px] py-3.5 bg-[#0059FF] hover:bg-blue-600 text-white font-bold text-xs rounded-xl shadow-md focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-[#0059FF]/40 focus-visible:ring-offset-2 transition-all cursor-pointer"
          >
            تسجيل الدخول مجددًا
          </button>
        </div>
      </div>
    );
  }

  // Session Expired State
  if (sessionExpired) {
    return (
      <div className="min-h-screen bg-slate-50 text-right animate-fade-in flex flex-col justify-center px-4 py-8">
        <div className="max-w-[430px] w-full mx-auto bg-white p-6 rounded-3xl border border-slate-200 text-center space-y-4 shadow-xs">
          <div className="w-14 h-14 bg-blue-50 text-[#0059FF] rounded-2xl flex items-center justify-center mx-auto mb-2">
            <AlertCircle className="w-7 h-7" />
          </div>
          <div>
            <h3 className="font-bold text-slate-900 text-base mb-1">
              انتهت جلسة تسجيل الدخول
            </h3>
            <p className="text-xs text-slate-500 font-medium max-w-xs mx-auto leading-relaxed">
              سجّل الدخول مرة أخرى لتعديل بياناتك.
            </p>
          </div>
          <button
            type="button"
            onClick={onReLogin || onBack}
            className="w-full min-h-[44px] py-3.5 bg-[#0059FF] hover:bg-blue-600 text-white font-bold text-xs rounded-xl shadow-md focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-[#0059FF]/40 focus-visible:ring-offset-2 transition-all cursor-pointer"
          >
            تسجيل الدخول مجددًا
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-slate-50 text-right flex flex-col animate-fade-in">
      {/* 1. Standard Nested App Bar (48px height, RTL back action) */}
      <CustomerNestedAppBar
        title="البيانات الشخصية"
        onBack={handleBackClick}
        backButtonRef={backButtonRef}
      />

      {/* Main Content Area — Remediated from Card Soup into Clean Grouped Structure */}
      <main className="flex-1 max-w-[430px] w-full mx-auto px-4 py-5 space-y-5">
        {/* Network Error Retry Notice */}
        {profileLoadState === 'NETWORK_ERROR' && (
          <div className="p-3.5 bg-rose-50 border border-rose-200 rounded-2xl flex items-center justify-between gap-3 text-xs font-medium text-rose-700">
            <div className="flex items-center gap-2">
              <AlertCircle className="w-4 h-4 text-rose-600 shrink-0" />
              <span>تعذر مزامنة أحدث بيانات الحساب</span>
            </div>
            <button
              type="button"
              onClick={() => setReloadNonce((n) => n + 1)}
              className="text-[#0059FF] font-bold underline rounded focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-[#0059FF]/40 cursor-pointer"
            >
              إعادة المحاولة
            </button>
          </div>
        )}

        {/* 2. Compact Identity Context (Subtle surface, not tall hero card, display-only avatar) */}
        <div className="bg-white p-4 rounded-2xl border border-slate-200/80 shadow-2xs">
          <div className="flex items-center gap-3.5">
            {hasAvatar ? (
              <img
                src={currentUser?.avatarUrl || ''}
                alt={trimmedName || 'مستأجر'}
                onError={() => setImgError(true)}
                className="w-13 h-13 rounded-full object-cover shrink-0 select-none shadow-2xs border border-slate-100"
              />
            ) : initials ? (
              <div
                className="w-13 h-13 rounded-full bg-slate-900 text-white font-bold text-lg flex items-center justify-center shrink-0 select-none shadow-2xs"
                aria-hidden="true"
              >
                {initials}
              </div>
            ) : (
              <div
                className="w-13 h-13 rounded-full bg-slate-100 text-slate-600 flex items-center justify-center shrink-0 select-none shadow-2xs"
                aria-hidden="true"
              >
                <User className="w-6 h-6" />
              </div>
            )}
            <h2 className="min-w-0 flex-1 font-bold text-slate-900 text-base leading-snug break-words">
              {trimmedName || currentUser?.fullName || 'مستأجر'}
            </h2>
          </div>
          {/* Verified login identity — full-width line so normal emails stay on one line */}
          {displayIdentifier && (
            <bdi
              dir="ltr"
              style={{ direction: 'ltr', unicodeBidi: 'isolate' }}
              className="block mt-2 text-xs text-slate-500 font-medium tracking-normal [word-break:normal] [overflow-wrap:anywhere]"
            >
              {displayIdentifier}
            </bdi>
          )}
        </div>

        {/* 3. Section 1: المعلومات الشخصية (Editable Full Name) */}
        <section aria-labelledby="section-personal-info" className="space-y-3">
          <h3 id="section-personal-info" className="text-[13px] font-bold text-slate-500 px-1">
            المعلومات الشخصية
          </h3>

          <div className="bg-white p-4 rounded-2xl border border-slate-200/80 shadow-2xs space-y-4">
            {error && (
              <div className="p-3 bg-rose-50 border border-rose-200 rounded-xl flex items-start gap-2 text-xs font-medium text-rose-700">
                <AlertCircle className="w-4 h-4 text-rose-600 shrink-0 mt-0.5" />
                <span>{error}</span>
              </div>
            )}

            {successMsg && (
              <div className="p-3 bg-emerald-50 border border-emerald-200 rounded-xl flex items-center gap-2 text-xs font-medium text-emerald-700">
                <CheckCircle2 className="w-4 h-4 text-emerald-600 shrink-0" />
                <span>{successMsg}</span>
              </div>
            )}

            <div className="space-y-1.5">
              <label htmlFor="customer-fullName-input" className="block text-xs font-bold text-slate-800">
                الاسم الكامل <span className="text-rose-500">*</span>
              </label>
              <div className="relative">
                <input
                  id="customer-fullName-input"
                  type="text"
                  value={fullName}
                  aria-invalid={nameTouched && !isNameValid ? 'true' : 'false'}
                  aria-describedby={
                    nameTouched && !isNameValid
                      ? 'customer-fullName-error customer-fullName-help'
                      : 'customer-fullName-help'
                  }
                  onChange={(e) => {
                    userEditedRef.current = true;
                    setFullName(e.target.value);
                    if (error) setError('');
                  }}
                  onBlur={() => {
                    setNameTouched(true);
                    if (trimmedName.length > 0 && !isNameValid) {
                      setError('أدخل اسمك الكامل.');
                    }
                  }}
                  placeholder="الاسم الثلاثي أو الثنائي"
                  className={`w-full min-h-[48px] pl-4 pr-11 py-3 bg-slate-50 border ${
                    nameTouched && !isNameValid ? 'border-rose-300 bg-rose-50/20' : 'border-slate-200'
                  } rounded-xl text-sm font-bold text-slate-900 focus:outline-none focus:border-[#0059FF] focus:ring-2 focus:ring-[#0059FF]/20 focus:bg-white transition-all`}
                />
                <User className="w-5 h-5 text-slate-400 absolute top-3.5 right-3.5 pointer-events-none" />
              </div>
              {nameTouched && !isNameValid && (
                <p id="customer-fullName-error" className="text-xs text-rose-600 font-medium">
                  أدخل اسمك الكامل.
                </p>
              )}
              <p id="customer-fullName-help" className="text-xs text-slate-500 font-medium">
                الاسم المستخدم في حسابك وطلبات الحجز على كونفرم
              </p>
            </div>
          </div>
        </section>

        {/* 4. Section 2: بيانات تسجيل الدخول (one grouped surface — flat identity rows, hairline dividers) */}
        <section aria-labelledby="section-login-identity" className="space-y-3">
          <h3 id="section-login-identity" className="text-[13px] font-bold text-slate-500 px-1">
            بيانات تسجيل الدخول
          </h3>

          <div className="bg-white px-4 rounded-2xl border border-slate-200/80 shadow-2xs">
            <div className="divide-y divide-slate-100">
              {/* Render verified phone if present */}
              {verifiedPhone && (
                <VerifiedIdentityRow
                  icon={<Phone className="w-4 h-4" />}
                  label="رقم الهاتف"
                  value={verifiedPhone}
                />
              )}

              {/* Render verified email if present */}
              {verifiedEmail && (
                <VerifiedIdentityRow
                  icon={<Mail className="w-4 h-4" />}
                  label="البريد الإلكتروني"
                  value={verifiedEmail}
                />
              )}
            </div>

            {/* Production Email Linking gate: no add email button when email is absent */}

            <p className="text-xs text-slate-500 font-normal pb-3.5 pt-1">
              بيانات تسجيل الدخول موثقة ولا يمكن تعديلها مباشرة من هذه الصفحة
            </p>
          </div>
        </section>
      </main>

      {/* 5. Sticky Save Footer (StickyFormActionBar) */}
      <footer className="sticky bottom-0 z-20 bg-white/95 backdrop-blur-md border-t border-slate-200/80 p-4 shadow-md">
        <div className="max-w-[430px] mx-auto">
          {/* Stable screen-reader status region: announces saving/success politely without duplicating visible copy */}
          <div role="status" aria-live="polite" className="sr-only">
            {loading ? 'جارٍ حفظ التغييرات…' : successMsg || ''}
          </div>
          <button
            type="button"
            onClick={handleSave}
            disabled={!isSaveEnabled}
            className={`w-full min-h-[48px] py-3 px-6 font-bold text-xs rounded-xl shadow-xs focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-[#0059FF]/40 focus-visible:ring-offset-2 transition-all flex items-center justify-center gap-2 ${
              isSaveEnabled
                ? 'bg-[#0059FF] hover:bg-blue-600 active:scale-[0.99] text-white shadow-blue-500/25 shadow-md cursor-pointer'
                : 'bg-slate-100 text-slate-400 border border-slate-200 cursor-not-allowed'
            }`}
          >
            {loading ? (
              <>
                <div className="w-4 h-4 border-2 border-white/30 border-t-white rounded-full animate-spin" />
                <span>جارٍ حفظ التغييرات…</span>
              </>
            ) : (
              <span>حفظ التغييرات</span>
            )}
          </button>
        </div>
      </footer>

      {/* 6. Unsaved Changes Back Confirmation Modal with Full Accessibility */}
      {showDiscardConfirm && (
        <div
          role="dialog"
          aria-modal="true"
          aria-labelledby="discard-dialog-title"
          aria-describedby="discard-dialog-desc"
          onKeyDown={handleDialogKeyDown}
          className="fixed inset-0 z-50 bg-slate-900/60 backdrop-blur-xs flex items-center justify-center p-4 animate-fade-in"
        >
          <div className="bg-white w-full max-w-sm rounded-3xl p-6 shadow-2xl border border-slate-200 text-center space-y-4 animate-scale-in">
            <div className="w-12 h-12 bg-slate-100 text-slate-600 rounded-2xl flex items-center justify-center mx-auto mb-1">
              <AlertCircle className="w-6 h-6" />
            </div>
            <div>
              <h3 id="discard-dialog-title" className="font-bold text-slate-900 text-base mb-1.5">
                هل تريد تجاهل التغييرات؟
              </h3>
              <p id="discard-dialog-desc" className="text-xs text-slate-500 font-medium leading-relaxed">
                لن يتم حفظ التعديلات التي أجريتها.
              </p>
            </div>
            <div className="grid grid-cols-2 gap-3 pt-2">
              <button
                ref={discardKeepEditingRef}
                type="button"
                onClick={() => setShowDiscardConfirm(false)}
                className="min-h-[44px] py-3 bg-slate-100 hover:bg-slate-200 text-slate-700 font-bold text-xs rounded-xl focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-[#0059FF]/40 transition-colors cursor-pointer"
              >
                متابعة التعديل
              </button>
              <button
                ref={discardConfirmRef}
                type="button"
                onClick={handleConfirmDiscard}
                className="min-h-[44px] py-3 bg-rose-600 hover:bg-rose-700 text-white font-bold text-xs rounded-xl shadow-xs focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-[#0059FF]/40 focus-visible:ring-offset-2 transition-colors cursor-pointer"
              >
                تجاهل التغييرات
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};
