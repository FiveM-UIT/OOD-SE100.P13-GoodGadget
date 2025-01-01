import '../../../../enums/invoice_related/payment_status.dart';
import '../../../../enums/invoice_related/sales_status.dart';
import '../../../../objects/invoice_related/sales_invoice.dart';

class SalesInvoicePermissions {
  static bool canEditInvoice(String? userRole, SalesInvoice invoice) {
    return userRole == 'admin' && 
           (invoice.paymentStatus != PaymentStatus.paid ||
            invoice.salesStatus != SalesStatus.completed);
  }

  // Helper methods to check individual status locks
  static bool isPaymentStatusLocked(PaymentStatus status) {
    return status == PaymentStatus.paid;
  }

  static bool isSalesStatusLocked(SalesStatus status) {
    return status == SalesStatus.completed;
  }

  // Check if specific status can be edited
  static bool canEditPaymentStatus(String? userRole, SalesInvoice invoice) {
    return userRole == 'admin' && !isPaymentStatusLocked(invoice.paymentStatus);
  }

  static bool canEditSalesStatus(String? userRole, SalesInvoice invoice) {
    return userRole == 'admin' && !isSalesStatusLocked(invoice.salesStatus);
  }
} 