import 'package:gizmoglobe_client/objects/invoice_related/warranty_invoice.dart';
import 'package:gizmoglobe_client/objects/product_related/product.dart';

class WarrantyDetailState {
  final WarrantyInvoice invoice;
  final bool isLoading;
  final String? error;
  final Map<String, Product> products;

  const WarrantyDetailState({
    required this.invoice,
    this.isLoading = false,
    this.error,
    this.products = const {},
  });

  WarrantyDetailState copyWith({
    WarrantyInvoice? invoice,
    bool? isLoading,
    String? error,
    Map<String, Product>? products,
  }) {
    return WarrantyDetailState(
      invoice: invoice ?? this.invoice,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      products: products ?? this.products,
    );
  }
}