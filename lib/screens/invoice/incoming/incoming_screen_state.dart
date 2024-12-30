import 'package:equatable/equatable.dart';
import 'package:gizmoglobe_client/objects/invoice_related/incoming_invoice.dart';

class IncomingScreenState extends Equatable {
  final List<IncomingInvoice> invoices;
  final bool isLoading;
  final String searchQuery;
  final int? selectedIndex;
  final String? userRole;

  const IncomingScreenState({
    this.invoices = const [],
    this.isLoading = false,
    this.searchQuery = '',
    this.selectedIndex,
    this.userRole,
  });

  IncomingScreenState copyWith({
    List<IncomingInvoice>? invoices,
    bool? isLoading,
    String? searchQuery,
    int? selectedIndex,
    String? userRole,
  }) {
    return IncomingScreenState(
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
