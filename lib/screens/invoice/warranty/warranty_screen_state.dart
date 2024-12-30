import 'package:equatable/equatable.dart';
import 'package:gizmoglobe_client/objects/invoice_related/warranty_invoice.dart';

class WarrantyScreenState extends Equatable {
  final List<WarrantyInvoice> invoices;
  final bool isLoading;
  final String searchQuery;
  final int? selectedIndex;
  final String? userRole;

  const WarrantyScreenState({
    this.invoices = const [],
    this.isLoading = false,
    this.searchQuery = '',
    this.selectedIndex,
    this.userRole,
  });

  WarrantyScreenState copyWith({
    List<WarrantyInvoice>? invoices,
    bool? isLoading,
    String? searchQuery,
    int? selectedIndex,
    String? userRole,
  }) {
    return WarrantyScreenState(
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
