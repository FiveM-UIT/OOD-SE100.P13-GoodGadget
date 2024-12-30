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

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Thêm sản phẩm'),
              onTap: () async {
                Navigator.pop(context);
                if (cubit.state.selectedManufacturerId != null) {
                  final detail = await Navigator.push<IncomingInvoiceDetail>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddDetailScreen.newInstance(
                        manufacturerId: cubit.state.selectedManufacturerId!,
                        invoiceId: '',
                      ),
                    ),
                  );
                  if (detail != null) {
                    cubit.addDetail(detail);
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IncomingAddCubit, IncomingAddState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Tạo hóa đơn nhập'),
          ),
          body: state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButtonFormField<String>(
                        value: state.selectedManufacturerId,
                        decoration: const InputDecoration(
                          labelText: 'Nhà cung cấp',
                        ),
                        items: state.manufacturers.map((manufacturer) {
                          return DropdownMenuItem(
                            value: manufacturer.manufacturerID,
                            child: Text(manufacturer.manufacturerName),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            cubit.selectManufacturer(value);
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Chi tiết hóa đơn',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.details.length,
                        itemBuilder: (context, index) {
                          final detail = state.details[index];
                          return Card(
                            child: ListTile(
                              title: Text('Sản phẩm #${detail.productID}'),
                              subtitle: Text(
                                'Số lượng: ${detail.quantity}\n'
                                'Đơn giá: ${detail.importPrice}\n'
                                'Thành tiền: ${detail.subtotal}',
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => cubit.removeDetail(index),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: GradientButton(
                          onPressed: state.isSaving
                              ? null
                              : () async {
                                  try {
                                    await cubit.saveInvoice();
                                    if (mounted) {
                                      Navigator.pop(context);
                                    }
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(e.toString())),
                                    );
                                  }
                                },
                          child: state.isSaving
                              ? const CircularProgressIndicator()
                              : const Text('Lưu hóa đơn'),
                        ),
                      ),
                    ],
                  ),
                ),
          floatingActionButton: state.selectedManufacturerId == null
              ? null
              : FloatingActionButton(
                  onPressed: _showBottomSheet,
                  child: const Icon(Icons.more_vert),
                ),
        );
      },
    );
  }
} 