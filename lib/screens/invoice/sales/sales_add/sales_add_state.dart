import 'package:equatable/equatable.dart';
import 'package:gizmoglobe_client/enums/invoice_related/payment_status.dart';
import 'package:gizmoglobe_client/enums/invoice_related/sales_status.dart';
import 'package:gizmoglobe_client/objects/customer.dart';
import 'package:gizmoglobe_client/objects/invoice_related/sales_invoice_detail.dart';
import 'package:gizmoglobe_client/objects/product_related/product.dart';

class SalesAddState extends Equatable {
  final bool isLoading;
  final bool isLoadingData;
  final String? error;
  final Customer? selectedCustomer;
  final String address;
  final PaymentStatus paymentStatus;
  final SalesStatus salesStatus;
  final List<Customer> customers;
  final List<Product> products;
  final List<SalesInvoiceDetail> invoiceDetails;
  final DateTime selectedDate;
  final Product? selectedModalProduct;

  SalesAddState({
    this.isLoading = false,
    this.isLoadingData = true,
    this.error,
    this.selectedCustomer,
    this.address = '',
    this.paymentStatus = PaymentStatus.unpaid,
    this.salesStatus = SalesStatus.pending,
    this.customers = const [],
    this.products = const [],
    this.invoiceDetails = const [],
    this.selectedModalProduct,
    DateTime? selectedDate,
  }) : selectedDate = selectedDate ?? DateTime.now();

  double get totalPrice => invoiceDetails.fold(
    0, (sum, detail) => sum + detail.subtotal
  );

  @override
  List<Object?> get props => [
    isLoading,
    error,
    selectedCustomer,
    address,
    paymentStatus,
    salesStatus,
    customers,
    products,
    invoiceDetails,
    selectedDate,
    selectedModalProduct,
  ];

  SalesAddState copyWith({
    bool? isLoading,
    bool? isLoadingData,
    String? error,
    Customer? selectedCustomer,
    String? address,
    PaymentStatus? paymentStatus,
    SalesStatus? salesStatus,
    List<Customer>? customers,
    List<Product>? products,
    List<SalesInvoiceDetail>? invoiceDetails,
    DateTime? selectedDate,
    Product? selectedModalProduct,
  }) {
    return SalesAddState(
      isLoading: isLoading ?? this.isLoading,
      isLoadingData: isLoadingData ?? this.isLoadingData,
      error: error,
      selectedCustomer: selectedCustomer,
      address: address ?? this.address,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      salesStatus: salesStatus ?? this.salesStatus,
      customers: customers ?? this.customers,
      products: products ?? this.products,
      invoiceDetails: invoiceDetails ?? this.invoiceDetails,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedModalProduct: selectedModalProduct,
    );
  }
} 