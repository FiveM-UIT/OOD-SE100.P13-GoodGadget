import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gizmoglobe_client/data/firebase/firebase.dart';
import 'package:gizmoglobe_client/objects/invoice_related/incoming_invoice.dart';
import 'package:gizmoglobe_client/objects/manufacturer.dart';
import 'package:gizmoglobe_client/objects/product_related/product.dart';
import '../../../../enums/invoice_related/payment_status.dart';
import 'incoming_detail_state.dart';

class IncomingDetailCubit extends Cubit<IncomingDetailState> {
  final _firebase = Firebase();
  final IncomingInvoice invoice;

  IncomingDetailCubit(this.invoice) : super(IncomingDetailState(invoice: invoice)) {
    loadDetails();
  }

  Future<void> loadDetails() async {
    emit(state.copyWith(isLoading: true));

    try {
      // Load manufacturer
      final manufacturer = await _firebase.getManufacturerById(invoice.manufacturerID);
      
      // Load all products referenced in details
      final Map<String, Product> products = {};
      final allProducts = await _firebase.getProducts();
      
      for (var detail in invoice.details) {
        final product = allProducts.firstWhere(
          (p) => p.productID == detail.productID,
          orElse: () => throw Exception('Product not found: ${detail.productID}'),
        );
        products[detail.productID] = product;
      }

      emit(state.copyWith(
        manufacturer: manufacturer,
        products: products,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Error loading details: $e',
        isLoading: false,
      ));
    }
  }

  void clearError() {
    emit(state.copyWith(errorMessage: null));
  }

  Future<void> updatePaymentStatus(PaymentStatus newStatus) async {
    try {
      final updatedInvoice = IncomingInvoice(
        incomingInvoiceID: invoice.incomingInvoiceID,
        manufacturerID: invoice.manufacturerID,
        date: invoice.date,
        status: newStatus,
        totalPrice: invoice.totalPrice,
        details: invoice.details,
      );

      await _firebase.updateIncomingInvoice(updatedInvoice);
      emit(state.copyWith(invoice: updatedInvoice));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Error updating payment status: $e'));
    }
  }
}
