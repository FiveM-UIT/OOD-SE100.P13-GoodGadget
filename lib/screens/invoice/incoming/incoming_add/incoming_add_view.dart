import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gizmoglobe_client/objects/manufacturer.dart';
import 'package:gizmoglobe_client/objects/product_related/product.dart';
import 'package:gizmoglobe_client/widgets/general/gradient_button.dart';
import 'incoming_add_cubit.dart';
import 'incoming_add_state.dart';

class IncomingAddScreen extends StatefulWidget {
  const IncomingAddScreen({super.key});

  static Widget newInstance() => BlocProvider(
        create: (context) => IncomingAddCubit(),
        child: const IncomingAddScreen(),
      );

  @override
  State<IncomingAddScreen> createState() => _IncomingAddScreenState();
}

class _IncomingAddScreenState extends State<IncomingAddScreen> {
  IncomingAddCubit get cubit => context.read<IncomingAddCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<IncomingAddCubit, IncomingAddState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage!)),
          );
          cubit.clearError();
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('New Incoming Invoice'),
          ),
          body: state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildManufacturerDropdown(state),
                      const SizedBox(height: 16),
                      if (state.selectedManufacturer != null) ...[
                        _buildProductsList(state),
                        const SizedBox(height: 16),
                        _buildDetailsList(state),
                        const SizedBox(height: 16),
                        _buildTotalPrice(state),
                        const SizedBox(height: 24),
                        _buildSubmitButton(state),
                      ],
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget _buildManufacturerDropdown(IncomingAddState state) {
    return DropdownButtonFormField<Manufacturer>(
      decoration: const InputDecoration(
        labelText: 'Select Manufacturer',
        border: OutlineInputBorder(),
      ),
      value: state.selectedManufacturer,
      items: state.manufacturers.map((manufacturer) {
        return DropdownMenuItem(
          value: manufacturer,
          child: Text(manufacturer.manufacturerName),
        );
      }).toList(),
      onChanged: (manufacturer) {
        if (manufacturer != null) {
          cubit.selectManufacturer(manufacturer);
        }
      },
    );
  }

  Widget _buildProductsList(IncomingAddState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Products',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.products.length,
          itemBuilder: (context, index) {
            final product = state.products[index];
            return Card(
              child: ListTile(
                title: Text(product.productName),
                subtitle: Text('\$${product.importPrice.toStringAsFixed(2)}'),
                trailing: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _showAddProductDialog(context, product),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDetailsList(IncomingAddState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Invoice Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.details.length,
          itemBuilder: (context, index) {
            final detail = state.details[index];
            final product = state.products.firstWhere(
              (p) => p.productID == detail.productID,
            );
            return Card(
              child: ListTile(
                title: Text(product.productName),
                subtitle: Text(
                  'Quantity: ${detail.quantity} × \$${detail.importPrice.toStringAsFixed(2)} = \$${detail.subtotal.toStringAsFixed(2)}',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showEditQuantityDialog(
                        context,
                        index,
                        detail.quantity,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => cubit.removeDetail(index),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTotalPrice(IncomingAddState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Text(
          'Total Price: ',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '\$${state.totalPrice.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(IncomingAddState state) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: state.isSubmitting
            ? null
            : () async {
                final success = await cubit.submitInvoice();
                if (success && mounted) {
                  Navigator.pop(context, true);
                }
              },
        child: state.isSubmitting
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text('Create Invoice'),
      ),
    );
  }

  Future<void> _showAddProductDialog(BuildContext context, Product product) async {
    final quantityController = TextEditingController();
    final importPriceController = TextEditingController(
      text: product.importPrice.toString(),
    );

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add ${product.productName}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: importPriceController,
              decoration: const InputDecoration(
                labelText: 'Import Price',
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: quantityController,
              decoration: const InputDecoration(
                labelText: 'Quantity',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final importPrice = double.tryParse(importPriceController.text);
              final quantity = int.tryParse(quantityController.text);

              if (importPrice != null && quantity != null) {
                cubit.addDetail(product, importPrice, quantity);
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _showEditQuantityDialog(
    BuildContext context,
    int index,
    int currentQuantity,
  ) async {
    final controller = TextEditingController(text: currentQuantity.toString());

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Quantity'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'New Quantity',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final newQuantity = int.tryParse(controller.text);
              if (newQuantity != null) {
                cubit.updateDetailQuantity(index, newQuantity);
                Navigator.pop(context);
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
} 