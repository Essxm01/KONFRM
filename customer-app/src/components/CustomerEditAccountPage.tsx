import React, { useState, useEffect } from 'react';
import {
  ChevronRight,
  User,
  Phone,
  Mail,
  CheckCircle2,
  AlertCircle,
} from 'lucide-react';
import { getApiUrl } from '../utils/api';
import type { CustomerUserProfile } from './CustomerAuthModal';
import { deriveUserInitials, resolveDisplayIdentifier } from './CustomerAccountHomeScreen';

interface CustomerEditAccountPageProps {
  user: CustomerUserProfile | null;
  customerPhone?: string | null;
  authToken: string;
  onBack: () => void;
  onUpdated: (user: CustomerUserProfile, newAccessToken?: string) => void;
  onReLogin?: () => void;
}

interface VerifiedIdentityRowProps {
  icon: React.ReactNode;
  label: string;
  value: string;
}

export const VerifiedIdentityRow: React.FC<VerifiedIdentityRowProps> = ({
  icon,
  label,
  value,
}) => (
  <div className="p-3.5 bg-slate-50 border border-slate-200/90 rounded-2xl flex items-center justify-between gap-3">
    <div className="flex items-center gap-3 min-w-0">
      <div className="w-9 h-9 bg-white border border-slate-200 rounded-xl flex items-center justify-center text-slate-600 shrink-0">
        {icon}
      </div>
      <div className="min-w-0">
        <span className="block text-[11px] font-bold text-slate-400">{label}</span>
        <bdi
          dir="ltr"
          style={{ direction: 'ltr', unicodeBidi: 'isolate' }}
          className="text-xs font-black text-slate-900 tracking-wide block truncate"
        >
          {value}
        </bdi>
      </div>
    </div>
    <div className="flex items-center gap-1.5 px-2.5 py-1 bg-emerald-50 border border-emerald-200 rounded-full shrink-0">
      <CheckCircle2 className="w-3.5 h-3.5 text-emerald-600" />
      <span className="text-[11px] font-black text-emerald-700">تم التحقق</span>
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

export const CustomerEditAccountPage: React.FC<CustomerEditAccountPageProps> = ({
  user,
  customerPhone,
  authToken,
  onBack,
  onUpdated,
  onReLogin,
}) => {
  const [currentUser, setCurrentUser] = useState<CustomerUserProfile | null>(user);
  const [fullName, setFullName] = useState<string>(user?.fullName || '');
  const [nameTouched, setNameTouched] = useState<boolean>(false);
  const [loading, setLoading] = useState<boolean>(false);
  const [error, setError] = useState<string>('');
  const [successMsg, setSuccessMsg] = useState<string>('');
  const [sessionExpired, setSessionExpired] = useState<boolean>(false);
  const [showDiscardConfirm, setShowDiscardConfirm] = useState<boolean>(false);

  // Sync state if user prop updates
  useEffect(() => {
    if (user) {
      setCurrentUser(user);
      if (!nameTouched) {
        setFullName(user.fullName || '');
      }
    }
  }, [user, nameTouched]);

  // Fetch canonical profile from API on mount
  useEffect(() => {
    if (authToken) {
      fetch(getApiUrl('/customer/profile'), {
        headers: { Authorization: `Bearer ${authToken}` },
      })
        .then((res) => {
          if (res.status === 401 || res.status === 403) {
            setSessionExpired(true);
            return null;
          }
          return res.json();
        })
        .then((json) => {
          if (json && json.success && json.data) {
            setCurrentUser(json.data);
            if (!nameTouched) {
              setFullName(json.data.fullName || '');
            }
          }
        })
        .catch(() => {});
    }
  }, [authToken, nameTouched]);

  // Derivations
  const initialName = (currentUser?.fullName || '').trim();
  const trimmedName = fullName.trim();
  const nameValidation = validateCustomerFullName(fullName);
  const isNameValid = nameValidation.isValid;
  const isDirty = isProfileFormDirty(initialName, fullName);
  const isSaveEnabled = isDirty && isNameValid && !loading;

  // Primary verified identity resolution
  const verifiedPhone =
    currentUser?.verifiedIdentifiers?.phone?.value ||
    (currentUser?.phoneVerifiedAt && currentUser?.phoneNumber ? currentUser.phoneNumber : null);
  const verifiedEmail = currentUser?.verifiedIdentifiers?.email?.value;
  const displayIdentifier = resolveDisplayIdentifier(currentUser, customerPhone);
  const initials = deriveUserInitials(trimmedName || currentUser?.fullName);

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
                  const updatedData: CustomerUserProfile = retryJson.data;
                  setCurrentUser(updatedData);
                  onUpdated(updatedData, newTok);
                  setSuccessMsg('تم حفظ التغييرات');
                  setTimeout(() => onBack(), 700);
                  return;
                }
              }
            } catch {
              // Refresh failed
            }
          }
          setSessionExpired(true);
          throw new Error('انتهت جلسة تسجيل الدخول');
        }

        throw new Error(
          json?.error?.message || 'تعذر حفظ التغييرات. حاول مرة أخرى.'
        );
      }

      // Explicit Canonical Read-After-Write Verification
      const getRes = await fetch(getApiUrl('/customer/profile'), {
        method: 'GET',
        headers: {
          Authorization: `Bearer ${currentToken}`,
        },
      });
      const getJson = await getRes.json().catch(() => null);
      const finalData: CustomerUserProfile =
        getRes.ok && getJson?.success && getJson?.data ? getJson.data : json.data;

      setCurrentUser(finalData);
      onUpdated(finalData);
      setSuccessMsg('تم حفظ التغييرات');

      // Subtle beat before return
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

  // Session Expired State
  if (sessionExpired) {
    return (
      <div className="min-h-screen bg-slate-50 text-right animate-fade-in flex flex-col justify-center px-4 py-8">
        <div className="max-w-[430px] w-full mx-auto bg-white p-6 rounded-3xl border border-slate-200 text-center space-y-4 shadow-xs">
          <div className="w-14 h-14 bg-amber-50 text-amber-600 rounded-2xl flex items-center justify-center mx-auto mb-2">
            <AlertCircle className="w-7 h-7" />
          </div>
          <div>
            <h3 className="font-black text-slate-900 text-base mb-1">
              انتهت جلسة تسجيل الدخول
            </h3>
            <p className="text-xs text-slate-500 font-bold max-w-xs mx-auto leading-relaxed">
              سجّل الدخول مرة أخرى لتعديل بياناتك.
            </p>
          </div>
          <button
            type="button"
            onClick={onReLogin || onBack}
            className="w-full min-h-[44px] py-3.5 bg-[#0059FF] hover:bg-blue-600 text-white font-black text-xs rounded-xl shadow-md transition-all cursor-pointer"
          >
            تسجيل الدخول مجددًا
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-slate-50 text-right animate-fade-in flex flex-col">
      {/* 1. Header Bar with 44x44px Back Button */}
      <header className="sticky top-0 z-30 bg-white/95 backdrop-blur-md border-b border-slate-200/90 px-4 py-2.5">
        <div className="max-w-[430px] mx-auto flex items-center justify-between min-h-[44px]">
          <div className="flex items-center gap-3">
            <button
              type="button"
              onClick={handleBackClick}
              aria-label="العودة للحساب"
              title="العودة للحساب"
              className="w-11 h-11 bg-slate-100 hover:bg-slate-200 text-slate-700 rounded-xl flex items-center justify-center transition-colors border border-slate-200/80 cursor-pointer"
            >
              <ChevronRight className="w-5 h-5" />
            </button>
            <h1 className="text-base font-black text-slate-900">البيانات الشخصية</h1>
          </div>
        </div>
      </header>

      {/* Main Content Area */}
      <main className="flex-1 max-w-[430px] w-full mx-auto px-4 py-5 space-y-5 pb-32">
        {/* 2. Compact Identity Context Card */}
        <div className="bg-white p-5 rounded-3xl border border-slate-200/80 shadow-none text-center space-y-2.5">
          <div
            className="w-14 h-14 rounded-full bg-slate-900 text-white font-black text-xl flex items-center justify-center mx-auto shadow-xs select-none"
            aria-hidden="true"
          >
            {initials}
          </div>
          <div>
            <h2 className="font-black text-slate-900 text-base leading-snug">
              {trimmedName || currentUser?.fullName || 'مستأجر'}
            </h2>
            <div className="mt-0.5 flex items-center justify-center">
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

        {/* 3. Section 1: المعلومات الشخصية (Editable Full Name) */}
        <div className="bg-white p-5 rounded-3xl border border-slate-200/80 shadow-none space-y-4">
          <h3 className="text-xs font-black text-slate-400 px-0.5">المعلومات الشخصية</h3>

          {error && (
            <div className="p-3.5 bg-rose-50 border border-rose-200 rounded-2xl flex items-start gap-2.5 text-xs font-bold text-rose-700">
              <AlertCircle className="w-4 h-4 text-rose-600 shrink-0 mt-0.5" />
              <span>{error}</span>
            </div>
          )}

          {successMsg && (
            <div className="p-3.5 bg-emerald-50 border border-emerald-200 rounded-2xl flex items-center gap-2.5 text-xs font-bold text-emerald-700">
              <CheckCircle2 className="w-4 h-4 text-emerald-600 shrink-0" />
              <span>{successMsg}</span>
            </div>
          )}

          <div className="space-y-1.5">
            <label htmlFor="customer-fullName-input" className="block text-xs font-black text-slate-800">
              الاسم الكامل <span className="text-rose-500">*</span>
            </label>
            <div className="relative">
              <input
                id="customer-fullName-input"
                type="text"
                value={fullName}
                onChange={(e) => {
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
                className={`w-full min-h-[52px] pl-4 pr-11 py-3.5 bg-slate-50 border ${
                  nameTouched && !isNameValid ? 'border-rose-300 bg-rose-50/20' : 'border-slate-200'
                } rounded-xl text-base font-bold text-slate-900 focus:outline-none focus:border-[#0059FF] focus:ring-2 focus:ring-[#0059FF]/20 focus:bg-white transition-all`}
              />
              <User className="w-5 h-5 text-slate-400 absolute top-4 right-3.5 pointer-events-none" />
            </div>
            {nameTouched && !isNameValid && (
              <p className="text-[11px] text-rose-600 font-bold">أدخل اسمك الكامل.</p>
            )}
            <p className="text-[11px] text-slate-400 font-bold">
              الاسم المستخدم في حسابك وطلبات الحجز على كونفرم
            </p>
          </div>
        </div>

        {/* 4. Section 2: بيانات تسجيل الدخول (Protected Read-Only Identity Rows) */}
        <div className="bg-white p-5 rounded-3xl border border-slate-200/80 shadow-none space-y-3">
          <h3 className="text-xs font-black text-slate-400 px-0.5">بيانات تسجيل الدخول</h3>

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

          {/* Fallback if neither verified identifier exists */}
          {!verifiedPhone && !verifiedEmail && (
            <div className="p-3.5 bg-slate-50 border border-slate-200 rounded-2xl text-xs text-slate-500 font-bold text-center">
              لا توجد معرفات إضافية موثقة
            </div>
          )}

          <p className="text-[11px] text-slate-400 font-bold px-0.5 pt-1">
            بيانات تسجيل الدخول موثقة ولا يمكن تعديلها مباشرة من هذه الصفحة
          </p>
        </div>
      </main>

      {/* 5. Sticky Save Footer */}
      <footer className="sticky bottom-0 z-20 bg-white/95 backdrop-blur-md border-t border-slate-200/90 p-4 shadow-lg">
        <div className="max-w-[430px] mx-auto">
          <button
            type="button"
            onClick={handleSave}
            disabled={!isSaveEnabled}
            className={`w-full min-h-[52px] py-3.5 px-6 font-black text-xs rounded-xl shadow-xs transition-all flex items-center justify-center gap-2 ${
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

      {/* 6. Unsaved Changes Back Confirmation Modal */}
      {showDiscardConfirm && (
        <div
          role="dialog"
          aria-modal="true"
          className="fixed inset-0 z-50 bg-slate-900/60 backdrop-blur-xs flex items-center justify-center p-4 animate-fade-in"
        >
          <div className="bg-white w-full max-w-sm rounded-3xl p-6 shadow-2xl border border-slate-200 text-center space-y-4 animate-scale-in">
            <div className="w-12 h-12 bg-amber-50 text-amber-600 rounded-2xl flex items-center justify-center mx-auto mb-1">
              <AlertCircle className="w-6 h-6" />
            </div>
            <div>
              <h3 className="font-black text-slate-900 text-base mb-1.5">
                هل تريد تجاهل التغييرات؟
              </h3>
              <p className="text-xs text-slate-500 font-bold leading-relaxed">
                لن يتم حفظ التعديلات التي أجريتها.
              </p>
            </div>
            <div className="grid grid-cols-2 gap-3 pt-2">
              <button
                type="button"
                onClick={() => setShowDiscardConfirm(false)}
                className="min-h-[44px] py-3 bg-slate-100 hover:bg-slate-200 text-slate-700 font-black text-xs rounded-xl transition-colors cursor-pointer"
              >
                متابعة التعديل
              </button>
              <button
                type="button"
                onClick={handleConfirmDiscard}
                className="min-h-[44px] py-3 bg-rose-600 hover:bg-rose-700 text-white font-black text-xs rounded-xl shadow-xs transition-colors cursor-pointer"
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
