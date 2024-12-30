import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gizmoglobe_client/data/firebase/firebase.dart';
import 'package:gizmoglobe_client/objects/invoice_related/incoming_invoice.dart';
import 'incoming_screen_state.dart';

class IncomingScreenCubit extends Cubit<IncomingScreenState> {
  final _firebase = Firebase();
  late final Stream<List<IncomingInvoice>> _invoicesStream;
  StreamSubscription<List<IncomingInvoice>>? _subscription;

  IncomingScreenCubit() : super(const IncomingScreenState()) {
    _invoicesStream = _firebase.incomingInvoicesStream();
    _listenToInvoices();
    loadInvoices();
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
      final invoices = await _firebase.getIncomingInvoices();
      emit(state.copyWith(
        invoices: invoices,
        isLoading: false,
      ));
    } catch (e) {
      print('Error loading incoming invoices: $e');
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
      return invoice.manufacturerID.toLowerCase().contains(query.toLowerCase());
    }).toList();

    emit(state.copyWith(invoices: filteredInvoices));
  }

  void setSelectedIndex(int? index) {
    emit(state.copyWith(selectedIndex: index));
  }

  Future<void> updateIncomingInvoice(IncomingInvoice invoice) async {
    try {
      await _firebase.updateIncomingInvoice(invoice);
    } catch (e) {
      print('Error updating incoming invoice: $e');
    }
  }

  Future<String?> createIncomingInvoice(IncomingInvoice invoice) async {
    try {
      final invoiceId = await _firebase.createIncomingInvoice(invoice);
      return invoiceId;
    } catch (e) {
      print('Error creating incoming invoice: $e');
      return null;
    }
  }

  Future<void> deleteIncomingInvoice(String invoiceId) async {
    try {
      await _firebase.deleteIncomingInvoice(invoiceId);
    } catch (e) {
      print('Error deleting incoming invoice: $e');
    }
  }

  Future<IncomingInvoice?> getInvoiceWithDetails(String invoiceId) async {
    try {
      return await _firebase.getIncomingInvoiceWithDetails(invoiceId);
    } catch (e) {
      print('Error getting invoice details: $e');
      return null;
    }
  }
}
