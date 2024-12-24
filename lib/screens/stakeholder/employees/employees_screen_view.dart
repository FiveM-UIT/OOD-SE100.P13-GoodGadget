import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gizmoglobe_client/objects/employee.dart';
import 'package:gizmoglobe_client/widgets/general/field_with_icon.dart';
import 'package:gizmoglobe_client/widgets/general/gradient_icon_button.dart';
import 'employees_screen_cubit.dart';
import 'employees_screen_state.dart';
import 'employee_detail/employee_detail_view.dart';

class EmployeesScreen extends StatefulWidget {
  const EmployeesScreen({super.key});

  static Widget newInstance() => BlocProvider(
        create: (context) => EmployeesScreenCubit(),
        child: const EmployeesScreen(),
      );

  @override
  State<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  final TextEditingController searchController = TextEditingController();
  EmployeesScreenCubit get cubit => context.read<EmployeesScreenCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeesScreenCubit, EmployeesScreenState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            if (state.selectedIndex != null) {
              cubit.setSelectedIndex(null);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: FieldWithIcon(
                        controller: searchController,
                        hintText: 'Find employees...',
                        fillColor: Theme.of(context).colorScheme.surface,
                        onChange: (value) {
                          cubit.searchEmployees(value);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    GradientIconButton(
                      icon: Icons.person_add,
                      iconSize: 32,
                      onPressed: () {
                        // TODO: Implement add employee
                      },
                    )
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: BlocBuilder<EmployeesScreenCubit, EmployeesScreenState>(
                    builder: (context, state) {
                      if (state.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state.employees.isEmpty) {
                        return const Center(
                          child: Text(
                            'No employees found',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.employees.length,
                        itemBuilder: (context, index) {
                          final employee = state.employees[index];
                          return GestureDetector(
                            onLongPress: () => cubit.setSelectedIndex(index),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: Material(
                                color: Theme.of(context).cardColor,
                                borderRadius: BorderRadius.circular(8),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(8),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EmployeeDetailScreen(employee: employee),
                                      ),
                                    );
                                  },
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                                              child: Icon(
                                                Icons.person,
                                                color: Theme.of(context).colorScheme.primary,
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            Expanded(
                                              child: Text(
                                                employee.employeeName,
                                                style: Theme.of(context).textTheme.bodyLarge,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (state.selectedIndex == index)
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: Container(
                                            constraints: const BoxConstraints(
                                              maxWidth: 200,
                                            ),
                                            child: Card(
                                              margin: EdgeInsets.zero,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                                children: [
                                                  ListTile(
                                                    dense: true,
                                                    leading: const Icon(Icons.visibility_outlined),
                                                    title: const Text('View'),
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => EmployeeDetailScreen(employee: employee),
                                                        ),
                                                      );
                                                      cubit.setSelectedIndex(null);
                                                    },
                                                  ),
                                                  ListTile(
                                                    dense: true,
                                                    leading: const Icon(Icons.edit_outlined),
                                                    title: const Text('Edit'),
                                                    onTap: () {
                                                      // TODO: Navigate to edit screen
                                                      cubit.setSelectedIndex(null);
                                                    },
                                                  ),
                                                  ListTile(
                                                    dense: true,
                                                    leading: Icon(
                                                      Icons.delete_outline,
                                                      color: Theme.of(context).colorScheme.error,
                                                    ),
                                                    title: Text(
                                                      'Delete',
                                                      style: TextStyle(
                                                        color: Theme.of(context).colorScheme.error,
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      // TODO: Implement delete action
                                                      cubit.setSelectedIndex(null);
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
