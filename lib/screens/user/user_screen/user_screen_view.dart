import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gizmoglobe_client/widgets/general/gradient_text.dart';
import '../../../data/firebase/firebase.dart';
import '../../../widgets/general/invisible_gradient_button.dart';
import '../../../widgets/general/vertical_icon_button.dart';
import 'user_screen_cubit.dart';
import 'user_screen_state.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  static Widget newInstance() => BlocProvider(
    create: (context) => UserScreenCubit(),
    child: const UserScreen(),
  );

  @override
  State<UserScreen> createState() => _UserScreen();
}

class _UserScreen extends State<UserScreen> {
  UserScreenCubit get cubit => context.read<UserScreenCubit>();

  @override
  void initState() {
    super.initState();
    cubit.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: 'pushProducts',
              onPressed: () async {
                try {
                  await pushProductSamplesToFirebase();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Đã đẩy dữ liệu sản phẩm mẫu thành công')),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Lỗi khi đẩy sản phẩm: $e')),
                    );
                  }
                }
              },
              child: const Icon(Icons.shopping_cart),
            ),
            const SizedBox(height: 16),
            FloatingActionButton(
              heroTag: 'pushCustomers',
              onPressed: () async {
                try {
                  await Firebase().pushCustomerSampleData();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Sample data updated successfully'),
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error updating sample data: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              child: const Icon(Icons.person),
            ),
          ],
        ),
        body: Center(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
                color: Theme.of(context).colorScheme.primaryContainer,
                child: BlocBuilder<UserScreenCubit, UserScreenState>(
                  builder: (context, state) {
                    return Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GradientText(
                                text: state.username,
                                fontSize: 24.0,
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                state.email,
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Theme.of(context).colorScheme.onSurface,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            FontAwesomeIcons.penToSquare,
                            size: 32.0,
                          ),
                          color: Theme.of(context).colorScheme.onSurface,
                          onPressed: () {
                            // Handle edit action
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 8.0),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const GradientText(
                      text: "My orders",
                      fontSize: 24.0,
                    ),
                    const SizedBox(height: 8.0),

                    Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: VerticalIconButton(
                              onPress: () {
                                // Handle To ship action
                              },
                              icon: FontAwesomeIcons.box,
                              text: 'To ship',
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),

                        Expanded(
                          child: Center(
                            child: VerticalIconButton(
                              onPress: () {
                                // Handle To receive action
                              },
                              icon: Icons.local_shipping,
                              text: 'To receive',
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),

                        Expanded(
                          child: Center(
                            child: VerticalIconButton(
                              onPress: () {
                                // Handle Completed action
                              },
                              icon: FontAwesomeIcons.circleCheck,
                              text: 'Completed',
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12.0),

              Container(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const GradientText(
                          text: "Wish list",
                          fontSize: 24.0,
                        ),
                        InvisibleGradientButton(
                          onPress: () {
                            // Handle see all action
                          },
                          suffixIcon: Icons.chevron_right,
                          text: 'See all',
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Container(
                      height: 100.0,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8.0),

              Container(
                padding: const EdgeInsets.only(left: 16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const GradientText(
                          text: "Re-purchase",
                          fontSize: 24.0,
                        ),
                        InvisibleGradientButton(
                          onPress: () {
                            // Handle see all action
                          },
                          suffixIcon: Icons.chevron_right,
                          text: 'See all',
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Container(
                      height: 100.0,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8.0),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const GradientText(
                      text: "Account",
                      fontSize: 24.0,
                    ),
                    const SizedBox(height: 8.0),

                    SizedBox(
                      height: 24.0,
                      child: TextButton(
                        onPressed: () {
                          // Handle Account action
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.fromLTRB(8, 0, 0, 0)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "My addresses",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontFamily: 'Montserrat',
                                fontSize: 16.0,
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8,),

                    SizedBox(
                      height: 24.0,
                      child: TextButton(
                        onPressed: () {
                          // Handle Account action
                        },
                        style: TextButton.styleFrom(
                            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Change password",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontFamily: 'Montserrat',
                                fontSize: 16.0,
                              ),
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8.0),

              InvisibleGradientButton(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                onPress: () {
                  cubit.logOut(context);
                },
                suffixIcon: Icons.logout,
                text: 'Log out',
              ),
            ],
          ),
        ),
      ),
    );
  }
}