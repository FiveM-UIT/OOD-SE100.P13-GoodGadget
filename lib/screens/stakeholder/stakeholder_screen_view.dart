// lib/screens/main/main_screen/main_screen_view.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gizmoglobe_client/objects/product_related/product.dart';
import 'package:gizmoglobe_client/screens/main/main_screen/main_screen_cubit.dart';
import 'package:gizmoglobe_client/screens/stakeholder/stakeholder_screen_cubit.dart';
import 'package:gizmoglobe_client/widgets/general/gradient_icon_button.dart';
import '../../../widgets/general/selectable_gradient_icon.dart';


class StakeholderScreen extends StatefulWidget {
  const StakeholderScreen({super.key});

  static Widget newInstance() => BlocProvider(
        create: (context) => StakeholderScreenCubit(),
        child: const StakeholderScreen(),
      );

  @override
  State<StakeholderScreen> createState() => _StakeholderScreenState();
}

class _StakeholderScreenState extends State<StakeholderScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('Stakeholder'),
        ),
        body: const SafeArea(
          child: SizedBox.expand(),
        ),
      ),
    );
  }
}