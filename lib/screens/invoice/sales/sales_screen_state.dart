class SalesScreenState {
  final bool isLoading;
  final List<SalesInvoice> invoices;
  final int? selectedIndex;

  const SalesScreenState({
    this.isLoading = false,
    this.invoices = const [],
    this.selectedIndex,
  });

  SalesScreenState copyWith({
    bool? isLoading,
    List<SalesInvoice>? invoices,
    int? selectedIndex,
  }) {
    return SalesScreenState(
      isLoading: isLoading ?? this.isLoading,
      invoices: invoices ?? this.invoices,
      selectedIndex: selectedIndex,
    );
  }
}

class SalesInvoice {
  final String id;
  final String date;
  // Add other properties as needed

  const SalesInvoice({
    required this.id,
    required this.date,
  });
}
