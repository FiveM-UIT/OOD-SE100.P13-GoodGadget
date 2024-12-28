import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gizmoglobe_client/enums/invoice_related/payment_status.dart';
import 'package:gizmoglobe_client/widgets/general/field_with_icon.dart';
import 'package:intl/intl.dart';
import '../../../../objects/product_related/product.dart';
import 'incoming_add_cubit.dart';
import 'incoming_add_state.dart';

class IncomingAddScreen extends StatefulWidget {
  const IncomingAddScreen({super.key});

  @override
  State<IncomingAddScreen> createState() => _IncomingAddScreenState();
}

class _IncomingAddScreenState extends State<IncomingAddScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => IncomingAddCubit(),
      child: BlocBuilder<IncomingAddCubit, IncomingAddState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Tạo hóa đơn nhập'),
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
                    if (state.error != null)
                      Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          state.error!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),

                    // Chọn nhà cung cấp
                    DropdownButtonFormField(
                      value: state.selectedManufacturer,
                      decoration: const InputDecoration(
                        labelText: 'Nhà cung cấp',
                      ),
                      items: state.manufacturers.map((manufacturer) {
                        return DropdownMenuItem(
                          value: manufacturer,
                          child: Text(manufacturer.manufacturerName),
                        );
                      }).toList(),
                      onChanged: (value) {
                        context.read<IncomingAddCubit>()
                            .updateManufacturer(value);
                      },
                    ),
                    const SizedBox(height: 16),

                    // Chọn ngày
                    InkWell(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: state.selectedDate,
                          firstDate: DateTime(2000),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) {
                          context.read<IncomingAddCubit>()
                              .updateSelectedDate(date);
                        }
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Ngày nhập',
                        ),
                        child: Text(
                          DateFormat('dd/MM/yyyy')
                              .format(state.selectedDate),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Trạng thái thanh toán
                    DropdownButtonFormField<PaymentStatus>(
                      value: state.paymentStatus,
                      decoration: const InputDecoration(
                        labelText: 'Trạng thái thanh toán',
                      ),
                      items: PaymentStatus.values.map((status) {
                        return DropdownMenuItem(
                          value: status,
                          child: Text(status.toString()),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          context.read<IncomingAddCubit>()
                              .updatePaymentStatus(value);
                        }
                      },
                    ),
                    const SizedBox(height: 24),

                    // Danh sách sản phẩm
                    const Text(
                      'Chi tiết sản phẩm',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Danh sách sản phẩm đã thêm
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: state.invoiceDetails.length,
                      itemBuilder: (context, index) {
                        final detail = state.invoiceDetails[index];
                        final product = state.products.firstWhere(
                              (p) => p.productID == detail.productID,
                        );

                        return Card(
                          child: ListTile(
                            title: Text(product.productName),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Đơn giá: \$${detail.importPrice
                                      .toStringAsFixed(2)}',
                                ),
                                Text(
                                  'Số lượng: ${detail.quantity}',
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '\$${detail.subtotal.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    context.read<IncomingAddCubit>()
                                        .removeDetail(index);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    // Nút thêm sản phẩm
                    ElevatedButton.icon(
                      onPressed: () {
                        _showAddProductDialog(context, state);
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Thêm sản phẩm'),
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Tổng tiền: \$${state.totalPrice.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: state.isLoading
                        ? null
                        : () async {
                      final invoice = await context
                          .read<IncomingAddCubit>()
                          .createInvoice();
                      if (invoice != null) {
                        Navigator.pop(context, invoice);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const Text('Tạo hóa đơn'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _showAddProductDialog(
      BuildContext context,
      IncomingAddState state,
      ) async {
    if (state.products.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đang tải danh sách sản phẩm...')),
      );
      return;
    }

    final product = await showDialog<Product>(
      context: context,
      builder: (context) => _ProductSelectionDialog(products: state.products),
    );

    if (product != null) {
      if (!mounted) return;

      await showDialog(
        context: context,
        builder: (context) => _ProductDetailDialog(
          product: product,
          onSubmit: (importPrice, quantity) {
            context.read<IncomingAddCubit>().addDetail(
              product,
              importPrice,
              quantity,
            );
          },
        ),
      );
    }
  }
}

// Product Selection Dialog
class _ProductSelectionDialog extends StatelessWidget {
  final List<Product> products;

  const _ProductSelectionDialog({
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Chọn sản phẩm',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ListTile(
                    title: Text(product.productName),
                    subtitle: Text(product.category.toString()),
                    onTap: () {
                      Navigator.pop(context, product);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Product Detail Dialog
class _ProductDetailDialog extends StatefulWidget {
  final Product product;
  final void Function(double importPrice, int quantity) onSubmit;

  const _ProductDetailDialog({
    required this.product,
    required this.onSubmit,
  });

  @override
  State<_ProductDetailDialog> createState() => _ProductDetailDialogState();
}

class _ProductDetailDialogState extends State<_ProductDetailDialog> {
  final _formKey = GlobalKey<FormState>();
  final _importPriceController = TextEditingController();
  final _quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set giá trị mặc định
    _importPriceController.text = widget.product.importPrice.toString();
    _quantityController.text = '1';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ... phần hiển thị giữ nguyên ...
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final importPrice = double.parse(_importPriceController.text);
                    final quantity = int.parse(_quantityController.text);

                    widget.onSubmit(importPrice, quantity);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Thêm'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}