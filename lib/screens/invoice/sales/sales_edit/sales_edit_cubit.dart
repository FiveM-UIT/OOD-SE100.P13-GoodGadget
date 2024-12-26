import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gizmoglobe_client/data/firebase/firebase.dart';
import 'package:gizmoglobe_client/objects/invoice_related/sales_invoice.dart';
import 'package:gizmoglobe_client/enums/invoice_related/payment_status.dart';
import 'package:gizmoglobe_client/enums/invoice_related/sales_status.dart';
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
    emit(state.copyWith(selectedPaymentStatus: status));
  }

  void updateSalesStatus(SalesStatus status) {
    emit(state.copyWith(selectedSalesStatus: status));
  }

  Future<SalesInvoice?> saveChanges() async {
    emit(state.copyWith(isLoading: true));
    try {
      final updatedInvoice = state.invoice;
      await _firebase.updateSalesInvoice(updatedInvoice);
      
      // Cập nhật chi tiết hóa đơn
      for (var detail in updatedInvoice.details) {
        await _firebase.updateSalesInvoiceDetail(detail);
      }
      
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