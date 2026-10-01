import React, { useEffect, useState } from 'react';

// KONFRM Customer Splash — Screen 01 (Phase 5 / C1).
//
// Brand recognition only: white canvas, KONFRM mark + wordmark. No progress
// percentage, no carousel, no data dependency. The transition is a fixed short
// timer (deterministic), never tied to Explore API success. Motion is disabled
// under prefers-reduced-motion via CSS (see .customer-splash-* in index.css).

const SPLASH_DURATION_MS = 1200;

export const CustomerSplashScreen: React.FC<{ onFinished: () => void }> = ({ onFinished }) => {
  const [leaving, setLeaving] = useState(false);
  const onFinishedRef = React.useRef(onFinished);
  onFinishedRef.current = onFinished;

  useEffect(() => {
    const fadeAt = window.setTimeout(() => setLeaving(true), SPLASH_DURATION_MS - 180);
    const finishAt = window.setTimeout(() => onFinishedRef.current(), SPLASH_DURATION_MS);
    return () => {
      window.clearTimeout(fadeAt);
      window.clearTimeout(finishAt);
    };
  }, []);

  return (
    <div
      dir="rtl"
      role="status"
      aria-label="كونفرم"
      className={`fixed inset-0 z-[90] bg-white flex flex-col items-center justify-center customer-splash-fade ${
        leaving ? 'customer-splash-leaving' : ''
      }`}
    >
      {/* Canonical KONFRM brand mark */}
      <div className="customer-splash-logo relative flex items-center justify-center mb-5">
        <img
          src="/konfrm-symbol-black.svg"
          alt=""
          aria-hidden="true"
          width="88"
          height="88"
          className="w-[88px] h-[88px] object-contain"
        />
      </div>

      {/* Wordmark */}
      <img
        src="/konfrm-wordmark-black.svg"
        alt=""
        aria-hidden="true"
        className="customer-splash-logo h-8 w-auto object-contain select-none"
      />
      <p className="customer-splash-logo mt-2 text-sm font-bold text-[#475569] select-none" aria-hidden="true">
        كونفرم
      </p>
    </div>
  );
};
