import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gizmoglobe_client/widgets/general/gradient_button.dart';
import 'package:gizmoglobe_client/objects/invoice_related/incoming_invoice_detail.dart';
import 'incoming_detail_cubit.dart';
import 'incoming_detail_state.dart';
import 'package:intl/intl.dart';

class IncomingDetailScreen extends StatefulWidget {
  final String invoiceId;

  const IncomingDetailScreen({
    super.key,
    required this.invoiceId,
  });

  static Widget newInstance({required String invoiceId}) => BlocProvider(
        create: (context) => IncomingDetailCubit(invoiceId: invoiceId),
        child: IncomingDetailScreen(invoiceId: invoiceId),
      );

  @override
  State<IncomingDetailScreen> createState() => _IncomingDetailScreenState();
}

class _IncomingDetailScreenState extends State<IncomingDetailScreen> {
  IncomingDetailCubit get cubit => context.read<IncomingDetailCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IncomingDetailCubit, IncomingDetailState>(
      builder: (context, state) {
        final invoice = state.invoice;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Chi tiết hóa đơn nhập'),
          ),
          body: state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : invoice == null
                  ? const Center(child: Text('Không tìm thấy hóa đơn'))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Thông tin chung',
                                    style: Theme.of(context).textTheme.titleLarge,
                                  ),
                                  const SizedBox(height: 8),
                                  Text('Mã hóa đơn: ${invoice.incomingInvoiceID}'),
                                  Text('Nhà cung cấp: ${state.manufacturerName}'),
                                  Text('Ngày tạo: ${DateFormat('dd/MM/yyyy').format(invoice.date)}'),
                                  Text('Trạng thái: ${invoice.status.getName()}'),
                                  Text('Tổng tiền: ${NumberFormat.currency(locale: 'vi').format(invoice.totalPrice)}'),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Chi tiết sản phẩm',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: invoice.details.length,
                            itemBuilder: (context, index) {
                              final detail = invoice.details[index];
                              return Card(
                                child: ListTile(
                                  title: Text('Sản phẩm #${detail.productID}'),
                                  subtitle: Text(
                                    'Số lượng: ${detail.quantity}\n'
                                    'Đơn giá: ${NumberFormat.currency(locale: 'vi').format(detail.importPrice)}\n'
                                    'Thành tiền: ${NumberFormat.currency(locale: 'vi').format(detail.subtotal)}',
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
        );
      },
    );
  }
}
