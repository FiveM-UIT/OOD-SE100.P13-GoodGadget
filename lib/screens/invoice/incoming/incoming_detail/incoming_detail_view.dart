import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gizmoglobe_client/enums/invoice_related/payment_status.dart';
import 'package:gizmoglobe_client/objects/invoice_related/incoming_invoice.dart';
import 'package:gizmoglobe_client/widgets/general/gradient_text.dart';
import 'package:intl/intl.dart';
import '../../../../widgets/general/gradient_icon_button.dart';
import 'incoming_detail_cubit.dart';
import 'incoming_detail_state.dart';
import 'package:gizmoglobe_client/widgets/general/status_badge.dart';
import '../permissions/incoming_invoice_permissions.dart';

class IncomingDetailScreen extends StatefulWidget {
  final IncomingInvoice invoice;

  const IncomingDetailScreen({
    super.key,
    required this.invoice,
  });

  static Widget newInstance(IncomingInvoice invoice) => BlocProvider(
        create: (context) => IncomingDetailCubit(invoice),
        child: IncomingDetailScreen(invoice: invoice),
      );

  @override
  State<IncomingDetailScreen> createState() => _IncomingDetailScreenState();
}

class _IncomingDetailScreenState extends State<IncomingDetailScreen> {
  IncomingDetailCubit get cubit => context.read<IncomingDetailCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<IncomingDetailCubit, IncomingDetailState>(
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
            leading: GradientIconButton(
              icon: Icons.chevron_left,
              onPressed: () => Navigator.pop(context),
              fillColor: Colors.transparent,
            ),
            title: GradientText(text: 'Invoice #${widget.invoice.incomingInvoiceID}')
          ),
          body: state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInvoiceHeader(state),
                const SizedBox(height: 24),
                _buildDetailsList(state),
                const SizedBox(height: 24),
                _buildTotalSection(state),
                if (IncomingInvoicePermissions.canEditPaymentStatus(
                    state.userRole, state.invoice)) ...[
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton.icon(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Confirm Payment'),
                              content: const Text('Mark this invoice as paid?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    await cubit.updatePaymentStatus(
                                        PaymentStatus.paid);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Confirm'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text('Mark as Paid'),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInvoiceHeader(IncomingDetailState state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Manufacturer',
                      style: TextStyle(
                        color: Theme
                            .of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      state.manufacturer?.manufacturerName ?? 'Unknown',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Date',
                      style: TextStyle(
                        color: Theme
                            .of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('dd/MM/yyyy').format(state.invoice.date),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Payment Status',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  StatusBadge(status: state.invoice.status),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsList(IncomingDetailState state) {
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
          itemCount: state.invoice.details.length,
          itemBuilder: (context, index) {
            final detail = state.invoice.details[index];
            final product = state.products[detail.productID];

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product?.productName ?? 'Unknown Product',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Import Price: \$${detail.importPrice.toStringAsFixed(
                              2)}',
                          style: TextStyle(
                            color: Theme
                                .of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.6),
                          ),
                        ),
                        Text(
                          'Quantity: ${detail.quantity}',
                          style: TextStyle(
                            color: Theme
                                .of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.6),
                          ),
                        ),
                        Text(
                          '\$${detail.subtotal.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
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

  Widget _buildTotalSection(IncomingDetailState state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Total Price',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '\$${state.invoice.totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}