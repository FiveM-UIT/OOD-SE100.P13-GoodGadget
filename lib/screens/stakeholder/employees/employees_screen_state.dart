import 'package:equatable/equatable.dart';
import 'package:gizmoglobe_client/objects/employee.dart';

class EmployeesScreenState extends Equatable {
  final List<Employee> employees;
  final bool isLoading;
  final String searchQuery;
  final int? selectedIndex;

  const EmployeesScreenState({
    this.employees = const [],
    this.isLoading = false,
    this.searchQuery = '',
    this.selectedIndex,
  });

  EmployeesScreenState copyWith({
    List<Employee>? employees,
    bool? isLoading,
    String? searchQuery,
    int? selectedIndex,
  }) {
    return EmployeesScreenState(
      employees: employees ?? this.employees,
      isLoading: isLoading ?? this.isLoading,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedIndex: selectedIndex,
    );
  }

  @override
  List<Object?> get props => [employees, isLoading, searchQuery, selectedIndex];
}
