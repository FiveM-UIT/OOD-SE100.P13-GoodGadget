import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gizmoglobe_client/data/firebase/firebase.dart';
import 'package:gizmoglobe_client/objects/invoice_related/warranty_invoice.dart';
import 'package:gizmoglobe_client/objects/invoice_related/warranty_invoice_detail.dart';
import '../../../../enums/invoice_related/warranty_status.dart';
import 'warranty_add_state.dart';

class WarrantyAddCubit extends Cubit<WarrantyAddState> {
  final _firebase = Firebase();

  WarrantyAddCubit() : super(const WarrantyAddState()) {
    _loadCustomers();
  }

  Future<void> _loadCustomers() async {
    emit(state.copyWith(isLoading: true));
    try {
      final customers = await _firebase.getCustomers();
      emit(state.copyWith(
        availableCustomers: customers,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Error loading customers: $e',
        isLoading: false,
      ));
    }
  }

  Future<void> selectCustomer(String customerId) async {
    emit(state.copyWith(
      selectedCustomerId: customerId,
      selectedSalesInvoiceId: null,
      salesInvoice: null,
      details: [],
      customerInvoices: [],
    ));
    await _loadCustomerInvoices(customerId);
  }

  Future<void> _loadCustomerInvoices(String customerId) async {
    emit(state.copyWith(isLoading: true));
    try {
      final invoices = await _firebase.getCustomerSalesInvoices(customerId);
      emit(state.copyWith(
        customerInvoices: invoices,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Error loading customer invoices: $e',
        isLoading: false,
      ));
    }
  }

  Future<void> selectSalesInvoice(String invoiceId) async {
    emit(state.copyWith(isLoading: true));
    try {
      final invoice = await _firebase.getSalesInvoiceWithDetails(invoiceId);
      emit(state.copyWith(
        selectedSalesInvoiceId: invoiceId,
        salesInvoice: invoice,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        errorMessage: 'Error loading sales invoice details: $e',
        isLoading: false,
      ));
    }
  }

  void updateReason(String reason) {
    emit(state.copyWith(reason: reason));
  }

  void selectProduct(String productId) {
    print('Selecting product: $productId');
    try {
      final newSelected = Set<String>.from(state.selectedProducts)..add(productId);
      final newQuantities = Map<String, int>.from(state.productQuantities)
        ..putIfAbsent(productId, () => 1);
      print('New selected products: $newSelected');
      print('New quantities: $newQuantities');
      emit(state.copyWith(
        selectedProducts: newSelected,
        productQuantities: newQuantities,
      ));
    } catch (e) {
      print('Error selecting product: $e');
    }
  }

  void deselectProduct(String productId) {
    print('Deselecting product: $productId');
    try {
      final newSelected = Set<String>.from(state.selectedProducts)..remove(productId);
      final newQuantities = Map<String, int>.from(state.productQuantities)
        ..remove(productId);
      print('New selected products: $newSelected');
      print('New quantities: $newQuantities');
      emit(state.copyWith(
        selectedProducts: newSelected,
        productQuantities: newQuantities,
      ));
    } catch (e) {
      print('Error deselecting product: $e');
    }
  }

  void updateDetailQuantity(String productId, int quantity) {
    print('Updating quantity for product $productId to $quantity');
    try {
      if (!state.selectedProducts.contains(productId)) {
        print('Product $productId not in selected products');
        return;
      }
      
      final detail = state.salesInvoice?.details
          .firstWhere((d) => d.productID == productId);
      if (detail == null) {
        print('Product detail not found for $productId');
        return;
      }

      print('Available quantity: ${detail.quantity}');
      final validQuantity = quantity.clamp(0, detail.quantity);
      print('Clamped quantity: $validQuantity');
      
      final newQuantities = Map<String, int>.from(state.productQuantities)
        ..[productId] = validQuantity;
      
      print('New quantities map: $newQuantities');
      emit(state.copyWith(productQuantities: newQuantities));
    } catch (e) {
      print('Error updating quantity: $e');
    }
  }

