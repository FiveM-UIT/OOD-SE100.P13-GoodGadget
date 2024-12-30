import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:your_app_name/models/manufacturer.dart';
import 'package:your_app_name/models/incoming_invoice.dart';
import 'package:your_app_name/models/incoming_invoice_detail.dart';
import 'package:your_app_name/services/firebase.dart';
import 'incoming_add_state.dart';

class IncomingAddCubit extends Cubit<IncomingAddState> {
  IncomingAddCubit() : super(const IncomingAddState()) {
    loadManufacturers();
  }

  Future<void> loadManufacturers() async {
    emit(state.copyWith(isLoading: true));
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('manufacturers')
          .get();

      final manufacturers = snapshot.docs.map((doc) {
        return Manufacturer(
          manufacturerID: doc.id,
          manufacturerName: doc['manufacturerName'],
        );
      }).toList();

      emit(state.copyWith(
        isLoading: false,
        manufacturers: manufacturers,
      ));
    } catch (e) {
      print('Error loading manufacturers: $e');
      emit(state.copyWith(isLoading: false));
    }
  }

  void selectManufacturer(String manufacturerId) {
    emit(state.copyWith(selectedManufacturerId: manufacturerId));
  }

  void addDetail(IncomingInvoiceDetail detail) {
    final details = List<IncomingInvoiceDetail>.from(state.details)..add(detail);
    emit(state.copyWith(details: details));
  }

  void removeDetail(int index) {
    final details = List<IncomingInvoiceDetail>.from(state.details)..removeAt(index);
    emit(state.copyWith(details: details));
  }

  Future<void> saveInvoice() async {
    if (state.selectedManufacturerId == null) {
      throw Exception('Vui lòng chọn nhà cung cấp');
    }
    if (state.details.isEmpty) {
      throw Exception('Vui lòng thêm ít nhất một sản phẩm');
    }

    emit(state.copyWith(isSaving: true));
    try {
      final invoice = IncomingInvoice(
        manufacturerID: state.selectedManufacturerId!,
        date: DateTime.now(),
        status: PaymentStatus.unpaid,
        totalPrice: state.totalPrice,
        details: state.details,
      );

      await Firebase().createIncomingInvoice(invoice);
      emit(state.copyWith(isSaving: false));
    } catch (e) {
      emit(state.copyWith(isSaving: false));
      rethrow;
    }
  }
}