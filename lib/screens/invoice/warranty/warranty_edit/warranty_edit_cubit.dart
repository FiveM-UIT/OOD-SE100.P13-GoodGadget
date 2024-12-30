import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gizmoglobe_client/data/firebase/firebase.dart';
import 'package:gizmoglobe_client/enums/invoice_related/warranty_status.dart';
import 'package:gizmoglobe_client/objects/invoice_related/warranty_invoice.dart';
import 'warranty_edit_state.dart';

class WarrantyEditCubit extends Cubit<WarrantyEditState> {
  final _firebase = Firebase();

  WarrantyEditCubit(WarrantyInvoice invoice)
      : super(WarrantyEditState(
          invoice: invoice,
          selectedStatus: invoice.status,
        ));

  void updateStatus(WarrantyStatus newStatus) {
    emit(state.copyWith(selectedStatus: newStatus));
  }

  Future<bool> saveChanges() async {
    if (state.selectedStatus == state.invoice.status) {
      return true; // No changes needed
    }

    emit(state.copyWith(isLoading: true));

    try {
      final updatedInvoice = WarrantyInvoice(
        warrantyInvoiceID: state.invoice.warrantyInvoiceID,
        salesInvoiceID: state.invoice.salesInvoiceID,
        customerName: state.invoice.customerName,
        customerID: state.invoice.customerID,
        date: state.invoice.date,
        status: state.selectedStatus,
        details: state.invoice.details,
        reason: state.invoice.reason,
      );

      await _firebase.updateWarrantyInvoice(updatedInvoice);
      emit(state.copyWith(
        invoice: updatedInvoice,
        isLoading: false,
      ));
      return true;
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Error updating warranty: $e',
        isLoading: false,
      ));
      return false;
    }
  }
} 