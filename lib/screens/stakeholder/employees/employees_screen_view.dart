import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gizmoglobe_client/widgets/general/field_with_icon.dart';
import 'package:gizmoglobe_client/widgets/general/gradient_icon_button.dart';
import 'employees_screen_cubit.dart';

class EmployeesScreen extends StatefulWidget {
  const EmployeesScreen({super.key});

  static Widget newInstance() => BlocProvider(
        create: (context) => EmployeesScreenCubit(),
        child: const EmployeesScreen(),
      );

  @override
  State<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
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
                  hintText: 'Find employees...',
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
