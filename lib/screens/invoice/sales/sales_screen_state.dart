import 'package:equatable/equatable.dart';
import 'package:gizmoglobe_client/objects/invoice_related/sales_invoice.dart';

enum SortField {
  date,
  totalPrice,
}

enum SortOrder {
  ascending,
  descending,
}

class SalesScreenState extends Equatable {
  final List<SalesInvoice> invoices;
  final bool isLoading;
  final String searchQuery;
  final int? selectedIndex;
  final String? userRole;
  final SortField? sortField;
  final SortOrder sortOrder;

  const SalesScreenState({
    this.invoices = const [],
    this.isLoading = false,
    this.searchQuery = '',
    this.selectedIndex,
    this.userRole,
    this.sortField,
    this.sortOrder = SortOrder.descending,
  });

  SalesScreenState copyWith({
    List<SalesInvoice>? invoices,
    bool? isLoading,
    String? searchQuery,
    int? selectedIndex,
    String? userRole,
    SortField? sortField,
    SortOrder? sortOrder,
  }) {
    return SalesScreenState(
      invoices: invoices ?? this.invoices,
      isLoading: isLoading ?? this.isLoading,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedIndex: selectedIndex,
      userRole: userRole ?? this.userRole,
      sortField: sortField ?? this.sortField,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  List<Object?> get props => [
    invoices, 
    isLoading, 
    searchQuery, 
    selectedIndex, 
    userRole,
    sortField,
    sortOrder,
  ];
}
