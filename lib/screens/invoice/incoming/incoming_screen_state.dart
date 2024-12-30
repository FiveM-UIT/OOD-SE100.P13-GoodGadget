import 'package:equatable/equatable.dart';
import 'package:gizmoglobe_client/objects/invoice_related/incoming_invoice.dart';

class IncomingScreenState extends Equatable {
  final bool isLoading;
  final List<IncomingInvoice> invoices;
  final String searchQuery;
  final int? selectedIndex;

  const IncomingScreenState({
    this.isLoading = false,
    this.invoices = const [],
    this.searchQuery = '',
    this.selectedIndex,
  });

  IncomingScreenState copyWith({
    bool? isLoading,
    List<IncomingInvoice>? invoices,
    String? searchQuery,
    int? selectedIndex,
  }) {
    return IncomingScreenState(
      isLoading: isLoading ?? this.isLoading,
      invoices: invoices ?? this.invoices,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedIndex: selectedIndex,
    );
  }

  @override
  List<Object?> get props => [invoices, isLoading, searchQuery, selectedIndex];
}
