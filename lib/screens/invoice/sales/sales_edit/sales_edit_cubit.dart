import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gizmoglobe_client/data/firebase/firebase.dart';
import 'package:gizmoglobe_client/objects/invoice_related/sales_invoice.dart';
import 'package:gizmoglobe_client/enums/invoice_related/payment_status.dart';
import 'package:gizmoglobe_client/enums/invoice_related/sales_status.dart';
import '../../../../objects/invoice_related/sales_invoice_detail.dart';
import 'sales_edit_state.dart';

class SalesEditCubit extends Cubit<SalesEditState> {
  final Firebase _firebase = Firebase();

  SalesEditCubit(SalesInvoice invoice)
      : super(SalesEditState(
          invoice: invoice,
          selectedPaymentStatus: invoice.paymentStatus,
          selectedSalesStatus: invoice.salesStatus,
        ));

  void updatePaymentStatus(PaymentStatus status) {
    if (state.selectedPaymentStatus == PaymentStatus.paid) return;
    
    emit(state.copyWith(selectedPaymentStatus: status));
  }

  void updateSalesStatus(SalesStatus status) {
    emit(state.copyWith(selectedSalesStatus: status));
  }

  Future<SalesInvoice?> saveChanges() async {
    emit(state.copyWith(isLoading: true));
    try {
      final updatedInvoice = state.invoice.copyWith(
        paymentStatus: state.selectedPaymentStatus,
        salesStatus: state.selectedSalesStatus,
      );
      
      await _firebase.updateSalesInvoice(updatedInvoice);
      
      emit(state.copyWith(
        invoice: updatedInvoice,
        isLoading: false,
      ));
      return updatedInvoice;
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
      ));
      return null;
    }
  }
} 