import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gizmoglobe_client/data/firebase/firebase.dart';
import 'package:gizmoglobe_client/objects/invoice_related/sales_invoice.dart';
import 'package:gizmoglobe_client/enums/invoice_related/payment_status.dart';
import 'package:gizmoglobe_client/enums/invoice_related/sales_status.dart';
import '../../../../objects/invoice_related/sales_invoice_detail.dart';
import '../permissions/sales_invoice_permissions.dart';
import 'sales_edit_state.dart';

class SalesEditCubit extends Cubit<SalesEditState> {
  final Firebase _firebase = Firebase();

  SalesEditCubit(SalesInvoice invoice)
      : super(SalesEditState(
          invoice: invoice,
          selectedPaymentStatus: invoice.paymentStatus,
          selectedSalesStatus: invoice.salesStatus,
        )) {
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    final userRole = await _firebase.getUserRole();
    emit(state.copyWith(userRole: userRole));
  }

  void updatePaymentStatus(PaymentStatus status) {
    if (!SalesInvoicePermissions.canEditPaymentStatus(state.userRole, state.invoice)) return;
    emit(state.copyWith(selectedPaymentStatus: status));
  }

  void updateSalesStatus(SalesStatus status) {
    if (!SalesInvoicePermissions.canEditSalesStatus(state.userRole, state.invoice)) return;
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