import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gizmoglobe_client/widgets/general/field_with_icon.dart';
import 'package:gizmoglobe_client/widgets/general/gradient_icon_button.dart';
import 'package:gizmoglobe_client/screens/invoice/incoming/incoming_detail/incoming_detail_view.dart';
import 'incoming_screen_cubit.dart';
import 'incoming_screen_state.dart';

class IncomingScreen extends StatefulWidget {
  const IncomingScreen({super.key});

  static Widget newInstance() => BlocProvider(
        create: (context) => IncomingScreenCubit(),
        child: const IncomingScreen(),
      );

  @override
  State<IncomingScreen> createState() => _IncomingScreenState();
}

class _IncomingScreenState extends State<IncomingScreen> {
  final TextEditingController searchController = TextEditingController();
  IncomingScreenCubit get cubit => context.read<IncomingScreenCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IncomingScreenCubit, IncomingScreenState>(
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
                        hintText: 'Find incoming invoices...',
                        fillColor: Theme.of(context).colorScheme.surface,
                        onChanged: (value) {
                          cubit.searchInvoices(value);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    GradientIconButton(
                      icon: Icons.add,
                      iconSize: 32,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => IncomingAddScreen.newInstance(),
                          ),
                        ).then((_) => cubit.loadInvoices());
                      },
                    )
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: state.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          itemCount: state.invoices.length,
                          itemBuilder: (context, index) {
                            final invoice = state.invoices[index];
                            return Card(
                              child: ListTile(
                                title: Text('Hóa đơn #${invoice.incomingInvoiceID}'),
                                subtitle: Text(
                                  'Ngày: ${invoice.date.toString().split(' ')[0]}\n'
                                  'Tổng tiền: ${invoice.totalPrice.toStringAsFixed(2)} VNĐ',
                                ),
                                trailing: Text('Trạng thái: ${invoice.status.getName()}'),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => IncomingDetailScreen.newInstance(
                                        invoiceId: invoice.incomingInvoiceID!,
                                      ),
                                    ),
                                  ).then((_) => cubit.loadInvoices());
                                },
                              ),
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
