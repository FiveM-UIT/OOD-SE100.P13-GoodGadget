import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gizmoglobe_client/widgets/general/field_with_icon.dart';
import 'package:gizmoglobe_client/widgets/general/gradient_icon_button.dart';
import 'vendors_screen_cubit.dart';
import 'vendors_screen_state.dart';
import 'package:gizmoglobe_client/screens/stakeholder/vendors/vendor_detail/vendor_detail_view.dart';
import 'package:gizmoglobe_client/screens/stakeholder/vendors/vendor_edit/vendor_edit_view.dart';

class VendorsScreen extends StatefulWidget {
  const VendorsScreen({super.key});

  static Widget newInstance() => BlocProvider(
        create: (context) => VendorsScreenCubit(),
        child: const VendorsScreen(),
      );

  @override
  State<VendorsScreen> createState() => _VendorsScreenState();
}

class _VendorsScreenState extends State<VendorsScreen> {
  final TextEditingController searchController = TextEditingController();
  VendorsScreenCubit get cubit => context.read<VendorsScreenCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VendorsScreenCubit, VendorsScreenState>(
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
                        hintText: 'Find manufacturers...',
                        fillColor: Theme.of(context).colorScheme.surface,
                        onChanged: (value) {
                          cubit.searchManufacturers(value);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    GradientIconButton(
                      icon: Icons.person_add,
                      iconSize: 32,
                      onPressed: () {
                        // TODO: Implement add manufacturer
                      },
                    )
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: BlocBuilder<VendorsScreenCubit, VendorsScreenState>(
                    builder: (context, state) {
                      if (state.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state.manufacturers.isEmpty) {
                        return const Center(
                          child: Text('No matching manufacturers found'),
                        );
                      }

                      return ListView.builder(
                        itemCount: state.manufacturers.length,
                        itemBuilder: (context, index) {
                          final manufacturer = state.manufacturers[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VendorDetailScreen(
                                    manufacturer: manufacturer,
                                  ),
                                ),
                              );
                            },
                            onLongPress: () {
                              cubit.setSelectedIndex(index);
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.transparent,
                                    contentPadding: EdgeInsets.zero,
                                    content: Container(
                                      width: 120,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).cardColor,
                                        borderRadius: BorderRadius.circular(8),
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
                                              Navigator.pop(context);
                                              cubit.setSelectedIndex(null);
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => VendorDetailScreen(
                                                    manufacturer: manufacturer,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                          ListTile(
                                            dense: true,
                                            leading: const Icon(
                                              Icons.edit_outlined,
                                              size: 20,
                                              color: Colors.white,
                                            ),
                                            title: const Text('Edit'),
                                            onTap: () async {
                                              Navigator.pop(context);
                                              cubit.setSelectedIndex(null);
                                              final updatedManufacturer = await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => VendorEditScreen(
                                                    manufacturer: manufacturer,
                                                  ),
                                                ),
                                              );
                                              
                                              if (updatedManufacturer != null) {
                                                await cubit.updateManufacturer(updatedManufacturer);
                                              }
                                            },
                                          ),
                                          ListTile(
                                            dense: true,
                                            leading: Icon(
                                              Icons.delete_outlined,
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
                                              Navigator.pop(context);
                                              cubit.setSelectedIndex(null);
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text('Delete Manufacturer'),
                                                    content: Text('Are you sure you want to delete ${manufacturer.manufacturerName}?'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () => Navigator.pop(context),
                                                        child: const Text('Cancel'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () async {
                                                          Navigator.pop(context);
                                                          await cubit.deleteManufacturer(manufacturer.manufacturerID!);
                                                        },
                                                        child: Text(
                                                          'Delete',
                                                          style: TextStyle(
                                                            color: Theme.of(context).colorScheme.error,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ).then((_) {
                                cubit.setSelectedIndex(null);
                              });
                            },
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 200),
                              opacity: state.selectedIndex == null || state.selectedIndex == index ? 1.0 : 0.3,
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                decoration: BoxDecoration(
                                  color: state.selectedIndex == index 
                                      ? Theme.of(context).primaryColor.withOpacity(0.1) 
                                      : Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                                        child: Icon(
                                          Icons.business,
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Text(
                                          manufacturer.manufacturerName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
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
