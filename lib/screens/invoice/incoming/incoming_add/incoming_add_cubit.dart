import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gizmoglobe_client/data/firebase/firebase.dart';
import 'package:gizmoglobe_client/enums/invoice_related/payment_status.dart';
import 'package:gizmoglobe_client/objects/invoice_related/incoming_invoice.dart';
import 'package:gizmoglobe_client/objects/invoice_related/incoming_invoice_detail.dart';
import 'package:gizmoglobe_client/objects/manufacturer.dart';
import 'package:gizmoglobe_client/objects/product_related/product.dart';
import 'incoming_add_state.dart';

class IncomingAddCubit extends Cubit<IncomingAddState> {
  final _firebase = Firebase();

  IncomingAddCubit() : super(const IncomingAddState()) {
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    emit(state.copyWith(isLoading: true));
    try {
      final manufacturers = await _firebase.getManufacturers();
      emit(state.copyWith(
        manufacturers: manufacturers,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Error loading manufacturers: $e',
        isLoading: false,
      ));
    }
  }

  Future<void> selectManufacturer(Manufacturer manufacturer) async {
    emit(state.copyWith(
      isLoading: true,
      selectedManufacturer: manufacturer,
      details: [], // Reset details when manufacturer changes
    ));

    try {
      // Load products for selected manufacturer
      final allProducts = await _firebase.getProducts();
      final manufacturerProducts = allProducts
          .where((product) => product.manufacturer.manufacturerID == manufacturer.manufacturerID)
          .toList();

      emit(state.copyWith(
        products: manufacturerProducts,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Error loading products: $e',
        isLoading: false,
      ));
    }
  }

  void addDetail(Product product, double importPrice, int quantity) {
    if (importPrice <= 0) {
      emit(state.copyWith(errorMessage: 'Import price must be greater than 0'));
      return;
    }

    if (quantity <= 0) {
      emit(state.copyWith(errorMessage: 'Quantity must be greater than 0'));
      return;
    }

    final detail = IncomingInvoiceDetail(
      incomingInvoiceID: '',
      productID: product.productID!,
      importPrice: importPrice,
      quantity: quantity,
      subtotal: importPrice * quantity,
    );

    final updatedDetails = List<IncomingInvoiceDetail>.from(state.details)
      ..add(detail);

    emit(state.copyWith(
      details: updatedDetails,
      errorMessage: null,
    ));
  }

  void removeDetail(int index) {
    final updatedDetails = List<IncomingInvoiceDetail>.from(state.details)
      ..removeAt(index);

    emit(state.copyWith(details: updatedDetails));
  }

  void updateDetailQuantity(int index, int newQuantity) {
    if (newQuantity <= 0) {
      emit(state.copyWith(errorMessage: 'Quantity must be greater than 0'));
      return;
    }

    final detail = state.details[index];
    final updatedDetail = IncomingInvoiceDetail(
      incomingInvoiceID: detail.incomingInvoiceID,
      productID: detail.productID,
      importPrice: detail.importPrice,
      quantity: newQuantity,
      subtotal: detail.importPrice * newQuantity,
    );

    final updatedDetails = List<IncomingInvoiceDetail>.from(state.details)
      ..[index] = updatedDetail;

    emit(state.copyWith(
      details: updatedDetails,
      errorMessage: null,
    ));
  }

  Future<bool> submitInvoice() async {
    if (state.selectedManufacturer == null) {
      emit(state.copyWith(errorMessage: 'Please select a manufacturer'));
      return false;
    }

    if (state.details.isEmpty) {
      emit(state.copyWith(errorMessage: 'Please add at least one product'));
      return false;
    }

    emit(state.copyWith(isSubmitting: true));

    try {
      final invoice = IncomingInvoice(
        manufacturerID: state.selectedManufacturer!.manufacturerID,
        date: DateTime.now(),
        status: PaymentStatus.unpaid,
        totalPrice: state.totalPrice,
        details: state.details,
      );

      await _firebase.createIncomingInvoice(invoice);

      // Update product stock
      for (var detail in state.details) {
        await _firebase.updateProductStock(detail.productID, detail.quantity);
      }

      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: null,
      ));

      return true;
    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: 'Error creating invoice: $e',
      ));
      return false;
    }
  }

  void clearError() {
    emit(state.copyWith(errorMessage: null));
  }
} 