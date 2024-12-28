import 'package:equatable/equatable.dart';
import 'package:gizmoglobe_client/objects/invoice_related/incoming_invoice.dart';

class IncomingDetailState extends Equatable {
  final IncomingInvoice invoice;
  final bool isLoading;
  final String? error;

  const IncomingDetailState({
    required this.invoice,
    this.isLoading = false,
    this.error,
  });

  IncomingDetailState copyWith({
    IncomingInvoice? invoice,
    bool? isLoading,
    String? error,
  }) {
    return IncomingDetailState(
      invoice: invoice ?? this.invoice,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [invoice, isLoading, error];
}