import { useState, useEffect, useRef, useMemo, useCallback } from 'react';
import { CustomerHeader } from './components/CustomerHeader';
import { CoastalSearchBar } from './components/CoastalSearchBar';
import { PropertyCard, CustomerPropertyItem } from './components/PropertyCard';
import { ExploreSkeletonFeed, ExploreEmptyView, ExploreErrorView } from './components/ExploreStateViews';
import { PropertyDetailModal } from './components/PropertyDetailModal';
import { CustomerAuthModal, type CustomerUserProfile } from './components/CustomerAuthModal';
import { CustomerEditAccountPage } from './components/CustomerEditAccountPage';
import { CustomerAccountHomeScreen } from './components/CustomerAccountHomeScreen';
import { CustomerSupportModal } from './components/CustomerSupportModal';
import { CustomerWalletModal } from './components/CustomerWalletModal';
import type { BookingDetails } from './components/CustomerCheckoutModal';
import { BookingRequestSentScreen } from './components/BookingRequestSentScreen';
import {
  type BookingRequestSentState,
  resolveScreen11SuccessRouting,
} from './utils/customerScreen11BookingRequestSent';
import { CustomerBookingDetailsScreen } from './components/CustomerBookingDetailsScreen';
import { CustomerDepositPaymentScreen } from './components/CustomerDepositPaymentScreen';
import { type CustomerBookingRecord } from './utils/customerBookingPresentation';
import { CustomerMyBookingsScreen } from './components/CustomerMyBookingsScreen';
import { CustomerFavoritesScreen } from './components/CustomerFavoritesScreen';
import {
  CustomerBookingsUnauthorizedError,
  hasBookingActionRequired,
} from './utils/customerBookingPresentation';
import { CustomerBottomNav, CustomerTabType } from './components/CustomerBottomNav';
import { CustomerSplashScreen } from './components/CustomerSplashScreen';
import { CustomerWelcomeScreen } from './components/CustomerWelcomeScreen';
import { hasSeenCustomerEntry, markCustomerEntrySeen } from './utils/customerEntryState';
import { getApiUrl } from './utils/api';
import { isCustomerAuthV2Enabled, type AuthChallengeIssued, type AuthOrigin, type AuthIntent, type AuthV2RegistrationResult, type AuthV2VerifyResult } from './utils/customerAuthV2';
import { canResumeCustomerBooking, canResumeCustomerFavorite, createCustomerAuthResumePermission, createScreen10Handoff, createScreen10HandoffFromMissingLogin, resolveCustomerAuthEntry, cancelCustomerAuthV2, type CustomerAuthResumePermission, type CustomerBookingReviewContext, type Screen10Handoff } from './utils/customerAuthV2Flow';
import { restoreScreen08PhoneValue, type AuthV2FlowState, type Screen08FormState } from './utils/customerScreen08AuthV2';
import { orchestrateScreen10SessionFinalization } from './utils/customerScreen10AuthV2';
import { CustomerAuthScreen08 } from './components/CustomerAuthScreen08';
import { CustomerAuthScreen09 } from './components/CustomerAuthScreen09';
import { CustomerAuthScreen10 } from './components/CustomerAuthScreen10';
import { fetchCanonicalCollection } from './utils/customerTruthfulState';
import { buildPublicPropertySearchPath } from './utils/publicPropertySearch';
import { SearchRefineScreen } from './components/SearchRefineScreen';
import { SearchResultsScreen, type ResultsLoadState } from './components/SearchResultsScreen';
import {
  EMPTY_SEARCH_INTENT,
  toPublicSearchFilters,
  extractFilterMetadata,
  type SearchIntent,
  type PublicSearchFilters,
} from './utils/searchIntent';
import {
  fetchCustomerFavorites,
  addCustomerFavorite,
  removeCustomerFavorite,
  CustomerFavoritesUnauthorizedError,
  mergeCustomerProfile,
  fetchCustomerAccountSummary,
} from './utils/customerFavorites';
import {
  CustomerProfileIdentityIntegrityError,
  CustomerProfileUnauthorizedError,
  canonicalDisplayPhoneFromProfile,
  fetchCanonicalCustomerProfile,
} from './utils/customerProfileSession';
import {
  favoriteListStateAfterLoad,
  favoriteStateAfterServerRemoval,
  shouldApplyFavoriteRead,
  type CustomerFavoritesLoadState,
} from './utils/customerScreen15Favorites';
import { CustomerNotificationCenter } from './components/CustomerNotificationCenter';
import {
  type CustomerNotificationItem,
  type CustomerNotificationLoadState,
  fetchCustomerNotifications,
  fetchCustomerUnreadNotificationCount,
  markCustomerNotificationRead,
  CustomerNotificationsUnauthorizedError,
} from './utils/customerNotifications';
import {
  mergeNotificationPages,
  markNotificationReadLocally,
  applySuccessfulNotificationRead,
  notificationListStateAfterLoadMore,
  shouldApplyNotificationResponse,
  notificationListStateAfterLoad,
  notificationFailureState,
} from './utils/customerScreen16Notifications';

