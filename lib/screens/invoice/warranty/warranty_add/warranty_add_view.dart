import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gizmoglobe_client/objects/invoice_related/warranty_invoice.dart';
import 'package:gizmoglobe_client/widgets/general/field_with_icon.dart';
import 'package:gizmoglobe_client/widgets/general/gradient_text.dart';
import '../../../../widgets/general/gradient_icon_button.dart';
import 'warranty_add_cubit.dart';
import 'warranty_add_state.dart';

class WarrantyAddView extends StatefulWidget {
  const WarrantyAddView({super.key});

  static Widget newInstance() => BlocProvider(
        create: (context) => WarrantyAddCubit(),
        child: const WarrantyAddView(),
      );

  @override
  State<WarrantyAddView> createState() => _WarrantyAddViewState();
}

class _WarrantyAddViewState extends State<WarrantyAddView> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();

  WarrantyAddCubit get cubit => context.read<WarrantyAddCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WarrantyAddCubit, WarrantyAddState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: GradientIconButton(
              icon: Icons.chevron_left,
              onPressed: () => Navigator.pop(context),
              fillColor: Colors.transparent,
            ),
            title: GradientText(text: 'Create Warranty Invoice'),
            actions: [
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: () => _saveInvoice(state),
              ),
            ],
          ),
          body: state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Customer Selection
                        DropdownButtonFormField<String>(
                          value: state.selectedCustomerId,
                          decoration: const InputDecoration(
                            labelText: 'Select Customer',
                          ),
                          items: state.availableCustomers.map((customer) {
                            return DropdownMenuItem(
                              value: customer.customerID,
                              child: Text(customer.customerName),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              cubit.selectCustomer(value);
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a customer';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        if (state.selectedCustomerId != null) ...[
                          if (state.customerInvoices.isEmpty)
                            // Show message when no invoices available
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Column(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    size: 48,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'No sales invoices available for warranty',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'This customer has no eligible sales invoices for warranty claims.',
                                    style: TextStyle(color: Colors.grey),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            )
                          else ...[
                            // Sales Invoice Selection
                            DropdownButtonFormField<String>(
                              value: state.selectedSalesInvoiceId,
                              decoration: const InputDecoration(
                                labelText: 'Select Sales Invoice',
                              ),
                              items: state.customerInvoices.map((invoice) {
                                return DropdownMenuItem(
                                  value: invoice.salesInvoiceID,
                                  child: Text('Invoice #${invoice.salesInvoiceID}'),
                                );
                              }).toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  cubit.selectSalesInvoice(value);
                                }
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a sales invoice';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Reason Input
                            TextFormField(
                              controller: _reasonController,
                              decoration: const InputDecoration(
                                labelText: 'Reason for Warranty (Optional)',
                              ),
                              maxLines: 3,
                              onChanged: cubit.updateReason,
                            ),
                            const SizedBox(height: 16),

                            // Products List
                            if (state.salesInvoice != null) ...[
                              const Text(
                                'Select Products for Warranty',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: state.salesInvoice!.details.length,
                                itemBuilder: (context, index) {
                                  final detail = state.salesInvoice!.details[index];
                                  return Card(
                                    child: CheckboxListTile(
                                      value: state.selectedProducts.contains(detail.productID),
                                      onChanged: (bool? value) {
                                        if (value == true) {
                                          cubit.selectProduct(detail.productID);
                                        } else {
                                          cubit.deselectProduct(detail.productID);
                                        }
                                      },
                                      title: Text(detail.productName ?? 'Unknown Product'),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Available: ${detail.quantity}'),
                                          const SizedBox(height: 4),
                                          if (state.selectedProducts.contains(detail.productID))
                                            Row(
                                              children: [
                                                IconButton(
                                                  icon: const Icon(Icons.remove_circle_outline),
                                                  color: Colors.red,
                                                  onPressed: state.productQuantities[detail.productID] == 0
                                                      ? null
                                                      : () => cubit.updateDetailQuantity(
                                                            detail.productID,
                                                            (state.productQuantities[detail.productID] ?? 0) - 1,
                                                          ),
                                                ),
                                                SizedBox(
                                                  width: 50,
                                                  child: TextFormField(
                                                    textAlign: TextAlign.center,
                                                    keyboardType: TextInputType.number,
                                                    controller: TextEditingController(
                                                      text: (state.productQuantities[detail.productID] ?? 0).toString(),
                                                    )..selection = TextSelection.fromPosition(
                                                      TextPosition(
                                                        offset: (state.productQuantities[detail.productID] ?? 0)
                                                            .toString()
                                                            .length,
                                                      ),
                                                    ),
                                                    onChanged: (value) {
                                                      final quantity = int.tryParse(value) ?? 0;
                                                      if (quantity >= 0 && quantity <= detail.quantity) {
                                                        cubit.updateDetailQuantity(detail.productID, quantity);
                                                      }
                                                    },
                                                    decoration: const InputDecoration(
                                                      isDense: true,
                                                      contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                    ),
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: const Icon(Icons.add_circle_outline),
                                                  color: Colors.green,
                                                  onPressed: (state.productQuantities[detail.productID] ?? 0) >= detail.quantity
                                                      ? null
                                                      : () => cubit.updateDetailQuantity(
                                                            detail.productID,
                                                            (state.productQuantities[detail.productID] ?? 0) + 1,
                                                          ),
                                                ),
                                              ],
                                            ),
                                        ],
                                      ),
                                      controlAffinity: ListTileControlAffinity.leading,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ],
                        ],
                      ],
                    ),
                  ),
                ),
        );
      },
    );
  }

  Future<void> _saveInvoice(WarrantyAddState state) async {
    // Unfocus any text field first
    FocusScope.of(context).unfocus();
    await Future.delayed(const Duration(milliseconds: 100));

    if (!_formKey.currentState!.validate()) {
      print('Form validation failed');
      return;
    }

    print('Starting save process');
    
    // Store context before async operation
    final BuildContext dialogContext = context;
    
    // Show loading indicator
    showDialog(
      context: dialogContext,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );

    try {
      final invoice = await cubit.submit();
      
      if (!mounted) return;

      // Hide loading indicator
      if (Navigator.canPop(dialogContext)) {
        Navigator.pop(dialogContext);
      }

      if (invoice != null) {
        print('Invoice created successfully, force navigating back to warranty screen');
        
        // Show success message using root context
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Warranty invoice created successfully'),
            backgroundColor: Colors.green,
          ),
        );

        // Force navigation back to warranty screen
        if (mounted) {
          // Pop until we reach the warranty screen
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
        
      } else if (state.errorMessage != null) {
        print('Error creating invoice: ${state.errorMessage}');
        ScaffoldMessenger.of(dialogContext).showSnackBar(
          SnackBar(
            content: Text(state.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('Error during save process: $e');
      if (!mounted) return;
      
      // Hide loading indicator if still showing
      if (Navigator.canPop(dialogContext)) {
        Navigator.pop(dialogContext);
      }
      
      // Show error message
      ScaffoldMessenger.of(dialogContext).showSnackBar(
        SnackBar(
          content: Text('Error creating warranty invoice: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }
}