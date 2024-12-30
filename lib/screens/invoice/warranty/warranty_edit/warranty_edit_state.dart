import 'package:equatable/equatable.dart';
import 'package:gizmoglobe_client/enums/invoice_related/warranty_status.dart';
import 'package:gizmoglobe_client/objects/invoice_related/warranty_invoice.dart';

class WarrantyEditState extends Equatable {
  final WarrantyInvoice invoice;
  final bool isLoading;
  final String? errorMessage;
  final WarrantyStatus selectedStatus;

  const WarrantyEditState({
    required this.invoice,
    this.isLoading = false,
    this.errorMessage,
    required this.selectedStatus,
  });

  WarrantyEditState copyWith({
    WarrantyInvoice? invoice,
    bool? isLoading,
    String? errorMessage,
    WarrantyStatus? selectedStatus,
  }) {
    return WarrantyEditState(
      invoice: invoice ?? this.invoice,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      selectedStatus: selectedStatus ?? this.selectedStatus,
    );
  }

  @override
  List<Object?> get props => [invoice, isLoading, errorMessage, selectedStatus];
} 