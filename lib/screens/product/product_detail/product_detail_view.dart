import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gizmoglobe_client/screens/product/product_detail/product_detail_cubit.dart';
import 'package:gizmoglobe_client/screens/product/product_detail/product_detail_state.dart';
import 'package:gizmoglobe_client/widgets/general/gradient_icon_button.dart';

import '../../../objects/product_related/product.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  static Widget newInstance(Product product) =>
      BlocProvider(
        create: (context) => ProductDetailCubit(product),
        child: ProductDetailScreen(product: product),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image using Image.network
              SizedBox(
                height: 200,
                child: Image.network('https://media.istockphoto.com/id/1324356458/vector/picture-icon-photo-frame-symbol-landscape-sign-photograph-gallery-logo-web-interface-and.jpg?s=612x612&w=0&k=20&c=ZmXO4mSgNDPzDRX-F8OKCfmMqqHpqMV6jiNi00Ye7rE=')),
              SizedBox(height: 16),
              Text('${product.productName}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              Text('Category: ${product.category.toString().split('.').last}', style: TextStyle(fontSize: 16, )),
              SizedBox(height: 10),
              Text('Manufacturer: ${product.manufacturer.manufacturerName}'),
              SizedBox(height: 10),
              Text('Stock: ${product.stock}'),
              // SizedBox(height: 10),
              // Text('Price: ${product.price}'),
              SizedBox(height: 10),
              Text('Release Date: ${product.release}'),
              SizedBox(height: 16),
              Text('Status: ${product.status.toString()}'),
              // Add more details as needed...
            ],
          ),
        ),
      ),
    );
  }
}