export function App() {
  const authV2Enabled = isCustomerAuthV2Enabled(import.meta.env.VITE_CUSTOMER_AUTH_V2_ENABLED);
  // Persisted credentials are only candidates. Public browsing can render while
  // restoration runs, but protected Customer UI waits for canonical validation.
  const [authToken, setAuthToken] = useState<string | null>(null);
  const [customerPhone, setCustomerPhone] = useState<string | null>(localStorage.getItem('sola_customer_phone'));
  const [userProfile, setUserProfile] = useState<CustomerUserProfile | null>(() => {
    const saved = localStorage.getItem('sola_customer_profile');
    try { return saved ? JSON.parse(saved) : null; } catch { return null; }
  });
  const [customerAuthError, setCustomerAuthError] = useState<string | null>(null);
  // Canonical Profile session truth (fail-closed): profile GET 401/403 invalidates
  // private Account/Profile state; zero verified identifiers fails closed as an
  // identity integrity failure. Public Explore state is never touched by either.
  const [profileSessionExpired, setProfileSessionExpired] = useState<boolean>(false);
  const [identityIntegrityFailed, setIdentityIntegrityFailed] = useState<boolean>(false);

  // Dedicated Full-Screen Edit Account View State
  const [isEditingAccount, setIsEditingAccount] = useState<boolean>(false);

  // Account Hub Summary State
  const [_accountSummary, setAccountSummary] = useState<{
    confirmedBookingsCount: number;
    upcomingStaysCount: number;
    totalBookingsCount: number;
    totalDepositsPaidEgp: number;
  } | null>(null);
  const [_accountSummaryError, setAccountSummaryError] = useState<string | null>(null);

  // Data & Search States
  const [properties, setProperties] = useState<CustomerPropertyItem[]>([]);
  const [filteredProperties, setFilteredProperties] = useState<CustomerPropertyItem[]>([]);
  const [activeDestination, setActiveDestination] = useState<string>('الكل');
  const [favoriteProperties, setFavoriteProperties] = useState<CustomerPropertyItem[]>([]);
  const [favoritesLoadState, setFavoritesLoadState] = useState<CustomerFavoritesLoadState>('UNAUTHORIZED');
  const [favoritesError, setFavoritesError] = useState<string | null>(null);
  const [favoritesActionError, setFavoritesActionError] = useState<string | null>(null);
  const [favoritesScreenActionError, setFavoritesScreenActionError] = useState<string | null>(null);
  const [favoriteInFlightIds, setFavoriteInFlightIds] = useState<Set<string>>(new Set());
  const [favoriteRemovalNotice, setFavoriteRemovalNotice] = useState<{ propertyId: string; message: string } | null>(null);
  const favoritesRequestIdRef = useRef(0);
  const favoriteMutationVersionRef = useRef(0);
  const favoritePropertiesRef = useRef<CustomerPropertyItem[]>([]);
  const favoriteSessionTokenRef = useRef<string | null>(null);
  const applyFavoriteProperties = (items: CustomerPropertyItem[]) => {
    favoritePropertiesRef.current = items;
    setFavoriteProperties(items);
  };
  const invalidateFavoriteReads = () => {
    favoriteMutationVersionRef.current += 1;
    favoritesRequestIdRef.current += 1;
  };
  const favorites = favoriteProperties.map((p) => p.id);
  const [propertyLoadState, setPropertyLoadState] = useState<'LOADING' | 'SUCCESS' | 'ERROR'>('LOADING');
  const [propertyLoadError, setPropertyLoadError] = useState<string | null>(null);

  // Navigation & Modals
  const [activeTab, setActiveTab] = useState<CustomerTabType>('EXPLORE');
  // First-entry UX gate (Phase 5 / C1): device-side only, fully independent
  // from canonical auth/session state. Returning users skip both surfaces.
  const [entryPhase, setEntryPhase] = useState<'SPLASH' | 'WELCOME' | 'APP'>(() =>
    hasSeenCustomerEntry() ? 'APP' : 'SPLASH'
  );
  const [selectedProperty, setSelectedProperty] = useState<CustomerPropertyItem | null>(null);
  // C2 discovery stack: Explore → Search & Refine → Results. State-driven
  // (no router); intent survives back navigation and property-detail round-trips.
  const [discoveryView, setDiscoveryView] = useState<'EXPLORE' | 'SEARCH_REFINE' | 'RESULTS'>('EXPLORE');
  const [refineOrigin, setRefineOrigin] = useState<'EXPLORE' | 'RESULTS'>('EXPLORE');
  const [searchIntent, setSearchIntent] = useState<SearchIntent>(EMPTY_SEARCH_INTENT);
  const [searchResults, setSearchResults] = useState<CustomerPropertyItem[]>([]);
  const [resultsLoadState, setResultsLoadState] = useState<ResultsLoadState>('LOADING');
  const [resultsErrorMessage, setResultsErrorMessage] = useState<string | null>(null);
  const searchRequestIdRef = useRef<number>(0);
  const resultsScrollTopRef = useRef<number>(0);
  const filterMetadata = useMemo(() => extractFilterMetadata(properties), [properties]);
  const [showAuthModal, setShowAuthModal] = useState<boolean>(false);
  const [authV2Flow, setAuthV2Flow] = useState<AuthV2FlowState | null>(null);
  const [authV2Challenge, setAuthV2Challenge] = useState<AuthChallengeIssued | null>(null);
  const [authV2Screen08Draft, setAuthV2Screen08Draft] = useState<Screen08FormState | null>(null);
  const [screen10Handoff, setScreen10Handoff] = useState<Screen10Handoff | null>(null);
  const [authResumePermission, setAuthResumePermission] = useState<CustomerAuthResumePermission | null>(null);
  const [showSupportModal, setShowSupportModal] = useState<boolean>(false);
  const [showWalletModal, setShowWalletModal] = useState<boolean>(false);
  const [bookingRequestSent, setBookingRequestSent] = useState<BookingRequestSentState | null>(null);
  const [restoreBookingReview, setRestoreBookingReview] = useState<boolean>(false);

  // Intercepted Guest Context
  const [interceptedContext, setInterceptedContext] = useState<CustomerBookingReviewContext | null>(() => {
    const saved = localStorage.getItem('sola_customer_pending_booking_intent');
    try { return saved ? JSON.parse(saved) : null; } catch { return null; }
  });

  const openAuthEntry = (origin: AuthOrigin, intent?: AuthIntent): void => {
    const entry = resolveCustomerAuthEntry(authV2Enabled, origin, intent);
    setAuthResumePermission(createCustomerAuthResumePermission(origin));
    if (entry.surface === 'AUTH_V2') {
      setShowAuthModal(false);
      setAuthV2Challenge(null);
      setAuthV2Screen08Draft(null);
      setScreen10Handoff(null);
      setAuthV2Flow({ origin: entry.origin, intent: entry.intent });
      return;
    }
    setShowAuthModal(true);
  };

  const clearAuthResumePermission = (): void => {
    if (authResumePermission?.type === 'FAVORITE') localStorage.removeItem('sola_customer_pending_favorite_property_id');
    if (authResumePermission?.type === 'BOOKING') localStorage.removeItem('sola_customer_pending_booking_intent');
    setAuthResumePermission(null);
  };

  const closeAuthV2 = (): void => {
    if (authV2Flow) {
      const handoff = cancelCustomerAuthV2(authV2Flow.origin);
      if (handoff.clearFavoriteHandoff) localStorage.removeItem('sola_customer_pending_favorite_property_id');
      if (handoff.clearBookingHandoff) localStorage.removeItem('sola_customer_pending_booking_intent');
    }
    clearAuthResumePermission();
    setAuthV2Challenge(null);
    setAuthV2Screen08Draft(null);
    setScreen10Handoff(null);
    setAuthV2Flow(null);
  };

  // Active Booking State for Checkout / Details
  const [activeBooking, setActiveBooking] = useState<BookingDetails | null>(null);
  const [customerBookings, setCustomerBookings] = useState<CustomerBookingRecord[]>([]);
  const [bookingDetailId, setBookingDetailId] = useState<string | null>(null);
  const [paymentScreenBookingId, setPaymentScreenBookingId] = useState<string | null>(null);
  const [bookingsError, setBookingsError] = useState<string | null>(null);
  const [bookingsLoadState, setBookingsLoadState] = useState<
    'INITIAL_LOADING' | 'LOADED' | 'EMPTY' | 'ERROR' | 'REFRESHING' | 'STALE_ERROR'
  >('INITIAL_LOADING');
  const [bookingsSessionExpired, setBookingsSessionExpired] = useState<boolean>(false);
  const [recentBookingSubmission, setRecentBookingSubmission] = useState<{ id: string; bookingNumber?: string } | null>(null);

  // Screen 16 — Notification Center State
  const [isNotificationCenterOpen, setIsNotificationCenterOpen] = useState<boolean>(false);
  const [notifications, setNotifications] = useState<CustomerNotificationItem[]>([]);
  const [notificationsLoadState, setNotificationsLoadState] = useState<CustomerNotificationLoadState>('INITIAL_LOADING');
  const [notificationsError, setNotificationsError] = useState<string | null>(null);
  const [notificationsNextCursor, setNotificationsNextCursor] = useState<string | null>(null);
  const [isLoadingMoreNotifications, setIsLoadingMoreNotifications] = useState<boolean>(false);
  const [unreadNotificationCount, setUnreadNotificationCount] = useState<number | null>(null);
  const [bookingDetailOrigin, setBookingDetailOrigin] = useState<'BOOKINGS' | 'NOTIFICATION_CENTER' | null>(null);

  const notificationsRef = useRef<CustomerNotificationItem[]>([]);
  const notificationSessionTokenRef = useRef<string | null>(null);
  const notificationsRequestIdRef = useRef(0);
  const unreadRequestIdRef = useRef(0);
  const notificationMutationVersionRef = useRef(0);
  const notificationReadInFlightRef = useRef<Set<string>>(new Set());

  const applyNotificationItems = useCallback((items: CustomerNotificationItem[]) => {
    notificationsRef.current = items;
    setNotifications(items);
  }, []);

  const invalidateNotificationWork = useCallback(() => {
    notificationsRequestIdRef.current += 1;
    unreadRequestIdRef.current += 1;
    notificationMutationVersionRef.current += 1;
    notificationReadInFlightRef.current.clear();
  }, []);

  const clearNotificationPrivateState = useCallback((loadState: CustomerNotificationLoadState = 'INITIAL_LOADING') => {
    notificationsRef.current = [];
    setNotifications([]);
    setNotificationsNextCursor(null);
    setUnreadNotificationCount(null);
    setIsLoadingMoreNotifications(false);
    setNotificationsError(null);
    setNotificationsLoadState(loadState);
  }, []);

  const activateNotificationSession = useCallback((token: string) => {
    if (notificationSessionTokenRef.current === token) return;
    invalidateNotificationWork();
    notificationSessionTokenRef.current = token;
    clearNotificationPrivateState('INITIAL_LOADING');
  }, [clearNotificationPrivateState, invalidateNotificationWork]);

  const handleNotificationSessionExpired = useCallback(() => {
    invalidateNotificationWork();
    notificationSessionTokenRef.current = null;
    clearNotificationPrivateState('SESSION_EXPIRED');
    setNotificationsError('انتهت جلسة تسجيل الدخول. سجّل الدخول مرة أخرى.');
  }, [clearNotificationPrivateState, invalidateNotificationWork]);

  const fetchUnreadCount = useCallback(async (token: string) => {
    activateNotificationSession(token);
    const requestId = ++unreadRequestIdRef.current;
    const mutationVersion = notificationMutationVersionRef.current;
    try {
      const count = await fetchCustomerUnreadNotificationCount(token);
      if (notificationSessionTokenRef.current !== token || requestId !== unreadRequestIdRef.current || mutationVersion !== notificationMutationVersionRef.current) return;
      setUnreadNotificationCount(count);
    } catch (err) {
      if (notificationSessionTokenRef.current !== token || requestId !== unreadRequestIdRef.current || mutationVersion !== notificationMutationVersionRef.current) return;
      if (err instanceof CustomerNotificationsUnauthorizedError) {
        handleNotificationSessionExpired();
        return;
      }
      setUnreadNotificationCount(null);
    }
  }, [activateNotificationSession, handleNotificationSessionExpired]);

  const loadNotifications = useCallback(async (
    token: string,
    mode: 'INITIAL' | 'REFRESH' | 'LOAD_MORE' = 'INITIAL',
  ) => {
    const sessionChanged = notificationSessionTokenRef.current !== token;
    activateNotificationSession(token);
    const requestSessionToken = token;
    const requestId = ++notificationsRequestIdRef.current;
    const mutationVersion = notificationMutationVersionRef.current;
    const currentItems = notificationsRef.current;
    const preserveSafeListOnFailure = currentItems.length > 0
      && notificationSessionTokenRef.current === token;

    if (mode === 'LOAD_MORE') {
      if (sessionChanged) return;
      if (!notificationsNextCursor || isLoadingMoreNotifications) return;
      setIsLoadingMoreNotifications(true);
    } else if (mode === 'REFRESH') {
      if (currentItems.length > 0) {
        setNotificationsLoadState('REFRESHING');
      } else {
        applyNotificationItems([]);
        setNotificationsNextCursor(null);
        setNotificationsLoadState('INITIAL_LOADING');
      }
    } else {
      const sameSessionWithSafeData = notificationSessionTokenRef.current === token && currentItems.length > 0;
      if (sameSessionWithSafeData) {
        setNotificationsLoadState('REFRESHING');
      } else {
        applyNotificationItems([]);
        setNotificationsNextCursor(null);
        setNotificationsLoadState('INITIAL_LOADING');
      }
      setNotificationsError(null);
    }

    try {
      const cursor = mode === 'LOAD_MORE' ? notificationsNextCursor : null;
      const page = await fetchCustomerNotifications(token, { limit: 20, cursor });

      if (!shouldApplyNotificationResponse(
        requestId,
        notificationsRequestIdRef.current,
        mutationVersion,
        notificationMutationVersionRef.current,
        requestSessionToken,
        notificationSessionTokenRef.current,
      )) return;

      if (mode === 'LOAD_MORE') {
        const merged = mergeNotificationPages(notificationsRef.current, page.items);
        applyNotificationItems(merged);
        setNotificationsNextCursor(page.nextCursor);
        setIsLoadingMoreNotifications(false);
        setNotificationsLoadState(notificationListStateAfterLoadMore(merged));
      } else {
        applyNotificationItems(page.items);
        setNotificationsNextCursor(page.nextCursor);
        setNotificationsLoadState(notificationListStateAfterLoad(page.items));
        setNotificationsError(null);
      }
    } catch (err: any) {
      if (!shouldApplyNotificationResponse(
        requestId,
        notificationsRequestIdRef.current,
        mutationVersion,
        notificationMutationVersionRef.current,
        requestSessionToken,
        notificationSessionTokenRef.current,
      )) return;
      if (err instanceof CustomerNotificationsUnauthorizedError) {
        handleNotificationSessionExpired();
        return;
      }

      if (mode === 'LOAD_MORE') {
        setIsLoadingMoreNotifications(false);
      }
      if (preserveSafeListOnFailure) {
        const failure = notificationFailureState(true, false);
        setNotificationsLoadState(failure.loadState);
        setNotificationsError(null);
      } else {
        const failure = notificationFailureState(false, false);
        setNotificationsLoadState(failure.loadState);
        setNotificationsError('تعذر تحميل الإشعارات. تحقق من اتصالك بالإنترنت وحاول مرة أخرى.');
      }
    }
  }, [activateNotificationSession, applyNotificationItems, notificationsNextCursor, isLoadingMoreNotifications, handleNotificationSessionExpired]);

  const handleSelectNotification = useCallback((item: CustomerNotificationItem) => {
    setBookingDetailOrigin('NOTIFICATION_CENTER');
    setBookingDetailId(item.bookingId);

    const token = authToken;
    const current = notificationsRef.current.find((notification) => notification.notificationId === item.notificationId);
    const wasUnread = Boolean(current && !current.isRead);
    if (!token || !wasUnread || notificationReadInFlightRef.current.has(item.notificationId)) return;

    notificationReadInFlightRef.current.add(item.notificationId);
    const mutationVersion = ++notificationMutationVersionRef.current;
    void markCustomerNotificationRead(token, item.notificationId)
      .then(() => {
        if (notificationSessionTokenRef.current !== token || mutationVersion !== notificationMutationVersionRef.current) return;
        applyNotificationItems(markNotificationReadLocally(notificationsRef.current, item.notificationId));
        setUnreadNotificationCount((previous) => applySuccessfulNotificationRead(
          notificationsRef.current,
          previous,
          item.notificationId,
          wasUnread,
        ).unreadCount);
      })
      .catch((err) => {
        if (notificationSessionTokenRef.current !== token || mutationVersion !== notificationMutationVersionRef.current) return;
        if (err instanceof CustomerNotificationsUnauthorizedError) handleNotificationSessionExpired();
      })
      .finally(() => {
        notificationReadInFlightRef.current.delete(item.notificationId);
      });
  }, [applyNotificationItems, authToken, handleNotificationSessionExpired]);

  const handleBookingDomainSessionExpired = useCallback(() => {
    setCustomerBookings([]);
    setActiveBooking(null);
    setRecentBookingSubmission(null);
    setBookingRequestSent(null);
    setBookingsSessionExpired(true);
    setBookingsError('انتهت جلسة الدخول. سجّل الدخول مرة أخرى لعرض حجوزاتك.');
    setBookingsLoadState('ERROR');
  }, []);

  const bookingsAuthState: 'AUTHENTICATED' | 'GUEST' | 'SESSION_EXPIRED' = !authToken
    ? 'GUEST'
    : bookingsSessionExpired
    ? 'SESSION_EXPIRED'
    : 'AUTHENTICATED';

  // Fetch Published Properties from API (Server-Authoritative Public Search — P2.1)
  const fetchProperties = async (filters?: Partial<PublicSearchFilters>) => {
    setPropertyLoadState('LOADING');
    setPropertyLoadError(null);
    let path: string;
    try {
      path = buildPublicPropertySearchPath(filters);
    } catch {
      setPropertyLoadError('بيانات البحث غير صالحة. راجع الفلاتر وحاول مرة أخرى.');
      setPropertyLoadState('ERROR');
      return;
    }
    const result = await fetchCanonicalCollection<CustomerPropertyItem>(path);
    if (result.kind === 'success') {
      setProperties(result.data);
      setFilteredProperties(result.data);
      setPropertyLoadState('SUCCESS');
      return;
    }
    setPropertyLoadError(result.kind === 'unauthorized'
      ? 'تعذر تحميل أماكن الإقامة حالياً. حاول مرة أخرى.'
      : result.message);
    setPropertyLoadState('ERROR');
  };

  useEffect(() => {
    fetchProperties();
  }, []);

  // Server-Authoritative Search Filter Handler (P2.1) — Explore quick chips
  const handleSelectDestinationChip = (dest: string) => {
    setActiveDestination(dest);
    if (dest === 'الكل') {
      void fetchProperties();
    } else {
      void fetchProperties({ destination: dest });
    }
  };

  // C2 Screen 05: canonical search execution from the Search & Refine intent.
  // Dates are intent-only and are never sent to the public search API.
  // searchRequestIdRef ensures newer requests always win and stale responses are ignored.
  const fetchSearchResults = async (intent: SearchIntent) => {
    const requestId = ++searchRequestIdRef.current;
    setResultsLoadState('LOADING');
    setResultsErrorMessage(null);
    try {
      const path = buildPublicPropertySearchPath(toPublicSearchFilters(intent));
      const result = await fetchCanonicalCollection<CustomerPropertyItem>(path);
      if (requestId !== searchRequestIdRef.current) return;
      if (result.kind === 'success') {
        setSearchResults(result.data);
        setResultsLoadState(result.data.length === 0 ? 'EMPTY' : 'LOADED');
        return;
      }
      setResultsErrorMessage(result.kind === 'unauthorized'
        ? 'تعذر تحميل نتائج البحث حالياً. حاول مرة أخرى.'
        : result.message);
      setResultsLoadState('ERROR');
    } catch (err: any) {
      if (requestId !== searchRequestIdRef.current) return;
      setResultsErrorMessage(err?.message || 'تعذر تحميل نتائج البحث. حاول مرة أخرى.');
      setResultsLoadState('ERROR');
    }
  };

  const handleSearchApply = (intent: SearchIntent) => {
    setSearchIntent(intent);
    setDiscoveryView('RESULTS');
    resultsScrollTopRef.current = 0;
    void fetchSearchResults(intent);
  };

  const handleBackToExplore = () => {
    setDiscoveryView('EXPLORE');
    setSearchIntent(EMPTY_SEARCH_INTENT);
    setActiveDestination('الكل');
    resultsScrollTopRef.current = 0;
  };

  const handleRefineClose = () => {
    if (refineOrigin === 'RESULTS') {
      setDiscoveryView('RESULTS');
    } else {
      handleBackToExplore();
    }
  };

  const loadCanonicalCustomerProfile = async (token: string, signal?: AbortSignal) => {
    return fetchCanonicalCustomerProfile(
      token,
      signal
        ? (input, init) => fetch(input, { ...init, signal })
        : fetch
    );
  };

  const applyCanonicalCustomerProfile = (canonicalProfile: CustomerUserProfile): void => {
    setUserProfile(canonicalProfile);
    localStorage.setItem('sola_customer_profile', JSON.stringify(canonicalProfile));
    // Only the canonical profile may populate the legacy phone display key —
    // and a canonical phoneNumber === null must explicitly clear it, so a
    // previous account's phone can never survive an account replacement.
    const canonicalPhone = canonicalDisplayPhoneFromProfile(canonicalProfile);
    if (canonicalPhone) {
      setCustomerPhone(canonicalPhone);
      localStorage.setItem('sola_customer_phone', canonicalPhone);
    } else {
      setCustomerPhone(null);
      localStorage.removeItem('sola_customer_phone');
    }
  };

  /**
   * Smallest centralized session invalidation for the Account/Profile domain:
   * drops private profile identity state (state + persisted candidates) and
   * exposes Session Expired UX. Unrelated public and private domain state
   * (Explore, Bookings, Favorites) keeps its own handling.
   */
  const invalidateCustomerProfileSession = useCallback((): void => {
    setProfileSessionExpired(true);
    setIdentityIntegrityFailed(false);
    setUserProfile(null);
    localStorage.removeItem('sola_customer_profile');
    setCustomerPhone(null);
    localStorage.removeItem('sola_customer_phone');
  }, []);

  // Fetch Real Customer Profile (AUTH-03 & P2.2)
  const fetchCustomerProfile = async (token?: string | null) => {
    const t = token || authToken || localStorage.getItem('sola_customer_access_token');
    if (!t) return;
    try {
      applyCanonicalCustomerProfile(await loadCanonicalCustomerProfile(t));
      setProfileSessionExpired(false);
      setIdentityIntegrityFailed(false);
    } catch (err: unknown) {
      if (err instanceof CustomerProfileUnauthorizedError) {
        invalidateCustomerProfileSession();
        return;
      }
      if (err instanceof CustomerProfileIdentityIntegrityError) {
        setIdentityIntegrityFailed(true);
        setUserProfile(null);
        localStorage.removeItem('sola_customer_profile');
        setCustomerPhone(null);
        localStorage.removeItem('sola_customer_phone');
        return;
      }
      setUserProfile(null);
      localStorage.removeItem('sola_customer_profile');
    }
  };

  // Fetch Real Account Hub Summary Metrics (P2.2)
  const fetchAccountSummary = async (token?: string | null) => {
    const t = token || authToken || localStorage.getItem('sola_customer_access_token');
    if (!t) return;
    setAccountSummaryError(null);
    try {
      const data = await fetchCustomerAccountSummary(t);
      setAccountSummary(data);
    } catch {
      setAccountSummary(null);
      setAccountSummaryError('تعذر تحميل ملخص الحساب');
    }
  };

  const handleFavoriteSessionExpired = useCallback(() => {
    invalidateFavoriteReads();
    favoriteSessionTokenRef.current = null;
    applyFavoriteProperties([]);
    setFavoriteInFlightIds(new Set());
    setFavoriteRemovalNotice(null);
    setFavoritesError(null);
    setFavoritesScreenActionError(null);
    setFavoritesLoadState('SESSION_EXPIRED');
  }, []);

  // Fetch Canonical Favorites Collection (Screen 15: server-authoritative states)
  const loadFavorites = async (token?: string | null) => {
    const t = token || authToken || localStorage.getItem('sola_customer_access_token');
    if (!t) {
      favoriteSessionTokenRef.current = null;
      applyFavoriteProperties([]);
      setFavoritesLoadState('UNAUTHORIZED');
      setFavoritesError(null);
      return;
    }
    const requestId = ++favoritesRequestIdRef.current;
    const mutationVersion = favoriteMutationVersionRef.current;
    const hadCanonicalList = favoriteSessionTokenRef.current === t && favoritePropertiesRef.current.length > 0;
    favoriteSessionTokenRef.current = t;
    setFavoritesLoadState(hadCanonicalList ? 'REFRESHING' : 'INITIAL_LOADING');
    setFavoritesError(null);
    try {
      const items = await fetchCustomerFavorites(t);
      if (!shouldApplyFavoriteRead(requestId, favoritesRequestIdRef.current, mutationVersion, favoriteMutationVersionRef.current, favoriteSessionTokenRef.current === t)) return;
      applyFavoriteProperties(items as any);
      setFavoritesLoadState(favoriteListStateAfterLoad(items as any));
      setFavoritesError(null);
    } catch (err: any) {
      if (!shouldApplyFavoriteRead(requestId, favoritesRequestIdRef.current, mutationVersion, favoriteMutationVersionRef.current, favoriteSessionTokenRef.current === t)) return;
      if (err instanceof CustomerFavoritesUnauthorizedError) {
        handleFavoriteSessionExpired();
        return;
      }
      setFavoritesError(null);
      setFavoritesLoadState(hadCanonicalList ? 'STALE_ERROR' : 'ERROR');
    }
  };

  const toBookingRecord = (booking: any): CustomerBookingRecord => ({
    id: booking.id,
    bookingNumber: booking.bookingNumber,
    propertyId: booking.propertyId,
    propertyTitle: booking.property?.title || booking.propertyTitle || '',
    propertyImage: booking.property?.images?.[0] || booking.propertyImage || '',
    locationName: booking.property?.locationName || booking.locationName || '',
    checkIn: booking.checkIn,
    checkOut: booking.checkOut,
    nights: Number(booking.nights),
    guestsCount: Number(booking.guestsCount ?? booking.guests ?? 0),
    status: booking.status,
    totalStay: Number(booking.financialSummary?.totalBookingValue ?? booking.totalStay),
    depositAmount: Number(booking.financialSummary?.depositAmount ?? booking.depositAmount),
    remainingAmount: Number(booking.financialSummary?.remainingBalance ?? booking.remainingAmount),
    property: booking.property,
  });

  const toBookingDetails = (booking: CustomerBookingRecord): BookingDetails => ({
    id: booking.id,
    bookingNumber: booking.bookingNumber,
    propertyTitle: booking.propertyTitle,
    checkIn: booking.checkIn,
    checkOut: booking.checkOut,
    totalNights: booking.nights,
    depositAmountEgp: booking.depositAmount,
    remainingBalanceEgp: booking.remainingAmount,
    totalBookingValueEgp: booking.totalStay,
    status: booking.status as BookingDetails['status'],
  });

  const loadCanonicalCustomerBookings = async (token: string, signal?: AbortSignal): Promise<CustomerBookingRecord[]> => {
    const res = await fetch(getApiUrl('/customer/bookings'), {
      headers: { Authorization: `Bearer ${token}` },
      signal,
    });
    if (res.status === 401 || res.status === 403) {
      throw new CustomerBookingsUnauthorizedError('CUSTOMER_BOOKINGS_UNAUTHORIZED');
    }
    const json = await res.json().catch(() => null);
    if (!res.ok || !json?.success || !Array.isArray(json.data)) {
      throw new Error(json?.error?.message || 'تعذر جلب طلبات الحجز');
    }
    return json.data.map(toBookingRecord);
  };

  const applyCanonicalCustomerBookings = (bookings: CustomerBookingRecord[]): void => {
    setCustomerBookings(bookings);
    setActiveBooking(bookings[0] ? toBookingDetails(bookings[0]) : null);
    setRecentBookingSubmission((current) => {
      if (current && bookings.some((b) => b.id === current.id)) {
        return null;
      }
      return current;
    });
  };

  const fetchBookings = async (token?: string | null, isRefresh = false) => {
    const t = token || authToken || localStorage.getItem('sola_customer_access_token');
    if (!t) {
      setActiveBooking(null);
      setCustomerBookings([]);
      setBookingsLoadState('EMPTY');
      setBookingsError(null);
      return [];
    }
    if (isRefresh && customerBookings.length > 0) {
      setBookingsLoadState('REFRESHING');
    } else {
      setBookingsLoadState('INITIAL_LOADING');
    }
    setBookingsError(null);
    try {
      const bookings = await loadCanonicalCustomerBookings(t);
      applyCanonicalCustomerBookings(bookings);
      setBookingsSessionExpired(false);
      setBookingsLoadState(bookings.length > 0 ? 'LOADED' : 'EMPTY');
      return bookings;
    } catch (err: any) {
      if (err instanceof CustomerBookingsUnauthorizedError) {
        setCustomerBookings([]);
        setActiveBooking(null);
        setBookingDetailId(null);
        setPaymentScreenBookingId(null);
        setRecentBookingSubmission(null);
        setBookingsSessionExpired(true);
        setBookingsError('انتهت صلاحية الجلسة. يرجى تسجيل الدخول مجدداً لعرض حجوزاتك.');
        setBookingsLoadState('ERROR');
      } else {
        const errorMsg = err?.message || 'تعذر جلب طلبات الحجز من الخادم';
        setBookingsError(errorMsg);
        setCustomerBookings((prev) => {
          if (prev.length > 0) {
            setBookingsLoadState('STALE_ERROR');
          } else {
            setBookingsLoadState('ERROR');
          }
          return prev;
        });
      }
      throw err;
    }
  };

  // Session Restoration & Token Refresh on Mount
  useEffect(() => {
    const restoreSession = async () => {
      const storedToken = localStorage.getItem('sola_customer_access_token');
      const refreshToken = localStorage.getItem('sola_customer_refresh_token');

      if (storedToken) {
        try {
          const profileRes = await fetch(getApiUrl('/customer/profile'), {
            headers: { Authorization: `Bearer ${storedToken}` },
          });
          const profileJson = await profileRes.json();
          if (profileRes.ok && profileJson.success && profileJson.data) {
            try {
              // Single canonical application path: explicit phone clearing on
              // phoneNumber === null prevents cross-account stale phone restore.
              applyCanonicalCustomerProfile(mergeCustomerProfile(profileJson.data));
            } catch {
              // Canonical payload without a verified identity fails closed.
              setIdentityIntegrityFailed(true);
              setUserProfile(null);
              localStorage.removeItem('sola_customer_profile');
              setCustomerPhone(null);
              localStorage.removeItem('sola_customer_phone');
              return;
            }
            activateNotificationSession(storedToken);
            setAuthToken(storedToken);
            setCustomerAuthError(null);
            fetchAccountSummary(storedToken);
            loadFavorites(storedToken);
            void fetchUnreadCount(storedToken);
            void fetchBookings(storedToken).catch(() => undefined);
            return;
          }
          if (profileRes.status !== 401 && profileRes.status !== 403) {
            setCustomerAuthError('تعذر التحقق من جلسة حسابك. تحقق من الاتصال ثم أعد المحاولة.');
            return;
          }
        } catch {
          setCustomerAuthError('تعذر التحقق من جلسة حسابك. تحقق من الاتصال ثم أعد المحاولة.');
          return;
        }
      }

      if (refreshToken) {
        try {
          const res = await fetch(getApiUrl('/auth/refresh'), {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ refreshToken }),
          });
          const json = await res.json();
          if (res.ok && json.success && json.data?.accessToken) {
            localStorage.setItem('sola_customer_access_token', json.data.accessToken);
            activateNotificationSession(json.data.accessToken);
            setAuthToken(json.data.accessToken);
            fetchCustomerProfile(json.data.accessToken);
            fetchAccountSummary(json.data.accessToken);
            loadFavorites(json.data.accessToken);
            void fetchUnreadCount(json.data.accessToken);
            void fetchBookings(json.data.accessToken).catch(() => undefined);
          } else {
            handleLogout();
          }
        } catch {
          // Keep the persisted candidate for a later retry, but never render it
          // as an authenticated Customer session.
          setCustomerAuthError('تعذر استعادة جلسة حسابك. تحقق من الاتصال ثم أعد المحاولة.');
        }
      } else if (!storedToken) {
        setAuthToken(null);
      }
    };
    restoreSession();
  }, []);

  // Sync profile & summary whenever navigating to Account tab
  useEffect(() => {
    if (activeTab === 'ACCOUNT') {
      const tok = authToken || localStorage.getItem('sola_customer_access_token');
      if (tok) {
        fetchCustomerProfile(tok);
        fetchAccountSummary(tok);
        void fetchUnreadCount(tok);
      }
    }
  }, [activeTab, authToken, fetchUnreadCount]);

  // Any token replacement is a notification-session boundary. This clears
  // private state before work from the previous Customer can be rendered.
  useEffect(() => {
    if (authToken) {
      activateNotificationSession(authToken);
    }
  }, [authToken, activateNotificationSession]);

  useEffect(() => {
    if (activeTab === 'FAVORITES' && authToken) {
      loadFavorites(authToken);
    }
  }, [activeTab, authToken]);

  useEffect(() => {
    if (activeTab === 'BOOKINGS' && authToken) {
      void fetchBookings(authToken).catch(() => undefined);
    }
  }, [activeTab, authToken]);

  // Favorite Toggle Handler (Protected Action - P2.2)
  const handleToggleFavorite = async (id: string, e?: React.MouseEvent) => {
    if (e) e.stopPropagation();

    if (!authToken) {
      // Unauthenticated Guest Interception for Favorites
      localStorage.setItem('sola_customer_pending_favorite_property_id', id);
      openAuthEntry({ type: 'PROTECTED_FAVORITE', propertyId: id });
      return;
    }

    if (favoriteInFlightIds.has(id)) return;

    setFavoriteInFlightIds((prev) => new Set(prev).add(id));
    setFavoritesActionError(null);
    const isFav = favoritePropertiesRef.current.some((p) => p.id === id);
    invalidateFavoriteReads();

    try {
      if (isFav) {
        await removeCustomerFavorite(authToken, id);
        invalidateFavoriteReads();
        const next = favoriteStateAfterServerRemoval(favoritePropertiesRef.current, id, favoritesLoadState);
        applyFavoriteProperties(next.items);
        setFavoritesLoadState(next.loadState);
      } else {
        await addCustomerFavorite(authToken, id);
        invalidateFavoriteReads();
        await loadFavorites(authToken);
      }
    } catch (err) {
      invalidateFavoriteReads();
      if (err instanceof CustomerFavoritesUnauthorizedError) {
        handleFavoriteSessionExpired();
        return;
      }
      // Error leaves heart state untouched truthfully and reveals retryable error
      setFavoritesActionError('تعذر تحديث المفضلة حالياً. يُرجى المحاولة مرة أخرى.');
    } finally {
      setFavoriteInFlightIds((prev) => {
        const next = new Set(prev);
        next.delete(id);
        return next;
      });
    }
  };

  // Screen 15 has stricter removal semantics than Explore/Search/Detail:
  // retain the card until the canonical DELETE confirms success.
  const handleFavoritesScreenRemove = async (id: string, e?: React.MouseEvent) => {
    if (e) e.stopPropagation();
    if (!authToken || favoriteInFlightIds.has(id)) return;
    setFavoriteInFlightIds((prev) => new Set(prev).add(id));
    setFavoritesScreenActionError(null);
    setFavoriteRemovalNotice(null);
    invalidateFavoriteReads();
    try {
      await removeCustomerFavorite(authToken, id);
      invalidateFavoriteReads();
      const next = favoriteStateAfterServerRemoval(favoritePropertiesRef.current, id, favoritesLoadState);
      applyFavoriteProperties(next.items);
      setFavoritesLoadState(next.loadState);
      setFavoriteRemovalNotice({ propertyId: id, message: 'تمت الإزالة من المفضلة' });
    } catch (err) {
      invalidateFavoriteReads();
      if (err instanceof CustomerFavoritesUnauthorizedError) {
        handleFavoriteSessionExpired();
      } else {
        setFavoritesScreenActionError('تعذر إزالة الإقامة من المفضلة. حاول مرة أخرى.');
      }
    } finally {
      setFavoriteInFlightIds((prev) => {
        const next = new Set(prev);
        next.delete(id);
        return next;
      });
    }
  };

  const handleFavoritesUndo = async () => {
    const notice = favoriteRemovalNotice;
    if (!notice || !authToken) return;
    setFavoriteRemovalNotice(null);
    setFavoriteInFlightIds((prev) => new Set(prev).add(notice.propertyId));
    setFavoritesScreenActionError(null);
    invalidateFavoriteReads();
    try {
      await addCustomerFavorite(authToken, notice.propertyId);
      invalidateFavoriteReads();
      await loadFavorites(authToken);
    } catch (err) {
      invalidateFavoriteReads();
      if (err instanceof CustomerFavoritesUnauthorizedError) {
        handleFavoriteSessionExpired();
      } else {
        setFavoritesScreenActionError('تعذر استعادة الإقامة إلى المفضلة. حاول حفظها مرة أخرى من صفحة الإقامة.');
      }
    } finally {
      setFavoriteInFlightIds((prev) => {
        const next = new Set(prev);
        next.delete(notice.propertyId);
        return next;
      });
    }
  };

  // Auth Handlers
  const handleAuthSuccess = (
    token: string,
    phone: string,
    refreshToken?: string,
    user?: CustomerUserProfile
  ) => {
    activateNotificationSession(token);
    localStorage.setItem('sola_customer_access_token', token);
    if (refreshToken) {
      localStorage.setItem('sola_customer_refresh_token', refreshToken);
    }
    // Session replacement: a fresh login must never keep a previous account's
    // phone. Only this login's own phone may seed the legacy display key; the
    // canonical profile fetch below remains the authority (and clears on null).
    if (phone) {
      localStorage.setItem('sola_customer_phone', phone);
      setCustomerPhone(phone);
    } else {
      localStorage.removeItem('sola_customer_phone');
      setCustomerPhone(null);
    }
    setAuthToken(token);
    setCustomerAuthError(null);
    setProfileSessionExpired(false);
    setIdentityIntegrityFailed(false);

    if (user) {
      try {
        const canonicalProfile = mergeCustomerProfile(user);
        setUserProfile(canonicalProfile as any);
        localStorage.setItem('sola_customer_profile', JSON.stringify(canonicalProfile));
      } catch {
        setUserProfile(null);
      }
    }
    // Always confirm canonical profile from server
    fetchCustomerProfile(token);
    fetchAccountSummary(token);
    void fetchBookings(token).catch(() => undefined);

    // Check pending favorite intent
    const pendingFavId = localStorage.getItem('sola_customer_pending_favorite_property_id');
    if (pendingFavId && canResumeCustomerFavorite(authResumePermission, pendingFavId)) {
      addCustomerFavorite(token, pendingFavId)
        .then(() => {
          localStorage.removeItem('sola_customer_pending_favorite_property_id');
          loadFavorites(token);
        })
        .catch(() => {
          localStorage.removeItem('sola_customer_pending_favorite_property_id');
          setAuthResumePermission(null);
          setFavoritesActionError('تعذر حفظ الوحدة في المفضلة. يُرجى المحاولة مرة أخرى.');
          loadFavorites(token);
        });
    } else {
      if (pendingFavId) localStorage.removeItem('sola_customer_pending_favorite_property_id');
      loadFavorites(token);
    }

    setShowAuthModal(false);

    // First-entry completion: any explicit exit (incl. a successful login or
    // account creation from Welcome) marks the entry seen for future launches.
    if (entryPhase === 'WELCOME') {
      markCustomerEntrySeen();
      setEntryPhase('APP');
    }

    // Context Preservation: Return to exact same property & dates post-login
    const bookingResumeContext = interceptedContext;
    if (canResumeCustomerBooking(authResumePermission, bookingResumeContext) && bookingResumeContext) {
      const targetProp = properties.find((p) => p.id === bookingResumeContext.propertyId) || selectedProperty;
      if (targetProp) {
        setSelectedProperty(targetProp);
      }
      setRestoreBookingReview(true);
    }
    setAuthResumePermission(null);
  };

  type CanonicalCustomerSession = {
    profile: ReturnType<typeof mergeCustomerProfile>;
    accountSummary: Awaited<ReturnType<typeof fetchCustomerAccountSummary>>;
    favorites: Awaited<ReturnType<typeof fetchCustomerFavorites>>;
    bookings: CustomerBookingRecord[];
  };

  const loadCanonicalCustomerSession = async (
    accessToken: string,
    signal: AbortSignal,
  ): Promise<CanonicalCustomerSession> => {
    const fetchWithSignal: typeof fetch = (input, init) => fetch(input, { ...init, signal });
    const [profile, canonicalAccountSummary, canonicalFavorites, bookings] = await Promise.all([
      loadCanonicalCustomerProfile(accessToken, signal),
      fetchCustomerAccountSummary(accessToken, fetchWithSignal),
      fetchCustomerFavorites(accessToken, fetchWithSignal),
      loadCanonicalCustomerBookings(accessToken, signal),
    ]);
    return {
      profile,
      accountSummary: canonicalAccountSummary,
      favorites: canonicalFavorites,
      bookings,
    };
  };

  const persistAuthV2Session = (
    tokens: { accessToken: string; refreshToken: string; expiresIn: number },
    _method: 'PHONE' | 'EMAIL',
    canonicalSession?: CanonicalCustomerSession,
  ): void => {
    const { accessToken, refreshToken } = tokens;
    activateNotificationSession(accessToken);
    localStorage.setItem('sola_customer_access_token', accessToken);
    localStorage.setItem('sola_customer_refresh_token', refreshToken);
    // Session replacement privacy: drop any previous account's phone BEFORE the
    // new canonical profile is applied. The canonical profile re-seeds it only
    // when its own phoneNumber is a real value (and clears it on null).
    localStorage.removeItem('sola_customer_phone');
    setCustomerPhone(null);
    setProfileSessionExpired(false);
    setIdentityIntegrityFailed(false);
    setAuthToken(accessToken);
    setCustomerAuthError(null);

    if (canonicalSession) {
      applyCanonicalCustomerProfile(canonicalSession.profile);
      setAccountSummary(canonicalSession.accountSummary);
      setAccountSummaryError(null);
      applyFavoriteProperties(canonicalSession.favorites as any);
      favoriteSessionTokenRef.current = accessToken;
      setFavoritesLoadState(favoriteListStateAfterLoad(canonicalSession.favorites as any));
      setFavoritesError(null);
      setFavoritesScreenActionError(null);
      applyCanonicalCustomerBookings(canonicalSession.bookings);
      setBookingsLoadState(canonicalSession.bookings.length > 0 ? 'LOADED' : 'EMPTY');
      setBookingsSessionExpired(false);
      setBookingsError(null);
      void fetchUnreadCount(accessToken);
    } else {
      void fetchCustomerProfile(accessToken);
      void fetchAccountSummary(accessToken);
      void fetchUnreadCount(accessToken);
      void fetchBookings(accessToken).catch(() => undefined);
    }
  };

  const resumeAuthV2Origin = (
    accessToken: string,
    origin: AuthOrigin,
    hasCanonicalSession: boolean,
  ): void => {
    const pendingFavId = localStorage.getItem('sola_customer_pending_favorite_property_id');
    if (pendingFavId && canResumeCustomerFavorite(authResumePermission, pendingFavId)) {
      void addCustomerFavorite(accessToken, pendingFavId)
        .then(() => {
          localStorage.removeItem('sola_customer_pending_favorite_property_id');
          return loadFavorites(accessToken);
        })
        .catch(() => {
          localStorage.removeItem('sola_customer_pending_favorite_property_id');
          setAuthResumePermission(null);
          setFavoritesActionError('تعذر حفظ الوحدة في المفضلة. يُرجى المحاولة مرة أخرى.');
          void loadFavorites(accessToken);
        });
    } else {
      if (pendingFavId) localStorage.removeItem('sola_customer_pending_favorite_property_id');
      if (!hasCanonicalSession) void loadFavorites(accessToken);
    }

    const bookingResumeContext = interceptedContext;
    if (canResumeCustomerBooking(authResumePermission, bookingResumeContext) && bookingResumeContext) {
      const targetProp = properties.find((p) => p.id === bookingResumeContext.propertyId) || selectedProperty;
      if (targetProp) setSelectedProperty(targetProp);
      setRestoreBookingReview(true);
    }

    if (origin.type === 'WELCOME_CREATE_ACCOUNT') {
      setActiveTab('EXPLORE');
      setDiscoveryView('EXPLORE');
      setIsEditingAccount(false);
    }

    if (origin.type === 'BOOKINGS_TAB') {
      setActiveTab('BOOKINGS');
      setDiscoveryView('EXPLORE');
      setIsEditingAccount(false);
      if (!hasCanonicalSession) {
        void fetchBookings(accessToken).catch(() => undefined);
      }
    }

    if (origin.type === 'FAVORITES_TAB') {
      setActiveTab('FAVORITES');
      setDiscoveryView('EXPLORE');
      setIsEditingAccount(false);
    }

    if (origin.type === 'NOTIFICATION_CENTER') {
      setActiveTab('ACCOUNT');
      setDiscoveryView('EXPLORE');
      setIsEditingAccount(false);
      setIsNotificationCenterOpen(true);
      void loadNotifications(accessToken, 'INITIAL');
      void fetchUnreadCount(accessToken);
    }

    if (origin.type === 'PROTECTED_PAYMENT') {
      setPaymentScreenBookingId(origin.bookingId);
      setBookingDetailId(origin.bookingId);
      setIsEditingAccount(false);
      setDiscoveryView('EXPLORE');
    }
  };

  const clearCompletedAuthV2Flow = (): void => {
    setScreen10Handoff(null);
    setAuthResumePermission(null);
    setAuthV2Challenge(null);
    setAuthV2Flow(null);
    if (entryPhase === 'WELCOME') {
      markCustomerEntrySeen();
      setEntryPhase('APP');
    }
  };

  /** Commit an existing-account Auth V2 session from Screen 09. */
  const commitAuthV2Session = (
    tokens: { accessToken: string; refreshToken: string; expiresIn: number },
    method: 'PHONE' | 'EMAIL',
    origin: AuthOrigin,
  ): void => {
    persistAuthV2Session(tokens, method);
    resumeAuthV2Origin(tokens.accessToken, origin, false);
    clearCompletedAuthV2Flow();
  };

  /**
   * Screen 10 fails closed: validate every canonical Customer read before
   * persisting tokens, clearing the handoff, or resuming a protected action.
   */
  const finalizeAuthV2Session = async (
    tokens: { accessToken: string; refreshToken: string; expiresIn: number },
    method: 'PHONE' | 'EMAIL',
    origin: AuthOrigin,
    signal: AbortSignal,
  ): Promise<void> => {
    await orchestrateScreen10SessionFinalization({
      origin,
      loadCanonicalSession: () => loadCanonicalCustomerSession(tokens.accessToken, signal),
      persistSession: (canonicalSession) => persistAuthV2Session(tokens, method, canonicalSession),
      resumeOrigin: (completedOrigin) => resumeAuthV2Origin(tokens.accessToken, completedOrigin, true),
      clearHandoff: clearCompletedAuthV2Flow,
      signal,
    });
  };

  /**
   * Screen 09 establishes existing-account sessions and hands verified new
   * phone registrations to Screen 10 without creating an account itself.
   */
  const handleAuthV2Verified = (result: AuthV2VerifyResult): void => {
    if (result.kind === 'CREATE_ACCOUNT_NEW_IDENTIFIER') {
      if (authV2Challenge && screen10Handoff?.continuationToken !== result.continuationToken) {
        setScreen10Handoff(createScreen10Handoff(result, authV2Challenge));
      }
      return;
    }
    if (result.kind !== 'AUTHENTICATED_EXISTING_ACCOUNT') return;
    commitAuthV2Session(result.tokens, result.method, result.authOrigin);
  };

  const handleAuthV2Screen10Completed = async (
    result: AuthV2RegistrationResult,
    signal: AbortSignal,
  ): Promise<void> => {
    if (!screen10Handoff) return;
    await finalizeAuthV2Session(result.tokens, screen10Handoff.method, screen10Handoff.authOrigin, signal);
  };

  const restartScreen10Verification = (): void => {
    if (!screen10Handoff) return;
    const preservedPhone = screen10Handoff.method === 'PHONE' ? restoreScreen08PhoneValue(screen10Handoff.identifier) : '';
    const preservedEmail = screen10Handoff.method === 'EMAIL' ? screen10Handoff.identifier : '';
    setAuthV2Screen08Draft((current) => ({
      intent: 'CREATE_ACCOUNT',
      method: screen10Handoff.method,
      phone: screen10Handoff.method === 'PHONE' ? (current?.phone || preservedPhone) : (current?.phone ?? ''),
      email: screen10Handoff.method === 'EMAIL' ? (current?.email || preservedEmail) : (current?.email ?? ''),
    }));
    setAuthV2Flow((current) => current ? { ...current, intent: 'CREATE_ACCOUNT' } : current);
    setScreen10Handoff(null);
    setAuthV2Challenge(null);
  };

  /** Store the verified, purpose-bound continuation for Screen 10 without
   * making a second account-creation request from Screen 09. */
  const handleAuthV2CreateFromMissing = (
    result: Extract<AuthV2VerifyResult, { kind: 'LOGIN_ACCOUNT_MISSING' }>,
  ): void => {
    if (!authV2Challenge) return;
    const handoff = createScreen10HandoffFromMissingLogin(result, authV2Challenge);
    if (handoff && screen10Handoff?.continuationToken !== handoff.continuationToken) {
      setScreen10Handoff(handoff);
      setAuthV2Screen08Draft((current) => ({
        intent: 'CREATE_ACCOUNT',
        method: result.method,
        phone: result.method === 'PHONE' ? restoreScreen08PhoneValue(authV2Challenge.identifier) : (current?.phone ?? ''),
        email: result.method === 'EMAIL' ? authV2Challenge.identifier : (current?.email ?? ''),
      }));
    }
  };


  const handleLogout = async () => {
    const refreshToken = localStorage.getItem('sola_customer_refresh_token');
    if (refreshToken) {
      try {
        await fetch(getApiUrl('/auth/revoke'), {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ refreshToken }),
        });
      } catch {}
    }
    localStorage.removeItem('sola_customer_access_token');
    localStorage.removeItem('sola_customer_refresh_token');
    localStorage.removeItem('sola_customer_phone');
    localStorage.removeItem('sola_customer_profile');
    localStorage.removeItem('sola_customer_pending_favorite_property_id');
    invalidateFavoriteReads();
    favoriteSessionTokenRef.current = null;
    setAuthToken(null);
    setCustomerPhone(null);
    setUserProfile(null);
    setAccountSummary(null);
    setAccountSummaryError(null);
    applyFavoriteProperties([]);
    setFavoritesLoadState('UNAUTHORIZED');
    setFavoritesError(null);
    setFavoritesScreenActionError(null);
    setFavoriteRemovalNotice(null);
    setActiveBooking(null);
    setCustomerBookings([]);
    setBookingDetailId(null);
    setBookingsError(null);
    setBookingsLoadState('EMPTY');
    setBookingsSessionExpired(false);
    setRecentBookingSubmission(null);
    setCustomerAuthError(null);
    setProfileSessionExpired(false);
    setIdentityIntegrityFailed(false);
    setAuthResumePermission(null);
    setScreen10Handoff(null);
    setAuthV2Challenge(null);
    setAuthV2Flow(null);
    setIsNotificationCenterOpen(false);
    invalidateNotificationWork();
    notificationSessionTokenRef.current = null;
    clearNotificationPrivateState('INITIAL_LOADING');
    setBookingDetailOrigin(null);
    setActiveTab('EXPLORE');
  };


  const handleBookingSuccess = async (bookingData: any) => {
    // 1. Capture safe optional property presentation title before clearing state
    const propertyTitle = selectedProperty?.title || null;

    // 2. Resolve truthful routing
    const routing = resolveScreen11SuccessRouting(bookingData, propertyTitle);

    // 3. Clear Screen 07 / Property Detail & pending booking intent safely
    setSelectedProperty(null);
    setRestoreBookingReview(false);
    setInterceptedContext(null);
    setAuthResumePermission(null);
    localStorage.removeItem('sola_customer_pending_booking_intent');

    // 4. Update state based on canonical routing
    if (routing.action === 'SHOW_SCREEN_11') {
      setBookingRequestSent(routing.state);
    } else {
      // Replay has progressed beyond pending owner review (approved, confirmed, etc.)
      try {
        const record = toBookingRecord(bookingData);
        setActiveBooking(toBookingDetails(record));
      } catch {}
      setDiscoveryView('EXPLORE');
      setIsEditingAccount(false);
      setActiveTab('BOOKINGS');
    }

    // 5. Allow background booking and account summary refresh (failure must NOT gate Screen 11)
    const token = authToken || localStorage.getItem('sola_customer_access_token');
    if (token) {
      void fetchBookings(token).catch(() => undefined);
      void fetchAccountSummary(token).catch(() => undefined);
    }
  };

  // ===== First-entry gate (Phase 5 / C1) =====
  // The shell's data effects (session restore + Explore fetch) already run on
  // mount above; the Splash transition is a fixed timer and never depends on
  // their outcome. Cancelling the auth modal simply re-reveals Welcome without
  // touching the entry flag.
  if (entryPhase === 'SPLASH') {
    return (
      <CustomerSplashScreen
        onFinished={() => setEntryPhase(hasSeenCustomerEntry() ? 'APP' : 'WELCOME')}
      />
    );
  }

  if (entryPhase === 'WELCOME') {
    const exitEntry = () => {
      markCustomerEntrySeen();
      setEntryPhase('APP');
    };
    // Login / Create Account are ALSO explicit Welcome exits: the marker is
    // persisted at handoff time, so cancelling auth (or closing the app
    // before finishing it) must never replay Splash/Welcome on a future
    // launch. The Welcome surface itself stays mounted for this runtime so
    // cancellation can return visually; handleAuthSuccess later completes
    // the transition into the shell.
    const handoffToAuthFromWelcome = () => {
      markCustomerEntrySeen();
      openAuthEntry({ type: 'WELCOME_LOGIN' }, 'LOGIN');
    };
    const handoffToCreateFromWelcome = () => {
      markCustomerEntrySeen();
      openAuthEntry({ type: 'WELCOME_CREATE_ACCOUNT' }, 'CREATE_ACCOUNT');
    };
    return (
      <>
        <CustomerWelcomeScreen
          onGuestBrowse={exitEntry}
          onLogin={handoffToAuthFromWelcome}
          onCreateAccount={handoffToCreateFromWelcome}
        />
        {/* Auth handoff uses the CURRENT prototype auth modal; C1 does not
            redesign authentication. Cancel simply returns to Welcome without
            touching the entry flag. */}
        {authV2Flow && screen10Handoff && (
          <CustomerAuthScreen10
            handoff={screen10Handoff}
            onBackToScreen08={restartScreen10Verification}
            onCompleted={handleAuthV2Screen10Completed}
          />
        )}
        {authV2Flow && !screen10Handoff && authV2Challenge && (
          <CustomerAuthScreen09
            challenge={authV2Challenge}
            onBackToScreen08={() => setAuthV2Challenge(null)}
            onVerified={handleAuthV2Verified}
            onCreateAccountFromMissing={handleAuthV2CreateFromMissing}
          />
        )}
        {authV2Flow && !screen10Handoff && !authV2Challenge && (
          <CustomerAuthScreen08
            initialIntent={authV2Flow.intent}
            initialForm={authV2Screen08Draft ?? undefined}
            authOrigin={authV2Flow.origin}
            onBack={closeAuthV2}
            onFormChange={setAuthV2Screen08Draft}
            onChallengeIssued={setAuthV2Challenge}
          />
        )}
        {!authV2Enabled && showAuthModal && (
          <CustomerAuthModal
            onClose={() => { setShowAuthModal(false); clearAuthResumePermission(); }}
            onSuccess={handleAuthSuccess}
            interceptedContext={interceptedContext}
          />
        )}
      </>
    );
  }

  return (
    <div className="min-h-screen bg-[#F5F7FA] flex justify-center selection:bg-blue-100">
      <div className="w-full max-w-[430px] min-h-screen bg-white shadow-2xl relative flex flex-col font-sans">
        {/* C2 Discovery stack (Screen 04/05) — full-screen, intent-preserving */}
        {discoveryView === 'SEARCH_REFINE' && (
          <SearchRefineScreen
            initialIntent={searchIntent}
            filterMetadata={filterMetadata}
            metadataLoadState={propertyLoadState}
            metadataError={propertyLoadError}
            onRetryMetadata={() => void fetchProperties()}
            onApply={handleSearchApply}
            onClose={handleRefineClose}
          />
        )}
        {discoveryView === 'RESULTS' && (
          <SearchResultsScreen
            intent={searchIntent}
            items={searchResults}
            loadState={resultsLoadState}
            errorMessage={resultsErrorMessage}
            favoritesActionError={favoritesActionError}
            onDismissFavoritesError={() => setFavoritesActionError(null)}
            onRetry={() => void fetchSearchResults(searchIntent)}
            onEditSearch={() => {
              setRefineOrigin('RESULTS');
              setDiscoveryView('SEARCH_REFINE');
            }}
            onBackToExplore={handleBackToExplore}
            onSelectProperty={(id) => {
              const item = searchResults.find((p) => p.id === id);
              if (item) setSelectedProperty(item);
            }}
            isFavorite={(id) => favorites.includes(id)}
            isFavoritePending={(id) => favoriteInFlightIds.has(id)}
            onToggleFavorite={handleToggleFavorite}
            restoreScrollTop={resultsScrollTopRef.current}
            onReportScrollTop={(offset) => { resultsScrollTopRef.current = offset; }}
          />
        )}
        {/* Full-Screen Dedicated Edit Account Page */}
        {isEditingAccount && authToken ? (
          <CustomerEditAccountPage
            user={userProfile}
            authToken={authToken}
            onBack={() => setIsEditingAccount(false)}
            onUpdated={(updated, newAccessToken) => {
              applyCanonicalCustomerProfile(updated);
              if (newAccessToken) {
                activateNotificationSession(newAccessToken);
                setAuthToken(newAccessToken);
                localStorage.setItem('sola_customer_access_token', newAccessToken);
              }
            }}
            onSessionExpired={invalidateCustomerProfileSession}
            onReLogin={() => {
              setIsEditingAccount(false);
              openAuthEntry({ type: 'ACCOUNT_TAB' });
            }}
          />
        ) : discoveryView !== 'EXPLORE' ? (
          // C2 discovery stack owns the screen; PropertyCard handoff from
          // Results re-renders the existing Property Details above it.
          null
        ) : (
          <>
            {/* Mobile White App Header */}
            <CustomerHeader
              isAuthenticated={Boolean(authToken)}
              customerPhone={customerPhone}
              customerFullName={userProfile?.fullName}
              customerAvatarUrl={userProfile?.avatarUrl}
              activeTab={activeTab}
              onOpenAuthModal={() => openAuthEntry({ type: activeTab === 'ACCOUNT' ? 'ACCOUNT_TAB' : 'EXPLORE_ACCOUNT' })}
              onGoToAccount={() => {
                setIsEditingAccount(false);
                setIsNotificationCenterOpen(false);
                setActiveTab('ACCOUNT');
              }}
              onLogout={handleLogout}
            />

            {/* Main Container — Max Mobile Width with dynamic safe-area aware BottomNav reservation */}
            <main
              className={`flex-1 w-full px-4 ${activeTab === 'EXPLORE' ? 'bg-[#F8FAFC] pt-5' : 'pt-3'}`}
              style={{ paddingBottom: 'calc(5rem + env(safe-area-inset-bottom, 0px))' }}
            >
              {favoritesActionError && (
                <div className="mb-3 p-3 bg-rose-50 border border-rose-200 text-rose-800 rounded-2xl text-xs font-bold flex items-center justify-between shadow-xs">
                  <span>{favoritesActionError}</span>
                  <button
                    onClick={() => setFavoritesActionError(null)}
                    className="text-rose-500 hover:text-rose-700 font-black mr-2 cursor-pointer"
                  >
                    ✕
                  </button>
                </div>
              )}
        {/* Tab 1: EXPLORE */}
        {activeTab === 'EXPLORE' && (
          <div>
            {/* Hero Section (24px/800 title, no emoji, Subtitle: NONE) */}
            <div className="mb-5">
              <h1 className="text-2xl font-extrabold text-slate-900 tracking-tight">
                هتصيف فين؟
              </h1>
            </div>

            {/* Mobile Coastal Search Entry (Screen 03 -> Screen 04) */}
            <div className="mb-6">
              <CoastalSearchBar
                onOpenSearch={() => {
                  setRefineOrigin('EXPLORE');
                  setDiscoveryView('SEARCH_REFINE');
                }}
                activeDestination={activeDestination}
                onSelectDestinationChip={handleSelectDestinationChip}
                intent={searchIntent}
              />
            </div>

            {/* Discovery Header (Truthful copy, no availability claim, no count during loading) */}
            <div className="flex items-baseline justify-between mb-3.5">
              <h2 className="text-[18px] font-bold text-slate-900">
                اكتشف الإقامات
              </h2>
              {propertyLoadState === 'SUCCESS' && filteredProperties.length > 0 && (
                <span className="text-[13px] font-medium text-slate-500">
                  {filteredProperties.length === 1
                    ? 'إقامة واحدة'
                    : filteredProperties.length === 2
                    ? 'إقامتان'
                    : `${filteredProperties.length} إقامات`}
                </span>
              )}
            </div>

            {/* Viewport States & Feed */}
            {propertyLoadState === 'LOADING' ? (
              <ExploreSkeletonFeed />
            ) : propertyLoadState === 'ERROR' ? (
              <ExploreErrorView
                title="تعذر تحميل الإقامات"
                support={propertyLoadError || 'حاول مرة تانية.'}
                onRetry={fetchProperties}
              />
            ) : filteredProperties.length === 0 ? (
              <ExploreEmptyView
                title="لسه مفيش إقامات هنا"
                support="جرّب مرة تانية لاحقًا."
              />
            ) : (
              /* Mobile Vertical Feed */
              <div className="space-y-4 my-3">
                {filteredProperties.map((prop) => (
                  <PropertyCard
                    key={prop.id}
                    property={prop}
                    onSelect={() => setSelectedProperty(prop)}
                    isFavorite={favorites.includes(prop.id)}
                    isFavoritePending={favoriteInFlightIds.has(prop.id)}
                    onToggleFavorite={handleToggleFavorite}
                  />
                ))}
              </div>
            )}
          </div>
        )}

        {/* Tab 2: FAVORITES / Screen 15 */}
        {activeTab === 'FAVORITES' && (
          <CustomerFavoritesScreen
            authState={!authToken ? 'GUEST' : favoritesLoadState === 'SESSION_EXPIRED' ? 'SESSION_EXPIRED' : 'AUTHENTICATED'}
            loadState={favoritesLoadState}
            favorites={favoriteProperties}
            error={favoritesError}
            actionError={favoritesScreenActionError}
            removingIds={favoriteInFlightIds}
            removalNotice={favoriteRemovalNotice}
            onLogin={() => openAuthEntry({ type: 'FAVORITES_TAB' }, 'LOGIN')}
            onRetry={() => void loadFavorites(authToken)}
            onExplore={() => setActiveTab('EXPLORE')}
            onOpenProperty={(id) => {
              const item = favoriteProperties.find((property) => property.id === id);
              if (item) setSelectedProperty(item);
            }}
            onToggleFavorite={handleFavoritesScreenRemove}
            onUndoRemoval={() => void handleFavoritesUndo()}
          />
        )}

        {/* Tab 3: BOOKINGS (Screen 12 My Bookings) */}
        {activeTab === 'BOOKINGS' && (
          <CustomerMyBookingsScreen
            authState={bookingsAuthState}
            loadState={bookingsLoadState}
            bookings={customerBookings}
            error={bookingsError}
            recentSubmission={recentBookingSubmission}
            onOpenBooking={(bookingId) => setBookingDetailId(bookingId)}
            onRetry={() => {
              void fetchBookings(authToken);
            }}
            onRefresh={() => {
              void fetchBookings(authToken, true);
            }}
            onExplore={() => {
              setActiveTab('EXPLORE');
            }}
            onLogin={() => {
              openAuthEntry({ type: 'BOOKINGS_TAB' }, 'LOGIN');
            }}
          />
        )}

        {/* Tab 4: ACCOUNT */}
        {activeTab === 'ACCOUNT' && (
          isNotificationCenterOpen ? (
            <CustomerNotificationCenter
              loadState={notificationsLoadState}
              notifications={notifications}
              hasMore={Boolean(notificationsNextCursor)}
              isLoadingMore={isLoadingMoreNotifications}
              error={notificationsError}
              onBack={() => setIsNotificationCenterOpen(false)}
              onSelectNotification={handleSelectNotification}
              onLoadMore={() => {
                if (authToken) void loadNotifications(authToken, 'LOAD_MORE');
              }}
              onRetry={() => {
                if (authToken) void loadNotifications(authToken, 'REFRESH');
              }}
              onReauthenticate={() => openAuthEntry({ type: 'NOTIFICATION_CENTER' }, 'LOGIN')}
            />
          ) : (
            <CustomerAccountHomeScreen
              isAuthenticated={Boolean(authToken)}
              userProfile={userProfile}
              unreadNotificationCount={unreadNotificationCount}
              onEditProfile={() => setIsEditingAccount(true)}
              onOpenBookings={() => {
                setIsEditingAccount(false);
                setActiveTab('BOOKINGS');
              }}
              onOpenFavorites={() => {
                setIsEditingAccount(false);
                setActiveTab('FAVORITES');
              }}
              onOpenNotifications={() => {
                setIsNotificationCenterOpen(true);
                if (authToken) {
                  void loadNotifications(authToken, 'INITIAL');
                }
              }}
              onOpenPayments={() => setShowWalletModal(true)}
              onOpenSupport={() => setShowSupportModal(true)}
              onLogout={handleLogout}
              onLogin={() => openAuthEntry({ type: 'ACCOUNT_TAB' })}
              isSessionExpired={Boolean(
                authToken &&
                  (profileSessionExpired ||
                    bookingsSessionExpired ||
                    favoritesLoadState === 'SESSION_EXPIRED')
              )}
              identityIntegrityFailed={Boolean(authToken && identityIntegrityFailed)}
              accountError={customerAuthError}
              onRetryAccount={() => {
                if (authToken) {
                  void fetchCustomerProfile(authToken);
                } else {
                  window.location.reload();
                }
              }}
            />
          )
        )}
      </main>
      </>
      )}

      {/* Full-Screen Mobile Property Details Screen/Sheet */}
      {selectedProperty && (
        <PropertyDetailModal
          property={selectedProperty}
          authToken={authToken}
          initialSearchIntent={searchIntent}
          onClose={() => {
            setSelectedProperty(null);
            if (activeTab === 'FAVORITES' && authToken) void loadFavorites(authToken);
          }}
          onBookingSuccess={handleBookingSuccess}
          onRequireAuth={(context) => {
            localStorage.setItem('sola_customer_pending_booking_intent', JSON.stringify(context));
            setInterceptedContext(context);
            openAuthEntry({ type: 'PROTECTED_BOOKING', context });
          }}
          restoredBookingIntent={interceptedContext}
          restoreBookingReview={restoreBookingReview}
          onBookingReviewRestored={() => {
            setRestoreBookingReview(false);
            setInterceptedContext(null);
            setAuthResumePermission(null);
            localStorage.removeItem('sola_customer_pending_booking_intent');
          }}
          isFavorite={favorites.includes(selectedProperty.id)}
          onToggleFavorite={(id) => handleToggleFavorite(id)}
        />
      )}

      {/* Screen 13 — Booking Details / Stay Hub */}
      {bookingDetailId && !paymentScreenBookingId && (
        <CustomerBookingDetailsScreen
          bookingId={bookingDetailId}
          authToken={authToken || ''}
          onBack={() => {
            const wasFromNotifications = bookingDetailOrigin === 'NOTIFICATION_CENTER';
            setBookingDetailId(null);
            setBookingDetailOrigin(null);
            if (wasFromNotifications) {
              if (authToken) {
                void loadNotifications(authToken, 'REFRESH');
                void fetchUnreadCount(authToken);
              }
            } else {
              if (authToken) void fetchBookings(authToken).catch(() => undefined);
            }
          }}
          onNavigateToPayment={(id) => setPaymentScreenBookingId(id)}
          onReconcileBooking={(updated) => {
            setCustomerBookings((prev) =>
              prev.map((b) => (b.id === updated.id ? { ...b, ...updated } : b))
            );
          }}
          onUnauthorizedDetected={handleBookingDomainSessionExpired}
          onReauthenticate={() => openAuthEntry({ type: 'BOOKINGS_TAB' }, 'LOGIN')}
        />
      )}

      {/* Screen 14 — Deposit Payment */}
      {paymentScreenBookingId && (
        <CustomerDepositPaymentScreen
          bookingId={paymentScreenBookingId}
          authToken={authToken || ''}
          onBack={() => setPaymentScreenBookingId(null)}
          onPaymentSuccess={(id) => {
            setPaymentScreenBookingId(null);
            setBookingDetailId(id);
            if (authToken) {
              void fetchBookings(authToken).catch(() => undefined);
              void fetchAccountSummary(authToken).catch(() => undefined);
            }
          }}
          onSessionExpired={(id) => {
            handleBookingDomainSessionExpired();
            openAuthEntry({ type: 'PROTECTED_PAYMENT', bookingId: id }, 'LOGIN');
          }}
        />
      )}

      {/* Customer Auth OTP Modal */}
      {authV2Flow && screen10Handoff && (
        <CustomerAuthScreen10
          handoff={screen10Handoff}
          onBackToScreen08={restartScreen10Verification}
          onCompleted={handleAuthV2Screen10Completed}
        />
      )}
      {authV2Flow && !screen10Handoff && authV2Challenge && (
        <CustomerAuthScreen09
          challenge={authV2Challenge}
          onBackToScreen08={() => setAuthV2Challenge(null)}
          onVerified={handleAuthV2Verified}
          onCreateAccountFromMissing={handleAuthV2CreateFromMissing}
        />
      )}
      {authV2Flow && !screen10Handoff && !authV2Challenge && (
        <CustomerAuthScreen08
          initialIntent={authV2Flow.intent}
          initialForm={authV2Screen08Draft ?? undefined}
          authOrigin={authV2Flow.origin}
          onBack={closeAuthV2}
          onFormChange={setAuthV2Screen08Draft}
          onChallengeIssued={setAuthV2Challenge}
        />
      )}
      {!authV2Enabled && showAuthModal && (
        <CustomerAuthModal
          onClose={() => { setShowAuthModal(false); clearAuthResumePermission(); }}
          onSuccess={handleAuthSuccess}
          interceptedContext={interceptedContext}
        />
      )}

      {/* Customer Support Modal */}
      {showSupportModal && (
        <CustomerSupportModal onClose={() => setShowSupportModal(false)} />
      )}

      {/* Customer Wallet & Payments Modal */}
      {showWalletModal && authToken && (
        <CustomerWalletModal
          authToken={authToken}
          onClose={() => setShowWalletModal(false)}
        />
      )}

      {/* Screen 11 — Booking Request Sent (dedicated full-screen mobile surface) */}
      {bookingRequestSent && (
        <BookingRequestSentScreen
          state={bookingRequestSent}
          onGoToBookings={() => {
            setRecentBookingSubmission({
              id: bookingRequestSent.booking.id,
              bookingNumber: bookingRequestSent.booking.bookingNumber,
            });
            setBookingRequestSent(null);
            setSelectedProperty(null);
            setDiscoveryView('EXPLORE');
            setIsEditingAccount(false);
            setActiveTab('BOOKINGS');
            setSearchIntent(EMPTY_SEARCH_INTENT);
            if (authToken) {
              void fetchBookings(authToken).catch(() => undefined);
            }
          }}
          onGoToExplore={() => {
            setBookingRequestSent(null);
            setSelectedProperty(null);
            setDiscoveryView('EXPLORE');
            setIsEditingAccount(false);
            setActiveTab('EXPLORE');
            setSearchIntent(EMPTY_SEARCH_INTENT);
          }}
        />
      )}

      {/* Native Persistent Mobile Bottom Navigation Bar (hidden during property details, edit account view, Screen 11, Screen 13, or Screen 14) */}
      {!selectedProperty && !isEditingAccount && discoveryView === 'EXPLORE' && !bookingRequestSent && !bookingDetailId && !paymentScreenBookingId && (
        <CustomerBottomNav
          activeTab={activeTab}
          onSelectTab={(tab) => {
            setIsEditingAccount(false);
            if (tab !== 'ACCOUNT') {
              setIsNotificationCenterOpen(false);
            }
            setActiveTab(tab);
          }}
          hasBookingActionRequired={hasBookingActionRequired(customerBookings)}
          hasActiveBooking={!!activeBooking}
        />
      )}
    </div>
  </div>
);
}

export default App;
