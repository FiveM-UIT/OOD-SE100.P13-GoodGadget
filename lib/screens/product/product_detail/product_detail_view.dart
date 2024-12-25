import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gizmoglobe_client/screens/product/product_detail/product_detail_cubit.dart';
import 'package:gizmoglobe_client/screens/product/product_detail/product_detail_state.dart';
import 'package:gizmoglobe_client/screens/product/product_screen/product_screen_cubit.dart';
import 'package:gizmoglobe_client/screens/product/product_screen/product_screen_state.dart';
import 'package:gizmoglobe_client/widgets/general/app_logo.dart';
import 'package:gizmoglobe_client/widgets/general/checkbox_button.dart';
import 'package:gizmoglobe_client/widgets/general/gradient_icon_button.dart';
import 'package:gizmoglobe_client/widgets/general/field_with_icon.dart';
import '../../../enums/processing/sort_enum.dart';
import '../../../enums/product_related/category_enum.dart';
import '../../../objects/product_related/product.dart';
import '../../../widgets/general/app_text_style.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  static Widget newInstance(Product product) =>
      BlocProvider(
        create: (context) => ProductDetailCubit(product),
        child: ProductDetailScreen(product: product),
      );

  @override
  State<ProductDetailScreen> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetailScreen> {
  ProductDetailCubit get cubit => context.read<ProductDetailCubit>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: GradientIconButton(
            icon: Icons.arrow_back,
            onPressed: () {
              Navigator.pop(context);
            },
            fillColor: Colors.transparent,
          ),

          title: BlocBuilder<ProductDetailCubit, ProductDetailState>(
            builder: (context, state) {
              return Text(state.product.productName);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children:[
            ],
          ),
        ),
      ),
    );
  }
}