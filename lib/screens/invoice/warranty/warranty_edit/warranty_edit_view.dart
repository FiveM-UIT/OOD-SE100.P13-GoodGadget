import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gizmoglobe_client/enums/invoice_related/warranty_status.dart';
import 'package:gizmoglobe_client/objects/invoice_related/warranty_invoice.dart';
import 'package:gizmoglobe_client/screens/invoice/warranty/warranty_edit/warranty_edit_cubit.dart';
import 'package:gizmoglobe_client/screens/invoice/warranty/warranty_edit/warranty_edit_state.dart';
import 'package:gizmoglobe_client/widgets/general/status_badge.dart';

class WarrantyEditView extends StatelessWidget {
  final WarrantyInvoice invoice;

  const WarrantyEditView({
    super.key,
    required this.invoice,
  });

  static Widget newInstance(WarrantyInvoice invoice) => BlocProvider(
        create: (context) => WarrantyEditCubit(invoice),
        child: WarrantyEditView(invoice: invoice),
      );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WarrantyEditCubit, WarrantyEditState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Edit Warranty Status'),
            actions: [
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: () async {
                  final success = await context.read<WarrantyEditCubit>().saveChanges();
                  if (!context.mounted) return;
                  
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Warranty updated successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.pop(context, true);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.errorMessage ?? 'Error updating warranty'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
          body: state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Current Status
                      const Text(
                        'Current Status',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      StatusBadge(status: state.invoice.status),
                      const SizedBox(height: 24),

                      // New Status Selection
                      const Text(
                        'New Status',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Card(
                        child: Column(
                          children: WarrantyStatus.values.map((status) {
                            return RadioListTile<WarrantyStatus>(
                              title: StatusBadge(status: status),
                              value: status,
                              groupValue: state.selectedStatus,
                              onChanged: (value) {
                                if (value != null) {
                                  context.read<WarrantyEditCubit>().updateStatus(value);
                                }
                              },
                            );
                          }).toList(),
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