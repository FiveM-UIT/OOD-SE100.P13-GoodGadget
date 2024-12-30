import 'package:gizmoglobe_client/enums/invoice_related/warranty_status.dart';
import 'package:gizmoglobe_client/objects/customer.dart';
import 'package:gizmoglobe_client/objects/invoice_related/sales_invoice.dart';
import 'package:gizmoglobe_client/objects/invoice_related/warranty_invoice_detail.dart';
import 'package:equatable/equatable.dart';

class WarrantyAddState extends Equatable {
  final String? selectedCustomerId;
  final String? selectedSalesInvoiceId;
  final SalesInvoice? salesInvoice;
  final List<WarrantyInvoiceDetail> details;
  final String reason;
  final bool isLoading;
  final String? errorMessage;
  final List<SalesInvoice> availableInvoices;
  final List<Customer> availableCustomers;
  final List<SalesInvoice> customerInvoices;
  final WarrantyStatus selectedStatus;
  final Set<String> selectedProducts;
  final Map<String, int> productQuantities;
  final bool isSuccess;

  const WarrantyAddState({
    this.selectedCustomerId,
    this.selectedSalesInvoiceId,
    this.salesInvoice,
    this.details = const [],
    this.reason = '',
    this.isLoading = false,
    this.errorMessage,
    this.availableInvoices = const [],
    this.availableCustomers = const [],
    this.customerInvoices = const [],
    this.selectedStatus = WarrantyStatus.pending,
    this.selectedProducts = const {},
    this.productQuantities = const {},
    this.isSuccess = false,
  });

  WarrantyAddState copyWith({
    String? selectedCustomerId,
    String? selectedSalesInvoiceId,
    SalesInvoice? salesInvoice,
    List<WarrantyInvoiceDetail>? details,
    String? reason,
    bool? isLoading,
    String? errorMessage,
    List<SalesInvoice>? availableInvoices,
    List<Customer>? availableCustomers,
    List<SalesInvoice>? customerInvoices,
    WarrantyStatus? selectedStatus,
    Set<String>? selectedProducts,
    Map<String, int>? productQuantities,
    bool? isSuccess,
  }) {
    return WarrantyAddState(
      selectedCustomerId: selectedCustomerId ?? this.selectedCustomerId,
      selectedSalesInvoiceId: selectedSalesInvoiceId ?? this.selectedSalesInvoiceId,
      salesInvoice: salesInvoice ?? this.salesInvoice,
      details: details ?? this.details,
      reason: reason ?? this.reason,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      availableInvoices: availableInvoices ?? this.availableInvoices,
      availableCustomers: availableCustomers ?? this.availableCustomers,
      customerInvoices: customerInvoices ?? this.customerInvoices,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      selectedProducts: selectedProducts ?? this.selectedProducts,
      productQuantities: productQuantities ?? this.productQuantities,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  List<Object?> get props => [
        selectedCustomerId,
        selectedSalesInvoiceId,
        salesInvoice,
        details,
        reason,
        isLoading,
        errorMessage,
        availableInvoices,
        availableCustomers,
        customerInvoices,
        selectedStatus,
        selectedProducts,
        productQuantities,
        isSuccess,
      ];
}