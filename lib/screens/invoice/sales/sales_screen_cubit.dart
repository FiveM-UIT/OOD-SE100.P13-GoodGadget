import 'package:flutter_bloc/flutter_bloc.dart';
import 'sales_screen_state.dart';

class SalesScreenCubit extends Cubit<SalesScreenState> {
  SalesScreenCubit() : super(const SalesScreenState()) {
    loadInvoices();
  }

  Future<void> loadInvoices() async {

  }

  void searchInvoices(String query) {
    // TODO: Implement search logic
  }

  void setSelectedIndex(int? index) {
    emit(state.copyWith(selectedIndex: index));
  }
}