  Future<WarrantyInvoice?> submit() async {
    print('Starting warranty invoice submission');
    print('Selected products: ${state.selectedProducts}');
    print('Product quantities: ${state.productQuantities}');
    
    try {
      // Validate required fields
      if (state.selectedCustomerId == null) {
        print('Error: No customer selected');
        emit(state.copyWith(errorMessage: 'Please select a customer'));
        return null;
      }

      if (state.selectedSalesInvoiceId == null) {
        print('Error: No sales invoice selected');
        emit(state.copyWith(errorMessage: 'Please select a sales invoice'));
        return null;
      }

      // Create warranty details
      final details = <WarrantyInvoiceDetail>[];
      
      // Check if salesInvoice is not null
      if (state.salesInvoice == null) {
        print('Error: Sales invoice details not loaded');
        emit(state.copyWith(errorMessage: 'Sales invoice details not loaded'));
        return null;
      }

      // Build details list from selected products
      for (var salesDetail in state.salesInvoice!.details) {
        if (state.selectedProducts.contains(salesDetail.productID)) {
          final quantity = state.productQuantities[salesDetail.productID] ?? 0;
          if (quantity > 0) {
            print('Adding warranty detail for product ${salesDetail.productID} with quantity $quantity');
            details.add(WarrantyInvoiceDetail(
              warrantyInvoiceDetailID: '',
              productID: salesDetail.productID,
              quantity: quantity,
              warrantyInvoiceID: '',
            ));
          }
        }
      }

      print('Created warranty details: ${details.length} items');
      if (details.isEmpty) {
        print('Error: No products selected or all quantities are 0');
        emit(state.copyWith(errorMessage: 'Please select at least one product'));
        return null;
      }

      final selectedCustomer = state.availableCustomers
          .firstWhere((c) => c.customerID == state.selectedCustomerId);

      final warrantyInvoice = WarrantyInvoice(
        warrantyInvoiceID: '',
        salesInvoiceID: state.selectedSalesInvoiceId!,
        customerName: selectedCustomer.customerName,
        customerID: selectedCustomer.customerID ?? '',
        date: DateTime.now(),
        status: WarrantyStatus.pending,
        details: details,
        reason: state.reason,
      );

      print('Created warranty invoice: ${warrantyInvoice.warrantyInvoiceID}');
      print('Details count: ${warrantyInvoice.details.length}');
      print('First detail: ${warrantyInvoice.details.firstOrNull?.toJson()}');

      final docId = await _firebase.createWarrantyInvoice(warrantyInvoice);
      print('Firebase document ID: $docId');

      if (docId == null || docId.isEmpty) {
        print('Error: Firebase returned null or empty document ID');
        emit(state.copyWith(
          errorMessage: 'Failed to create warranty invoice',
          isSuccess: false
        ));
        return null;
      }

      // Create final invoice with Firebase document ID
      final finalInvoice = WarrantyInvoice(
        warrantyInvoiceID: docId,
        salesInvoiceID: warrantyInvoice.salesInvoiceID,
        customerName: warrantyInvoice.customerName,
        customerID: warrantyInvoice.customerID,
        date: warrantyInvoice.date,
        status: warrantyInvoice.status,
        details: warrantyInvoice.details,
        reason: warrantyInvoice.reason,
      );

      print('Final warranty invoice created with ID: ${finalInvoice.warrantyInvoiceID}');
      print('Final details count: ${finalInvoice.details.length}');
      
      emit(state.copyWith(
        errorMessage: null,
        isSuccess: true
      ));
      
      return finalInvoice;

    } catch (e) {
      print('Error in submit: $e');
      emit(state.copyWith(
        errorMessage: e.toString(),
        isSuccess: false
      ));
      return null;
    }
  }
}