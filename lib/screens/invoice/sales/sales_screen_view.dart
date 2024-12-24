import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gizmoglobe_client/widgets/general/field_with_icon.dart';
import 'package:gizmoglobe_client/widgets/general/gradient_icon_button.dart';
import 'sales_screen_cubit.dart';
import 'sales_screen_state.dart';

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
  SalesScreenCubit get cubit => context.read<SalesScreenCubit>();

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
                      onPressed: () {
                        // TODO: Implement add sales invoice
                      },
                    )
                  ],
                ),

              ],
            ),
          ),
        );
      },
    );
  }
}
