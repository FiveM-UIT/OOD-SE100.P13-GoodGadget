import 'package:flutter_bloc/flutter_bloc.dart';
import 'incoming_screen_state.dart';

class IncomingScreenCubit extends Cubit<IncomingScreenState> {
  IncomingScreenCubit() : super(const IncomingScreenState()) {
    loadInvoices();
  }

  Future<void> loadInvoices() async {
    emit(state.copyWith(isLoading: true));
    // TODO: Implement API call to load invoices
    await Future.delayed(const Duration(seconds: 1)); // Simulate API call
    emit(state.copyWith(
      isLoading: false,
      invoices: [
        const IncomingInvoice(id: '001', date: '2024-03-20'),
        const IncomingInvoice(id: '002', date: '2024-03-19'),
      ],
    ));
  }

  void searchInvoices(String query) {
    // TODO: Implement search logic
  }

  void setSelectedIndex(int? index) {
    emit(state.copyWith(selectedIndex: index));
  }
}
