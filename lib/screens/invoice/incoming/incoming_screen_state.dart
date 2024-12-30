import 'package:gizmoglobe_client/objects/invoice_related/incoming_invoice.dart';

class IncomingScreenState {
  final bool isLoading;
  final List<IncomingInvoice> invoices;
  final int? selectedIndex;
  final String searchQuery;

  const IncomingScreenState({
    this.isLoading = false,
    this.invoices = const [],
    this.selectedIndex,
    this.searchQuery = '',
  });

  IncomingScreenState copyWith({
    bool? isLoading,
    List<IncomingInvoice>? invoices,
    int? selectedIndex,
    String? searchQuery,
  }) {
    return IncomingScreenState(
      isLoading: isLoading ?? this.isLoading,
      invoices: invoices ?? this.invoices,
      selectedIndex: selectedIndex,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class IncomingInvoice {
  final String id;
  final String date;
  // Add other properties as needed

  const IncomingInvoice({
    required this.id,
    required this.date,
  });
}
