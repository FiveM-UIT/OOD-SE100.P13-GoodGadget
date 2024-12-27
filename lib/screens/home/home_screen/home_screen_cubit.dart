import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gizmoglobe_client/enums/invoice_related/payment_status.dart';
import '../../../data/database/database.dart';
import 'home_screen_state.dart';

class HomeScreenCubit extends Cubit<HomeScreenState> {
  final Database db = Database();
  
  HomeScreenCubit() : super(const HomeScreenState()) {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      // Đợi database khởi tạo xong
      await db.initialize();
      
      // Sau đó mới tính toán các giá trị
      final totalProducts = db.productList.length;
      final totalCustomers = db.customerList.length;
      
      // Tính tổng doanh thu
      double totalRevenue = 0.0;
      for (var invoice in db.salesInvoiceList) {
        if (invoice.paymentStatus == PaymentStatus.paid) {
          totalRevenue += invoice.totalPrice;
        }
      }

      // Tính sales theo category
      final salesByCategory = <String, int>{};
      for (var invoice in db.salesInvoiceList) {
        if (invoice.paymentStatus == PaymentStatus.paid) {
          for (var detail in invoice.details) {
            final category = detail.category ?? 'Unknown';
            salesByCategory[category] = (salesByCategory[category] ?? 0) + detail.quantity;
          }
        }
      }

      // Tính doanh thu theo tháng
      final List<SalesData> monthlySales = [];
      final now = DateTime.now();
      for (var i = 11; i >= 0; i--) {
        final month = DateTime(now.year, now.month - i, 1);
        double salesInMonth = 0.0;
        
        for (var invoice in db.salesInvoiceList) {
          if (invoice.paymentStatus == PaymentStatus.paid &&
              invoice.date.year == month.year && 
              invoice.date.month == month.month) {
            salesInMonth += invoice.totalPrice;
          }
        }
        
        monthlySales.add(SalesData(month, salesInMonth));
      }

      // Emit new state with loaded data
      emit(state.copyWith(
        username: db.username ?? 'User',
        totalProducts: totalProducts,
        totalCustomers: totalCustomers,
        totalRevenue: totalRevenue,
        salesByCategory: salesByCategory,
        monthlySales: monthlySales,
      ));
    } catch (e) {
      print('Error initializing dashboard: $e');
      // Optionally emit error state
    }
  }
}