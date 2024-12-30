import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gizmoglobe_client/screens/invoice/sales/sales_add/sales_add_view.dart';
import 'package:gizmoglobe_client/screens/invoice/sales/sales_detail/sales_detail_view.dart';
import 'package:gizmoglobe_client/screens/invoice/sales/sales_edit/sales_edit_view.dart';
import 'package:gizmoglobe_client/objects/invoice_related/sales_invoice.dart';
import 'package:gizmoglobe_client/widgets/general/field_with_icon.dart';
import 'package:gizmoglobe_client/widgets/general/gradient_icon_button.dart';
import 'package:intl/intl.dart';
import '../../../data/firebase/firebase.dart';
import 'sales_screen_cubit.dart';
import 'sales_screen_state.dart';
import 'package:gizmoglobe_client/widgets/general/status_badge.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  static Widget newInstance() => BlocProvider(
        create: (context) => SalesScreenCubit(),
        child: const SalesScreen(),
      );

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  final TextEditingController searchController = TextEditingController();
  final firebase = Firebase();
  SalesScreenCubit get cubit => context.read<SalesScreenCubit>();

  Future<void> _handleViewInvoice(BuildContext contextDialog, SalesInvoice invoice) async {
    // Đóng dialog menu trước
    Navigator.pop(contextDialog);
    cubit.setSelectedIndex(null);

    // Hiển thị loading trong context chính
    if (!mounted) return;
    BuildContext dialogContext = context;
    showDialog(
      context: dialogContext,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      final detailedInvoice = await firebase.getSalesInvoiceWithDetails(invoice.salesInvoiceID!);
      
      if (!mounted) return;
      // Đóng dialog loading
      Navigator.of(dialogContext).pop();
      
      if (!mounted) return;
      // Navigate to detail screen
      await Navigator.push(
        dialogContext,
        MaterialPageRoute(
          builder: (context) => SalesDetailScreen(
            invoice: detailedInvoice,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      // Đóng dialog loading
      Navigator.of(dialogContext).pop();
      
      if (!mounted) return;
      ScaffoldMessenger.of(dialogContext).showSnackBar(
        SnackBar(content: Text('Error loading invoice details: $e')),
      );
    }
  }

  Future<void> _handleEditInvoice(BuildContext contextDialog, SalesInvoice invoice) async {
    // Đóng dialog menu trước
    Navigator.pop(contextDialog);
    cubit.setSelectedIndex(null);

    // Hiển thị loading trong context chính
    if (!mounted) return;
    BuildContext dialogContext = context;
    showDialog(
      context: dialogContext,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      final detailedInvoice = await firebase.getSalesInvoiceWithDetails(invoice.salesInvoiceID!);
      
      if (!mounted) return;
      // Đóng dialog loading
      Navigator.of(dialogContext).pop();
      
      if (!mounted) return;
      // Navigate to edit screen
      final result = await Navigator.push(
        dialogContext,
        MaterialPageRoute(
          builder: (context) => SalesEditScreen(
            invoice: detailedInvoice,
          ),
        ),
      );

      if (result != null && mounted) {
        cubit.updateSalesInvoice(result);
      }
    } catch (e) {
      if (!mounted) return;
      // Đóng dialog loading
      Navigator.of(dialogContext).pop();
      
      if (!mounted) return;
      ScaffoldMessenger.of(dialogContext).showSnackBar(
        SnackBar(content: Text('Error loading invoice details: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SalesScreenCubit, SalesScreenState>(
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
                        hintText: 'Find sales invoices...',
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
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SalesAddScreen(),
                          ),
                        );
                        
                        // Refresh list if new invoice was created
                        if (result != null && mounted) {
                          context.read<SalesScreenCubit>().loadInvoices();
                        }
                      },
                    )
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: state.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : state.invoices.isEmpty
                          ? Center(
                              child: Text(
                                'No sales invoices found',
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground
                                      .withOpacity(0.6),
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: state.invoices.length,
                              itemBuilder: (context, index) {
                                final invoice = state.invoices[index];
                                final isSelected = state.selectedIndex == index;

                                return GestureDetector(
                                  onTap: () async {
                                    BuildContext dialogContext = context;
                                    showDialog(
                                      context: dialogContext,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      },
                                    );

                                    try {
                                      final detailedInvoice = await firebase.getSalesInvoiceWithDetails(invoice.salesInvoiceID!);
                                      
                                      if (!mounted) return;
                                      Navigator.of(dialogContext).pop();
                                      
                                      if (!mounted) return;
                                      await Navigator.push(
                                        dialogContext,
                                        MaterialPageRoute(
                                          builder: (context) => SalesDetailScreen(
                                            invoice: detailedInvoice,
                                          ),
                                        ),
                                      );
                                    } catch (e) {
                                      if (!mounted) return;
                                      Navigator.of(dialogContext).pop();
                                      
                                      if (!mounted) return;
                                      ScaffoldMessenger.of(dialogContext).showSnackBar(
                                        SnackBar(content: Text('Error loading invoice details: $e')),
                                      );
                                    }
                                  },
                                  onLongPress: () {
                                    cubit.setSelectedIndex(index);
                                    showDialog(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          backgroundColor: Colors.transparent,
                                          contentPadding: EdgeInsets.zero,
                                          content: Container(
                                            width: 120,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).cardColor,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ListTile(
                                                  dense: true,
                                                  leading: const Icon(
                                                    Icons.visibility_outlined,
                                                    size: 20,
                                                    color: Colors.white,
                                                  ),
                                                  title: const Text('View'),
                                                  onTap: () => _handleViewInvoice(context, invoice),
                                                ),
                                                if (state.userRole == 'admin')
                                                  ListTile(
                                                    dense: true,
                                                    leading: const Icon(
                                                      Icons.edit_outlined,
                                                      size: 20,
                                                      color: Colors.white,
                                                    ),
                                                    title: const Text('Edit'),
                                                    onTap: () => _handleEditInvoice(context, invoice),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ).then((_) {
                                      cubit.setSelectedIndex(null);
                                    });
                                  },
                                  child: AnimatedOpacity(
                                    duration: const Duration(milliseconds: 200),
                                    opacity: state.selectedIndex == null ||
                                            state.selectedIndex == index
                                        ? 1.0
                                        : 0.3,
                                    child: Container(
                                      margin: const EdgeInsets.only(bottom: 8),
                                      decoration: BoxDecoration(
                                        color: state.selectedIndex == index
                                            ? Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.1)
                                            : Theme.of(context).cardColor,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundColor: Theme.of(context)
                                                  .colorScheme
                                                  .primaryContainer,
                                              child: Icon(
                                                Icons.receipt,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                              ),
                                            ),
                                            const SizedBox(width: 16),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Invoice #${invoice.salesInvoiceID}',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    invoice.customerName ?? 'Unknown Customer',
                                                    style: TextStyle(
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onSurface
                                                          .withOpacity(0.6),
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Wrap(
                                                    spacing: 8,
                                                    runSpacing: 4,
                                                    crossAxisAlignment: WrapCrossAlignment.center,
                                                    children: [
                                                      StatusBadge(status: invoice.paymentStatus),
                                                      StatusBadge(status: invoice.salesStatus),
                                                      Text(
                                                        DateFormat('dd/MM/yyyy').format(invoice.date),
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          color: Theme.of(context)
                                                              .colorScheme
                                                              .onSurface
                                                              .withOpacity(0.6),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              '\$${invoice.totalPrice.toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'paid':
        return Colors.green;
      case 'unpaid':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
