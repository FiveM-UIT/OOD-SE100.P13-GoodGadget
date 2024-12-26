import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gizmoglobe_client/enums/invoice_related/payment_status.dart';
import 'package:gizmoglobe_client/enums/invoice_related/sales_status.dart';
import 'package:gizmoglobe_client/objects/invoice_related/sales_invoice_detail.dart';

class SalesInvoice {
  String? salesInvoiceID;
  String customerID;
  String? customerName;
  String address;
  DateTime date;
  PaymentStatus paymentStatus;
  SalesStatus salesStatus;
  double totalPrice;
  List<SalesInvoiceDetail> details;

  SalesInvoice({
    this.salesInvoiceID,
    required this.customerID,
    this.customerName,
    required this.address,
    required this.date,
    required this.paymentStatus,
    required this.salesStatus,
    required this.totalPrice,
    this.details = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'customerID': customerID,
      'customerName': customerName,
      'address': address,
      'date': Timestamp.fromDate(date),
      'paymentStatus': paymentStatus.toString(),
      'salesStatus': salesStatus.toString(),
      'totalPrice': totalPrice,
    };
  }

  static SalesInvoice fromMap(String id, Map<String, dynamic> map) {
    return SalesInvoice(
      salesInvoiceID: id,
      customerID: map['customerID'] ?? '',
      customerName: map['customerName'],
      address: map['address'] ?? '',
      date: (map['date'] as Timestamp).toDate(),
      paymentStatus: PaymentStatus.values.firstWhere(
        (e) => e.toString() == (map['paymentStatus'] as String? ?? 'Unpaid'),
        orElse: () => PaymentStatus.unpaid,
      ),
      salesStatus: SalesStatus.values.firstWhere(
        (e) => e.toString() == (map['salesStatus'] as String? ?? 'Pending'),
        orElse: () => SalesStatus.pending,
      ),
      totalPrice: (map['totalPrice'] ?? 0).toDouble(),
    );
  }
} 