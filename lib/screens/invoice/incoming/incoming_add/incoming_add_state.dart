class IncomingAddState {
  final bool isLoading;
  final List<Manufacturer> manufacturers;
  final String? selectedManufacturerId;
  final List<IncomingInvoiceDetail> details;
  final bool isSaving;

  const IncomingAddState({
    this.isLoading = false,
    this.manufacturers = const [],
    this.selectedManufacturerId,
    this.details = const [],
    this.isSaving = false,
  });

  double get totalPrice => details.fold(
    0, 
    (sum, detail) => sum + detail.subtotal,
  );

  IncomingAddState copyWith({
    bool? isLoading,
    List<Manufacturer>? manufacturers,
    String? selectedManufacturerId,
    List<IncomingInvoiceDetail>? details,
    bool? isSaving,
  }) {
    return IncomingAddState(
      isLoading: isLoading ?? this.isLoading,
      manufacturers: manufacturers ?? this.manufacturers,
      selectedManufacturerId: selectedManufacturerId ?? this.selectedManufacturerId,
      details: details ?? this.details,
      isSaving: isSaving ?? this.isSaving,
    );
  }
} 