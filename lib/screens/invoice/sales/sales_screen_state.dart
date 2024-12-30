import 'package:equatable/equatable.dart';
import 'package:gizmoglobe_client/objects/invoice_related/sales_invoice.dart';

class SalesScreenState extends Equatable {
  final List<SalesInvoice> invoices;
  final bool isLoading;
  final String searchQuery;
  final int? selectedIndex;
  final String? userRole;

  const SalesScreenState({
    this.invoices = const [],
    this.isLoading = false,
    this.searchQuery = '',
    this.selectedIndex,
    this.userRole,
  });

  SalesScreenState copyWith({
    List<SalesInvoice>? invoices,
    bool? isLoading,
    String? searchQuery,
    int? selectedIndex,
    String? userRole,
  }) {
    return SalesScreenState(
      invoices: invoices ?? this.invoices,
      isLoading: isLoading ?? this.isLoading,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedIndex: selectedIndex,
      userRole: userRole ?? this.userRole,
    );
  }

  @override
  List<Object?> get props => [invoices, isLoading, searchQuery, selectedIndex, userRole];
}
