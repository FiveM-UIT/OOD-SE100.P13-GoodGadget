class IncomingInvoiceDetail {
  String? incomingInvoiceDetailID;
  String incomingInvoiceID;
  String productID;
  String? productName; // Thêm trường này
  double importPrice;
  int quantity;
  double subtotal;

  IncomingInvoiceDetail({
    this.incomingInvoiceDetailID,
    required this.incomingInvoiceID,
    required this.productID,
    this.productName,
    required this.importPrice,
    required this.quantity,
    required this.subtotal,
  });

  Map<String, dynamic> toMap() {
    return {
      'incomingInvoiceID': incomingInvoiceID,
      'productID': productID,
      'importPrice': importPrice,
      'quantity': quantity,
      'subtotal': subtotal,
    };
  }

  static IncomingInvoiceDetail fromMap(String id, Map<String, dynamic> map) {
    return IncomingInvoiceDetail(
      incomingInvoiceDetailID: id,
      incomingInvoiceID: map['incomingInvoiceID'] ?? '',
      productID: map['productID'] ?? '',
      importPrice: (map['importPrice'] ?? 0).toDouble(),
      quantity: map['quantity'] ?? 0,
      subtotal: (map['subtotal'] ?? 0).toDouble(),
    );
  }

  IncomingInvoiceDetail copyWith({
    String? incomingInvoiceDetailID,
    String? incomingInvoiceID,
    String? productID,
    String? productName,
    double? importPrice,
    int? quantity,
    double? subtotal,
  }) {
    return IncomingInvoiceDetail(
      incomingInvoiceDetailID: incomingInvoiceDetailID ?? this.incomingInvoiceDetailID,
      incomingInvoiceID: incomingInvoiceID ?? this.incomingInvoiceID,
      productID: productID ?? this.productID,
      productName: productName ?? this.productName,
      importPrice: importPrice ?? this.importPrice,
      quantity: quantity ?? this.quantity,
      subtotal: subtotal ?? this.subtotal,
    );
  }
}