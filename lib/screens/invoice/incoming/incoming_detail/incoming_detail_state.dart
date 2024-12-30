import 'package:gizmoglobe_client/objects/invoice_related/incoming_invoice.dart';
import 'package:gizmoglobe_client/objects/invoice_related/incoming_invoice_detail.dart';
import 'package:gizmoglobe_client/objects/manufacturer.dart';
import 'package:gizmoglobe_client/objects/product_related/product.dart';

class IncomingDetailState {
  final bool isLoading;
  final IncomingInvoice? invoice;
  final String? manufacturerName;

  const IncomingDetailState({
    this.isLoading = false,
    this.invoice,
    this.manufacturerName,
  });

  IncomingDetailState copyWith({
    bool? isLoading,
    IncomingInvoice? invoice,
    String? manufacturerName,
  }) {
    return IncomingDetailState(
      isLoading: isLoading ?? this.isLoading,
      invoice: invoice ?? this.invoice,
      manufacturerName: manufacturerName ?? this.manufacturerName,
    );
  }
}
