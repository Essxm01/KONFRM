import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/public_property.dart';
import '../data/public_property_search_repository.dart';

enum PublicDiscoveryStatus {
  loading,
  results,
  empty,
  configurationError,
  networkError,
  timeout,
  serverError,
  unauthorized,
  requestRejected,
  invalidResponse,
  invalidFilters,
}

class PublicDiscoveryState {
  const PublicDiscoveryState({
    required this.status,
    this.properties = const [],
    this.catalogProperties = const [],
    this.filters = const PublicPropertySearchFilters(),
  });

  final PublicDiscoveryStatus status;
  final List<PublicProperty> properties;
  final List<PublicProperty> catalogProperties;
  final PublicPropertySearchFilters filters;

  bool get isLoading => status == PublicDiscoveryStatus.loading;
  bool get canRetry => switch (status) {
    PublicDiscoveryStatus.networkError ||
    PublicDiscoveryStatus.timeout ||
    PublicDiscoveryStatus.serverError => true,
    _ => false,
  };
}

final publicDiscoveryControllerProvider =
    StateNotifierProvider.autoDispose<
      PublicDiscoveryController,
      PublicDiscoveryState
    >(
      (ref) => PublicDiscoveryController(
        ref.watch(publicPropertySearchRepositoryProvider),
      )..load(),
    );

class PublicDiscoveryController extends StateNotifier<PublicDiscoveryState> {
  PublicDiscoveryController(this._repository)
    : super(const PublicDiscoveryState(status: PublicDiscoveryStatus.loading));

  final PublicPropertySearchRepository _repository;
  int _requestGeneration = 0;

  Future<void> load([PublicPropertySearchFilters? filters]) async {
    final currentFilters = filters ?? state.filters;
    final generation = ++_requestGeneration;
    state = PublicDiscoveryState(
      status: PublicDiscoveryStatus.loading,
      properties: state.properties,
      catalogProperties: state.catalogProperties,
      filters: currentFilters,
    );
    try {
      final properties = await _repository.search(currentFilters);
      if (generation != _requestGeneration) return;
      final catalog = state.catalogProperties.isNotEmpty
          ? state.catalogProperties
          : properties;
      state = PublicDiscoveryState(
        status: properties.isEmpty
            ? PublicDiscoveryStatus.empty
            : PublicDiscoveryStatus.results,
        properties: properties,
        catalogProperties: catalog,
        filters: currentFilters,
      );
    } on PublicSearchException catch (error) {
      if (generation != _requestGeneration) return;
      state = PublicDiscoveryState(
        status: _statusFor(error.kind),
        catalogProperties: state.catalogProperties,
        filters: currentFilters,
      );
    } catch (_) {
      if (generation != _requestGeneration) return;
      state = PublicDiscoveryState(
        status: PublicDiscoveryStatus.invalidResponse,
        catalogProperties: state.catalogProperties,
        filters: currentFilters,
      );
    }
  }

  static PublicDiscoveryStatus _statusFor(PublicSearchFailureKind kind) =>
      switch (kind) {
        PublicSearchFailureKind.configuration =>
          PublicDiscoveryStatus.configurationError,
        PublicSearchFailureKind.network => PublicDiscoveryStatus.networkError,
        PublicSearchFailureKind.timeout => PublicDiscoveryStatus.timeout,
        PublicSearchFailureKind.server => PublicDiscoveryStatus.serverError,
        PublicSearchFailureKind.unauthorized =>
          PublicDiscoveryStatus.unauthorized,
        PublicSearchFailureKind.requestRejected =>
          PublicDiscoveryStatus.requestRejected,
        PublicSearchFailureKind.invalidResponse =>
          PublicDiscoveryStatus.invalidResponse,
        PublicSearchFailureKind.invalidFilters =>
          PublicDiscoveryStatus.invalidFilters,
      };
}
