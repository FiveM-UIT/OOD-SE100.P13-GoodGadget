import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gizmoglobe_client/enums/invoice_related/payment_status.dart';
import '../../../data/database/database.dart';
import 'home_screen_state.dart';

class HomeScreenCubit extends Cubit<HomeScreenState> {
  HomeScreenCubit() : super(const HomeScreenState()) {
    _initialize();
  }

  Future<void> _initialize() async {
    final db = Database();
    await db.getUser();
    
    // Calculate total products
    final totalProducts = db.productList.length;
    
    // Calculate total customers
    final totalCustomers = db.customerList.length;
    
    // Calculate total revenue
    final totalRevenue = db.salesInvoiceList
        .where((invoice) => invoice.paymentStatus == PaymentStatus.paid)
        .fold(0.0, (sum, invoice) => sum + invoice.totalPrice);
    
    // Calculate sales by category
    final salesByCategory = <String, int>{};
    for (var invoice in db.salesInvoiceList) {
      for (var detail in invoice.details) {
        final product = db.productList.firstWhere(
          (p) => p.productID == detail.productID,
        );
        final category = product.category.getName();
        salesByCategory[category] = (salesByCategory[category] ?? 0) + detail.quantity;
      }
    }
    
    // Calculate monthly sales
    final monthlySales = <SalesData>[];
    final now = DateTime.now();
    for (var i = 11; i >= 0; i--) {
      final month = DateTime(now.year, now.month - i, 1);
      final salesInMonth = db.salesInvoiceList
          .where((invoice) => 
              invoice.date.year == month.year && 
              invoice.date.month == month.month &&
              invoice.paymentStatus == PaymentStatus.paid)
          .fold(0.0, (sum, invoice) => sum + invoice.totalPrice);
      monthlySales.add(SalesData(month, salesInMonth));
    }

    emit(state.copyWith(
      username: db.username ?? 'User',
      totalProducts: totalProducts,
      totalCustomers: totalCustomers,
      totalRevenue: totalRevenue,
      salesByCategory: salesByCategory,
      monthlySales: monthlySales,
    ));
  }
}