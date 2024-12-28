import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gizmoglobe_client/data/firebase/firebase.dart';
import 'package:gizmoglobe_client/objects/invoice_related/incoming_invoice.dart';
import 'incoming_detail_state.dart';

class IncomingDetailCubit extends Cubit<IncomingDetailState> {
  final Firebase _firebase = Firebase();

  IncomingDetailCubit(IncomingInvoice invoice)
      : super(IncomingDetailState(invoice: invoice)) {
    _loadInvoiceDetails();
  }

  Future<void> _loadInvoiceDetails() async {
    emit(state.copyWith(isLoading: true));
    try {
      final updatedInvoice = await _firebase.getIncomingInvoiceWithDetails(
          state.invoice.incomingInvoiceID!
      );
      emit(state.copyWith(
        invoice: updatedInvoice,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }


  Future<void> updateIncomingInvoice(IncomingInvoice updatedInvoice) async {
    emit(state.copyWith(isLoading: true));
    try {
      await _firebase.updateIncomingInvoice(updatedInvoice);
      emit(state.copyWith(
        invoice: updatedInvoice,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
    }
  }


}