import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gizmoglobe_client/objects/customer.dart';
import 'package:gizmoglobe_client/widgets/general/gradient_icon_button.dart';
import '../../../../widgets/general/address_picker.dart';
import '../../../../widgets/general/field_with_icon.dart';
import '../../../../widgets/general/gradient_checkbox.dart';
import 'customer_detail_cubit.dart';
import 'customer_detail_state.dart';
import '../customer_edit/customer_edit_view.dart';

class CustomerDetailScreen extends StatefulWidget {
  final Customer customer;

  static Widget newInstance({required customer}) =>
      BlocProvider(
        create: (context) => CustomerDetailCubit(customer),
        child: CustomerDetailScreen(customer: customer),
      );

  const CustomerDetailScreen({
    super.key,
    required this.customer,
  });

  @override
  State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  CustomerDetailCubit get cubit => context.read<CustomerDetailCubit>();
  final TextEditingController receiverNameController = TextEditingController();
  final TextEditingController receiverPhoneController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  bool isDefault = false;

  void _showAddAddressDialog(BuildContext context) {
    receiverNameController.clear();
    receiverPhoneController.clear();
    streetController.clear();
    isDefault = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FieldWithIcon(
                    controller: receiverNameController,
                    hintText: 'Receiver Name',
                    onChanged: (value) {
                      cubit.updateNewAddress(
                        receiverName: value,
                      );
                    },
                    fillColor: Theme.of(context).colorScheme.surface,
                  ),
                  const SizedBox(height: 8),
            
                  FieldWithIcon(
                    controller: receiverPhoneController,
                    hintText: 'Receiver Phone',
                    onChanged: (value) {
                      cubit.updateNewAddress(
                        receiverPhone: value,
                      );
                    },
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.phone,
                    fillColor: Theme.of(context).colorScheme.surface,
                  ),
                  const SizedBox(height: 8),
            
                  AddressPicker(
                    onAddressChanged: (province, district, ward) {
                      cubit.updateNewAddress(
                        province: province,
                        district: district,
                        ward: ward,
                      );
                    },
                  ),
                  const SizedBox(height: 8),
            
                  FieldWithIcon(
                    controller: streetController,
                    hintText: 'Street name, building, house no.',
                    onChanged: (value) {
                      cubit.updateNewAddress(
                        street: value,
                      );
                    },
                    fillColor: Theme.of(context).colorScheme.surface,
                  ),
                  const SizedBox(height: 16),
            
                  Row(
                    children: [
                      GradientCheckbox(
                        value: isDefault,
                        onChanged: (value) {
                          isDefault = value ?? false;
                          cubit.updateNewAddress(
                            isDefault: isDefault,
                          );
                        },
                      ),
                      const SizedBox(width: 12),
                      const Text('Set as default address'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (receiverNameController.text.isEmpty ||
                              receiverPhoneController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please fill in required fields'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }
                          await cubit.addAddress();
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Add address',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    receiverNameController.dispose();
    receiverPhoneController.dispose();
    streetController.dispose();
    isDefault = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CustomerDetailCubit(widget.customer),
      child: BlocBuilder<CustomerDetailCubit, CustomerDetailState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: GradientIconButton(
                icon: Icons.chevron_left,
                onPressed: () {
                  Navigator.pop(context);
                },
                fillColor: Theme.of(context).colorScheme.surface,
              ),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                              child: Icon(
                                Icons.person,
                                size: 50,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Container(
                            width: double.infinity,
                            child: Text(
                              state.customer.customerName,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 32),
                          const Text(
                            'Customer Information',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 24),
                          _buildInfoRow('Email', state.customer.email),
                          _buildInfoRow('Phone', state.customer.phoneNumber),
                          const SizedBox(height: 32),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Expanded(
                                child: Text(
                                  'Addresses',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add),
                                color: Colors.blue,
                                onPressed: () {
                                  _showAddAddressDialog(context);
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ...state.customer.addresses!.map((address) {
                            return GestureDetector(
                              onTap: () {
                                // Address press logic here
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 16),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      address.toString(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    if (address.isDefault)
                                      Container(
                                        margin: const EdgeInsets.only(top: 8),
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: const Text(
                                          'Default address',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            final updatedCustomer = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CustomerEditScreen(
                                  customer: state.customer,
                                ),
                              ),
                            );

                            if (updatedCustomer != null) {
                              // Update the customer in Firebase
                              cubit.updateCustomer(updatedCustomer);
                            }
                          },
                          icon: const Icon(
                              Icons.edit,
                              color: Colors.white,
                          ),
                          label: const Text(
                              'Edit',
                              style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (dialogContext) => AlertDialog(
                                title: const Text('Delete Customer'),
                                content: const Text(
                                  'Are you sure you want to delete this customer?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(dialogContext),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.pop(dialogContext); // Close dialog
                                      await cubit.deleteCustomer();
                                      if (mounted) {
                                        Navigator.pop(context); // Return to list
                                      }
                                    },
                                    child: const Text(
                                      'Delete',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: const Icon(
                              Icons.delete,
                              color: Colors.white,
                          ),
                          label: const Text(
                              'Delete',
                              style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

