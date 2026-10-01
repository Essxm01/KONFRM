import React, { useEffect } from 'react';

interface SplashScreenProps {
  onComplete: () => void;
}

export const SplashScreen: React.FC<SplashScreenProps> = ({ onComplete }) => {
  useEffect(() => {
    const timeoutId = window.setTimeout(onComplete, 2000);
    return () => window.clearTimeout(timeoutId);
  }, [onComplete]);

  return (
    <main className="min-h-screen w-full bg-[var(--konfrm-surface-primary)] flex flex-col items-center justify-center px-6 text-center dir-rtl" aria-label="بداية تجربة كونفرم للمالك">
      <div className="owner-entry-reveal flex flex-col items-center gap-5">
        <img src="/konfrm-symbol-black.svg" alt="" aria-hidden="true" width="80" height="80" className="h-20 w-20 object-contain" />
        <div className="flex flex-col items-center">
          <img src="/konfrm-wordmark-black.svg" alt="" aria-hidden="true" className="h-7 w-auto object-contain" />
          <p className="mt-2 text-base font-semibold text-[var(--konfrm-text-secondary)]">كونفرم للمالك</p>
        </div>
      </div>
      <span className="sr-only">جارٍ بدء التجربة</span>
    </main>
  );
};
