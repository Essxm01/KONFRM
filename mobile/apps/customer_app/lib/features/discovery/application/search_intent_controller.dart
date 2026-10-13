import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/search_intent_models.dart';
import 'public_discovery_controller.dart';

/// Provider for active search intent across Customer exploration and search.
final searchIntentControllerProvider =
    StateNotifierProvider<SearchIntentController, SearchIntent>((ref) {
      return SearchIntentController();
    });

/// Provider for dynamic filter metadata derived from authentic public listings.
final filterMetadataProvider = Provider<FilterMetadata>((ref) {
  final discoveryState = ref.watch(publicDiscoveryControllerProvider);
  final properties = discoveryState.catalogProperties.isNotEmpty
      ? discoveryState.catalogProperties
      : discoveryState.properties;
  return FilterMetadata.fromProperties(properties);
});

/// Provider for dynamic filter metadata scoped to specific selected destinations.
final scopedFilterMetadataProvider =
    Provider.family<FilterMetadata, List<String>>((ref, destinations) {
      final discoveryState = ref.watch(publicDiscoveryControllerProvider);
      final properties = discoveryState.catalogProperties.isNotEmpty
          ? discoveryState.catalogProperties
          : discoveryState.properties;
      return FilterMetadata.fromProperties(
        properties,
        selectedDestinations: destinations,
      );
    });

class SearchIntentController extends StateNotifier<SearchIntent> {
  SearchIntentController([SearchIntent? initial])
    : super(initial ?? SearchIntent.empty);

  void setRegions(List<String> regions) {
    state = state.copyWith(selectedRegions: List.unmodifiable(regions));
  }

  void toggleRegion(String region) {
    final current = List<String>.from(state.selectedRegions);
    if (current.contains(region)) {
      current.remove(region);
    } else {
      current.add(region);
    }
    state = state.copyWith(selectedRegions: List.unmodifiable(current));
  }

  void clearRegions() {
    state = state.copyWith(selectedRegions: const []);
  }

  void setDates({DateTime? checkIn, DateTime? checkOut}) {
    state = state.copyWith(
      checkInDate: checkIn,
      checkOutDate: checkOut,
      clearCheckIn: checkIn == null,
      clearCheckOut: checkOut == null,
    );
  }

  void clearDates() {
    state = state.copyWith(clearCheckIn: true, clearCheckOut: true);
  }

  void setGuestCount(int guests) {
    if (guests < 1) return;
    state = state.copyWith(guestCount: guests);
  }

  void toggleUnitType(String unitType) {
    final normalized = unitType.trim().toUpperCase();
    if (normalized.isEmpty || normalized == 'ALL') {
      state = state.copyWith(selectedUnitTypes: const []);
      return;
    }
    final current = List<String>.from(state.selectedUnitTypes);
    if (current.contains(normalized)) {
      current.remove(normalized);
    } else {
      current.add(normalized);
    }
    state = state.copyWith(selectedUnitTypes: List.unmodifiable(current));
  }

  void clearUnitTypes() {
    state = state.copyWith(selectedUnitTypes: const []);
  }

  void setMaxPrice(double? maxPrice) {
    state = state.copyWith(
      maxPricePerNight: maxPrice,
      clearMaxPrice: maxPrice == null,
    );
  }

  void clearMaxPrice() {
    state = state.copyWith(clearMaxPrice: true);
  }

  void updateIntent(SearchIntent newIntent) {
    state = newIntent;
  }

  void resetAll() {
    state = SearchIntent.empty;
  }
}
