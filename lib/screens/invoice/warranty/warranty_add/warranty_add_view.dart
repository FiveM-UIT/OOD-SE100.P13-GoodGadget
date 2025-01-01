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
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: state.isLoading
                    ? const Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : GradientIconButton(
                        icon: Icons.check,
                        onPressed: () => _saveInvoice(state),
                        fillColor: Colors.transparent,
                      ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Customer Information Card
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Customer Information',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Customer Selection
                          DropdownButtonFormField<String>(
                            value: state.selectedCustomerId,
                            decoration: InputDecoration(
                              labelText: 'Select Customer',
                              labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                              prefixIcon: Icon(Icons.person_outline, color: Colors.white.withOpacity(0.7)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: Theme.of(context).primaryColor),
                              ),
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
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  if (state.selectedCustomerId != null) ...[
                    if (state.customerInvoices.isEmpty)
                      // No Invoices Message Card
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 48,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'No sales invoices available',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'This customer has no eligible sales invoices for warranty claims.',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                    else ...[
                      // Invoice Details Card
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Invoice Details',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Sales Invoice Selection
                              DropdownButtonFormField<String>(
                                value: state.selectedSalesInvoiceId,
                                decoration: InputDecoration(
                                  labelText: 'Select Sales Invoice',
                                  labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                                  prefixIcon: Icon(Icons.receipt_outlined, color: Colors.white.withOpacity(0.7)),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(color: Colors.white),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Theme.of(context).primaryColor),
                                  ),
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
                                decoration: InputDecoration(
                                  labelText: 'Reason for Warranty',
                                  labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                                  prefixIcon: Icon(Icons.description_outlined, color: Colors.white.withOpacity(0.7)),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(color: Colors.white),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Theme.of(context).primaryColor),
                                  ),
                                ),
                                maxLines: 3,
                                onChanged: cubit.updateReason,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Products Card
                      if (state.salesInvoice != null)
                        Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Select Products for Warranty',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: state.salesInvoice!.details.length,
                                  itemBuilder: (context, index) {
                                    final detail = state.salesInvoice!.details[index];
                                    final isSelected = state.selectedProducts.contains(detail.productID);
                                    
                                    return Card(
                                      margin: const EdgeInsets.only(bottom: 8),
                                      child: CheckboxListTile(
                                        value: isSelected,
                                        onChanged: (bool? value) {
                                          if (value == true) {
                                            cubit.selectProduct(detail.productID);
                                          } else {
                                            cubit.deselectProduct(detail.productID);
                                          }
                                        },
                                        title: Text(
                                          detail.productName ?? 'Unknown Product',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        activeColor: Theme.of(context).primaryColor,
                                        checkColor: Colors.white,
                                        side: BorderSide(
                                          color: Colors.white.withOpacity(0.8),
                                          width: 2,
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Available: ${detail.quantity}',
                                              style: const TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                            if (isSelected) ...[
                                              const SizedBox(height: 8),
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
                                                      initialValue: (state.productQuantities[detail.productID] ?? 0).toString(),
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
                                          ],
                                        ),
                                        controlAffinity: ListTileControlAffinity.leading,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
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