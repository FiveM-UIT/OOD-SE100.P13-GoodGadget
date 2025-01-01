import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gizmoglobe_client/data/firebase/firebase.dart';
import 'package:gizmoglobe_client/enums/invoice_related/payment_status.dart';
import 'package:gizmoglobe_client/enums/invoice_related/sales_status.dart';
import 'package:gizmoglobe_client/objects/invoice_related/sales_invoice.dart';
import 'package:gizmoglobe_client/objects/invoice_related/sales_invoice_detail.dart';
import 'package:gizmoglobe_client/objects/product_related/product.dart';
import '../../../../objects/customer.dart';
import 'sales_add_state.dart';

class SalesAddCubit extends Cubit<SalesAddState> {
  final _firebase = Firebase();

  SalesAddCubit() : super(SalesAddState()) {
    _loadCustomers();
    _loadProducts();
  }

  Future<void> _loadCustomers() async {
    try {
      final customers = await _firebase.getCustomers();
      emit(state.copyWith(
        customers: customers,
        selectedCustomer: state.selectedCustomer,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        selectedCustomer: state.selectedCustomer,
      ));
    }
  }

  Future<void> _loadProducts() async {
    try {
      final products = await _firebase.getProducts();
      emit(state.copyWith(
        products: products,
        selectedCustomer: state.selectedCustomer,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        selectedCustomer: state.selectedCustomer,
      ));
    }
  }

  void updateCustomer(Customer customer) {
    emit(state.copyWith(
      selectedCustomer: customer,
      address: '',
    ));
  }

  void updateAddress(String address) {
    emit(state.copyWith(
      address: address,
      selectedCustomer: state.selectedCustomer,
    ));
  }

  void updatePaymentStatus(PaymentStatus status) {
    emit(state.copyWith(
      paymentStatus: status,
      selectedCustomer: state.selectedCustomer,
    ));
  }

  void updateSalesStatus(SalesStatus status) {
    emit(state.copyWith(
      salesStatus: status,
      selectedCustomer: state.selectedCustomer,
    ));
  }

  void addInvoiceDetail(Product product, int quantity) {
    // Tìm xem sản phẩm đã tồn tại trong invoice chưa
    final existingDetailIndex = state.invoiceDetails.indexWhere(
      (detail) => detail.productID == product.productID
    );

    final List<SalesInvoiceDetail> details = List<SalesInvoiceDetail>.from(state.invoiceDetails);

    if (existingDetailIndex != -1) {
      // Nếu sản phẩm đã tồn tại
      final existingDetail = details[existingDetailIndex];
      final newQuantity = existingDetail.quantity + quantity;

      // Kiểm tra số lượng tồn kho
      if (newQuantity > product.stock) {
        emit(state.copyWith(
          error: 'Not enough stock',
          selectedCustomer: state.selectedCustomer,
          address: state.address,
        ));
        return;
      }

      // Cập nhật số lượng mới
      details[existingDetailIndex] = SalesInvoiceDetail.withQuantity(
        salesInvoiceDetailID: existingDetail.salesInvoiceDetailID,
        salesInvoiceID: existingDetail.salesInvoiceID,
        productID: existingDetail.productID,
        productName: existingDetail.productName,
        category: existingDetail.category,
        sellingPrice: existingDetail.sellingPrice,
        quantity: newQuantity,
      );
    } else {
      // Nếu là sản phẩm mới
      final detail = SalesInvoiceDetail.withQuantity(
        productID: product.productID!,
        productName: product.productName,
        category: product.category.getName(),
        sellingPrice: product.sellingPrice,
        quantity: quantity,
        salesInvoiceID: '',
      );
      details.add(detail);
    }

    emit(state.copyWith(
      invoiceDetails: details,
      selectedCustomer: state.selectedCustomer,
      address: state.address,
    ));
  }

  void updateDetailQuantity(int index, int quantity) {
    final details = List<SalesInvoiceDetail>.from(state.invoiceDetails);
    final detail = details[index];
    
    try {
      final product = state.products.firstWhere(
        (p) => p.productID == detail.productID,
      );
      
      if (quantity > product.stock) {
        emit(state.copyWith(
          error: 'Not enough stock',
          selectedCustomer: state.selectedCustomer,
          address: state.address,
        ));
        return;
      }

      details[index] = SalesInvoiceDetail.withQuantity(
        salesInvoiceDetailID: detail.salesInvoiceDetailID,
        salesInvoiceID: detail.salesInvoiceID,
        productID: detail.productID,
        productName: detail.productName,
        category: detail.category,
        sellingPrice: detail.sellingPrice,
        quantity: quantity,
      );

      emit(state.copyWith(
        invoiceDetails: details,
        selectedCustomer: state.selectedCustomer,
        address: state.address,
      ));
    } catch (e) {
      emit(state.copyWith(
        error: 'Product not found',
        selectedCustomer: state.selectedCustomer,
        address: state.address,
      ));
    }
  }

  void removeDetail(int index) {
    final details = List<SalesInvoiceDetail>.from(state.invoiceDetails)
      ..removeAt(index);
    emit(state.copyWith(
      invoiceDetails: details,
      selectedCustomer: state.selectedCustomer,
      address: state.address,
    ));
  }

  Future<SalesInvoice?> createInvoice() async {
    if (state.selectedCustomer == null) {
      emit(state.copyWith(
        error: 'Please select a customer',
        selectedCustomer: state.selectedCustomer,
      ));
      return null;
    }

    if (state.address.isEmpty) {
      emit(state.copyWith(
        error: 'Please enter delivery address',
        selectedCustomer: state.selectedCustomer,
      ));
      return null;
    }

    if (state.invoiceDetails.isEmpty) {
      emit(state.copyWith(
        error: 'Please add at least one product',
        selectedCustomer: state.selectedCustomer,
      ));
      return null;
    }

    emit(state.copyWith(
      isLoading: true,
      error: null,
      selectedCustomer: state.selectedCustomer,
    ));

    try {
      final invoice = SalesInvoice(
        customerID: state.selectedCustomer!.customerID!,
        customerName: state.selectedCustomer!.customerName,
        address: state.address,
        date: DateTime.now(),
        paymentStatus: state.paymentStatus,
        salesStatus: state.salesStatus,
        totalPrice: state.totalPrice,
        details: state.invoiceDetails,
      );

      final invoiceId = await _firebase.createSalesInvoice(invoice);
      invoice.salesInvoiceID = invoiceId;

      for (var detail in invoice.details) {
        final updatedDetail = detail.copyWith(salesInvoiceID: invoiceId);
        await _firebase.createSalesInvoiceDetail(updatedDetail);
        
        await _firebase.updateProductStockAndSales(
          detail.productID,
          -detail.quantity,
          detail.quantity,
        );
      }

      emit(state.copyWith(
        isLoading: false,
        selectedCustomer: state.selectedCustomer,
      ));
      
      return invoice;
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: e.toString(),
        selectedCustomer: state.selectedCustomer,
      ));
      return null;
    }
  }

  void updateSelectedModalProduct(Product? product) {
    emit(state.copyWith(
      selectedModalProduct: product,
      selectedCustomer: state.selectedCustomer,
      address: state.address,
    ));
  }
} 