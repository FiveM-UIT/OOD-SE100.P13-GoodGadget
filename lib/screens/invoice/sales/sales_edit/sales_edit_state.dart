import 'package:equatable/equatable.dart';
import 'package:gizmoglobe_client/objects/invoice_related/sales_invoice.dart';
import 'package:gizmoglobe_client/enums/invoice_related/payment_status.dart';
import 'package:gizmoglobe_client/enums/invoice_related/sales_status.dart';

class SalesEditState extends Equatable {
  final SalesInvoice invoice;
  final bool isLoading;
  final String? error;
  final PaymentStatus selectedPaymentStatus;
  final SalesStatus selectedSalesStatus;
  final String? userRole;

  const SalesEditState({
    required this.invoice,
    this.isLoading = false,
    this.error,
    required this.selectedPaymentStatus,
    required this.selectedSalesStatus,
    this.userRole,
  });

  SalesEditState copyWith({
    SalesInvoice? invoice,
    bool? isLoading,
    String? error,
    PaymentStatus? selectedPaymentStatus,
    SalesStatus? selectedSalesStatus,
    String? userRole,
  }) {
    return SalesEditState(
      invoice: invoice ?? this.invoice,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedPaymentStatus: selectedPaymentStatus ?? this.selectedPaymentStatus,
      selectedSalesStatus: selectedSalesStatus ?? this.selectedSalesStatus,
      userRole: userRole ?? this.userRole,
    );
  }

  @override
  List<Object?> get props => [
        invoice,
        isLoading,
        error,
        selectedPaymentStatus,
        selectedSalesStatus,
        userRole,
      ];
} 