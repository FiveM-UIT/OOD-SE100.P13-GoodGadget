import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gizmoglobe_client/widgets/general/field_with_icon.dart';
import 'package:gizmoglobe_client/widgets/general/gradient_icon_button.dart';
import 'customers_screen_cubit.dart';
import 'customers_screen_state.dart';
import 'customer_detail/customer_detail_view.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  static Widget newInstance() => BlocProvider(
        create: (context) => CustomersScreenCubit(),
        child: const CustomersScreen(),
      );

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  final TextEditingController searchController = TextEditingController();
  CustomersScreenCubit get cubit => context.read<CustomersScreenCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomersScreenCubit, CustomersScreenState>(
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
                        hintText: 'Find customers...',
                        fillColor: Theme.of(context).colorScheme.surface,
                        onChange: (value) {
                          cubit.searchCustomers(value);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    GradientIconButton(
                      icon: Icons.person_add,
                      iconSize: 32,
                      onPressed: () {
                        // TODO: Implement add customer
                      },
                    )
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: BlocBuilder<CustomersScreenCubit, CustomersScreenState>(
                    builder: (context, state) {
                      if (state.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state.customers.isEmpty) {
                        return const Center(
                          child: Text('No matching customers found'),
                        );
                      }

                      return ListView.builder(
                        itemCount: state.customers.length,
                        itemBuilder: (context, index) {
                          final customer = state.customers[index];
                          final isSelected = state.selectedIndex == index;

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CustomerDetailScreen(
                                    customer: customer,
                                  ),
                                ),
                              );
                            },
                            onLongPress: () {
                              cubit.setSelectedIndex(index);
                            },
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 200),
                              opacity: state.selectedIndex == null || isSelected ? 1.0 : 0.3,
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
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
                                        Text(
                                          customer.customerName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (isSelected)
                                    Positioned(
                                      right: 8,
                                      top: -4,
                                      child: SizedBox(
                                        width: 120,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).cardColor,
                                            borderRadius: BorderRadius.circular(8),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.1),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ListTile(
                                                dense: true,
                                                leading: const Icon(
                                                  Icons.visibility_outlined,
                                                  size: 20,
                                                  color: Colors.white,
                                                ),
                                                title: const Text('View'),
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => CustomerDetailScreen(
                                                        customer: customer,
                                                      ),
                                                    ),
                                                  );
                                                  cubit.setSelectedIndex(null);
                                                },
                                              ),
                                              // const Divider(height: 1),
                                              ListTile(
                                                dense: true,
                                                leading: const Icon(
                                                  Icons.edit_outlined,
                                                  size: 20,
                                                  color: Colors.white,
                                                ),
                                                title: const Text('Edit'),
                                                onTap: () {
                                                  // TODO: Implement edit action
                                                  cubit.setSelectedIndex(null);
                                                },
                                              ),
                                              // const Divider(height: 1),
                                              ListTile(
                                                dense: true,
                                                leading: Icon(
                                                  Icons.delete_outline,
                                                  size: 20,
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
