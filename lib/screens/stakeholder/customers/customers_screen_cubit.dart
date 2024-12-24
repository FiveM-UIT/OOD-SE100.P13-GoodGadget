import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gizmoglobe_client/data/firebase/firebase.dart';
import 'package:gizmoglobe_client/objects/customer.dart';
import 'customers_screen_state.dart';

class CustomersScreenCubit extends Cubit<CustomersScreenState> {
  final _firebase = Firebase();
  late final Stream<List<Customer>> _customersStream;
  StreamSubscription<List<Customer>>? _subscription;

  CustomersScreenCubit() : super(const CustomersScreenState()) {
    _customersStream = _firebase.customersStream();
    _listenToCustomers();
    loadCustomers();
  }

  void _listenToCustomers() {
    _subscription = _customersStream.listen((customers) {
      if (state.searchQuery.isEmpty) {
        emit(state.copyWith(customers: customers));
      } else {
        searchCustomers(state.searchQuery);
      }
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  Future<void> loadCustomers() async {
    emit(state.copyWith(isLoading: true));
    try {
      final customers = await _firebase.getCustomers();
      emit(state.copyWith(
        customers: customers,
        isLoading: false,
      ));
    } catch (e) {
      print('Lỗi khi tải danh sách khách hàng: $e');
      emit(state.copyWith(isLoading: false));
    }
  }

  void searchCustomers(String query) {
    emit(state.copyWith(searchQuery: query));
    
    if (query.isEmpty) {
      loadCustomers();
      return;
    }

    final filteredCustomers = state.customers.where((customer) {
      return customer.customerName.toLowerCase().contains(query.toLowerCase()) ||
          customer.email.toLowerCase().contains(query.toLowerCase()) ||
          customer.phoneNumber.contains(query);
    }).toList();

    emit(state.copyWith(customers: filteredCustomers));
  }

  Future<void> toggleBanStatus(String customerId, bool currentStatus) async {
    try {
      await _firebase.toggleCustomerBanStatus(customerId, !currentStatus);
    } catch (e) {
      print('Lỗi khi thay đổi trạng thái ban: $e');
    }
  }

  void setSelectedIndex(int? index) {
    emit(state.copyWith(selectedIndex: index));
  }
}
