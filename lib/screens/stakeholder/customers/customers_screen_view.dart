import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gizmoglobe_client/widgets/general/field_with_icon.dart';
import 'package:gizmoglobe_client/widgets/general/gradient_icon_button.dart';
import 'customers_screen_cubit.dart';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  static Widget newInstance() => BlocProvider(
        create: (context) => CustomersScreenCubit(),
        child: const CustomersScreen(),
      );

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: FieldWithIcon(
                  controller: searchController,
                  hintText: 'Find customers...',
                  fillColor: Theme.of(context).colorScheme.surface,
                  onChange: (value) {
                    // TODO: Implement search
                  },
                ),
              ),
              const SizedBox(width: 8),
              GradientIconButton(
                icon: FontAwesomeIcons.magnifyingGlass,
                iconSize: 32,
                onPressed: () {
                  // TODO: Implement search
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
