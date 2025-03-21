import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gizmoglobe_client/data/firebase/firebase.dart';
import 'package:gizmoglobe_client/objects/invoice_related/sales_invoice.dart';
import 'sales_screen_state.dart';

class SalesScreenCubit extends Cubit<SalesScreenState> {
  final _firebase = Firebase();
  late final Stream<List<SalesInvoice>> _invoicesStream;
  StreamSubscription<List<SalesInvoice>>? _subscription;

  SalesScreenCubit() : super(const SalesScreenState()) {
    _invoicesStream = _firebase.salesInvoicesStream();
    _listenToInvoices();
    loadInvoices();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    try {
      final userRole = await _firebase.getUserRole();
      emit(state.copyWith(userRole: userRole));
    } catch (e) {
      print('Error loading user role: $e');
    }
  }

  void _listenToInvoices() {
    _subscription = _invoicesStream.listen((invoices) {
      if (state.searchQuery.isEmpty) {
        emit(state.copyWith(invoices: invoices));
      } else {
        searchInvoices(state.searchQuery);
      }
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  Future<void> loadInvoices() async {
    emit(state.copyWith(isLoading: true));
    try {
      final invoices = await _firebase.getSalesInvoices();
      emit(state.copyWith(
        invoices: invoices,
        isLoading: false,
      ));
    } catch (e) {
      print('Error loading sales invoices: $e');
      emit(state.copyWith(isLoading: false));
    }
  }

  void searchInvoices(String query) {
    emit(state.copyWith(searchQuery: query));
    
    if (query.isEmpty) {
      loadInvoices();
      return;
    }

    final filteredInvoices = state.invoices.where((invoice) {
      return invoice.customerID.toLowerCase().contains(query.toLowerCase()) ||
             invoice.address.toLowerCase().contains(query.toLowerCase());
    }).toList();

    emit(state.copyWith(invoices: filteredInvoices));
  }

  void setSelectedIndex(int? index) {
    emit(state.copyWith(selectedIndex: index));
  }

  Future<void> updateSalesInvoice(SalesInvoice invoice) async {
    try {
      await _firebase.updateSalesInvoice(invoice);
    } catch (e) {
      print('Error updating sales invoice: $e');
    }
  }

  Future<String?> createSalesInvoice(SalesInvoice invoice) async {
    try {
      await _firebase.createSalesInvoice(invoice);
      return null;
    } catch (e) {
      print('Error creating sales invoice: $e');
      return e.toString();
    }
  }

  void sortInvoices(SortField field, [SortOrder? order]) {
    final currentOrder = order ?? 
      (state.sortField == field ? 
        (state.sortOrder == SortOrder.ascending ? SortOrder.descending : SortOrder.ascending)
        : SortOrder.descending);

    final sortedInvoices = List<SalesInvoice>.from(state.invoices);

    switch (field) {
      case SortField.date:
        sortedInvoices.sort((a, b) => currentOrder == SortOrder.ascending
            ? a.date.compareTo(b.date)
            : b.date.compareTo(a.date));
        break;
      case SortField.totalPrice:
        sortedInvoices.sort((a, b) => currentOrder == SortOrder.ascending
            ? a.totalPrice.compareTo(b.totalPrice)
            : b.totalPrice.compareTo(a.totalPrice));
        break;
    }

    emit(state.copyWith(
      invoices: sortedInvoices,
      sortField: field,
      sortOrder: currentOrder,
    ));
  }
}
