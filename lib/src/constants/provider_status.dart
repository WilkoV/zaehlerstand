enum ProviderStatus {
  loading,
  syncing,
  idle,
}

extension ProviderStatusExtension on ProviderStatus {
  bool get isLoading => this == ProviderStatus.loading;
  bool get isSyncing => this == ProviderStatus.syncing;
  bool get isIdle => this == ProviderStatus.idle;
}
