import 'package:equatable/equatable.dart';
import 'package:gizmoglobe_client/objects/address_related/address.dart';
import 'package:gizmoglobe_client/objects/customer.dart';

class CustomerDetailState extends Equatable {
  final Customer customer;
  final bool isLoading;
  final String? error;
  final Address? newAddress;

  const CustomerDetailState({
    required this.customer,
    this.isLoading = false,
    this.error,
    this.newAddress,
  });

  CustomerDetailState copyWith({
    Customer? customer,
    bool? isLoading,
    String? error,
    Address? newAddress,
  }) {
    return CustomerDetailState(
      customer: customer ?? this.customer,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      newAddress: newAddress ?? this.newAddress,
    );
  }

  @override
  List<Object?> get props => [customer, isLoading, error, newAddress];
} 