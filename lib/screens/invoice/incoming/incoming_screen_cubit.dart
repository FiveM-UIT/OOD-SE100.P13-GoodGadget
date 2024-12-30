import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gizmoglobe_client/objects/invoice_related/incoming_invoice.dart';
import 'incoming_screen_state.dart';

class IncomingScreenCubit extends Cubit<IncomingScreenState> {
  IncomingScreenCubit() : super(const IncomingScreenState()) {
    loadInvoices();
  }

  Future<void> loadInvoices() async {
    emit(state.copyWith(isLoading: true));
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('incoming_invoices')
          .orderBy('date', descending: true)
          .get();

      final invoices = snapshot.docs.map((doc) {
        return IncomingInvoice.fromMap(doc.id, doc.data());
      }).toList();

      emit(state.copyWith(
        isLoading: false,
        invoices: invoices,
      ));
    } catch (e) {
      print('Error loading invoices: $e');
      emit(state.copyWith(isLoading: false));
    }
  }

  void searchInvoices(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  void setSelectedIndex(int? index) {
    emit(state.copyWith(selectedIndex: index));
  }
}
