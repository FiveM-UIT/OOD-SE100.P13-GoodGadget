import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gizmoglobe_client/screens/product/product_detail/product_detail_cubit.dart';
import 'package:gizmoglobe_client/screens/product/product_detail/product_detail_state.dart';
import 'package:gizmoglobe_client/widgets/general/gradient_icon_button.dart';

import '../../../objects/product_related/cpu.dart';
import '../../../objects/product_related/drive.dart';
import '../../../objects/product_related/gpu.dart';
import '../../../objects/product_related/mainboard.dart';
import '../../../objects/product_related/product.dart';
import '../../../objects/product_related/psu.dart';
import '../../../objects/product_related/ram.dart';


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
              // Image using Image.network  (Replace with actual image URL)
              SizedBox(
                height: 200,
                child: Image.network('https://ramleather.vn/wp-content/uploads/2022/07/woocommerce-placeholder-200x200-1.jpg'), // Placeholder image
              ),
              SizedBox(height: 16),
              Text('${product.productName}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              Text('Category: ${product.category.toString().split('.').last}', style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),
              Text('Manufacturer: ${product.manufacturer.manufacturerName}'),
              SizedBox(height: 10),
              Text('Stock: ${product.stock}'),
              SizedBox(height: 10),
              Text('Release Date: ${product.release}'),
              SizedBox(height: 16),
              Text('Status: ${product.status.toString()}'),
              SizedBox(height: 16),
              ..._buildProductSpecificDetails(context, product),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildProductSpecificDetails(BuildContext context, Product product) {
    List<Widget> details = [];
    if (product is CPU) {
      details.add(Text('Family: ${product.family}'));
      details.add(Text('Core: ${product.core}'));
      details.add(Text('Thread: ${product.thread}'));
      details.add(Text('Clock Speed: ${product.clockSpeed} GHz'));
    } else if (product is GPU) {
      details.add(Text('Series: ${product.series}'));
      details.add(Text('Capacity: ${product.capacity}'));
      details.add(Text('Bus: ${product.bus}'));
      details.add(Text('Clock Speed: ${product.clockSpeed} GHz'));
    } else if (product is RAM) {
      details.add(Text('Bus: ${product.bus}'));
      details.add(Text('Capacity: ${product.capacity}'));
      details.add(Text('Type: ${product.ramType}'));
    } else if (product is Drive) {
      details.add(Text('Type: ${product.type}'));
      details.add(Text('Capacity: ${product.capacity}'));
    } else if (product is Mainboard) {
      details.add(Text('Form Factor: ${product.formFactor}'));
      details.add(Text('Series: ${product.series}'));
      details.add(Text('Compatibility: ${product.compatibility}'));
    } else if (product is PSU) {
      details.add(Text('Wattage: ${product.wattage} W'));
      details.add(Text('Efficiency: ${product.efficiency}'));
      details.add(Text('Modular: ${product.modular}'));
    }
    return details;
  }
}