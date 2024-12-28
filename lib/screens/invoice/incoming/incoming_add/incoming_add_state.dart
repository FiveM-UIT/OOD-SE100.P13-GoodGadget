import 'package:equatable/equatable.dart';
import 'package:gizmoglobe_client/enums/invoice_related/payment_status.dart';
import 'package:gizmoglobe_client/objects/invoice_related/incoming_invoice_detail.dart';
import 'package:gizmoglobe_client/objects/manufacturer.dart';
import 'package:gizmoglobe_client/objects/product_related/product.dart';

class IncomingAddState extends Equatable {
  final bool isLoading;
  final String? error;
  final Manufacturer? selectedManufacturer;
  final PaymentStatus paymentStatus;
  final List<Manufacturer> manufacturers;
  final List<Product> products;
  final List<IncomingInvoiceDetail> invoiceDetails;
  final DateTime selectedDate;

  IncomingAddState({
    this.isLoading = false,
    this.error,
    this.selectedManufacturer,
    this.paymentStatus = PaymentStatus.unpaid,
    this.manufacturers = const [],
    this.products = const [],
    this.invoiceDetails = const [],
    DateTime? selectedDate,
  }) : selectedDate = selectedDate ?? DateTime.now();

  double get totalPrice => invoiceDetails.fold(
      0, (sum, detail) => sum + detail.subtotal
  );

  @override
  List<Object?> get props => [
    isLoading,
    error,
    selectedManufacturer,
    paymentStatus,
    manufacturers,
    products,
    invoiceDetails,
    selectedDate,
  ];

  IncomingAddState copyWith({
    bool? isLoading,
    String? error,
    Manufacturer? selectedManufacturer,
    PaymentStatus? paymentStatus,
    List<Manufacturer>? manufacturers,
    List<Product>? products,
    List<IncomingInvoiceDetail>? invoiceDetails,
    DateTime? selectedDate,
  }) {
    return IncomingAddState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedManufacturer: selectedManufacturer,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      manufacturers: manufacturers ?? this.manufacturers,
      products: products ?? this.products,
      invoiceDetails: invoiceDetails ?? this.invoiceDetails,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }
}