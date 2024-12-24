import 'package:equatable/equatable.dart';
import 'package:gizmoglobe_client/enums/product_related/category_enum.dart';
import 'package:gizmoglobe_client/objects/manufacturer.dart';
import 'package:gizmoglobe_client/objects/product_related/product.dart';

import '../../../enums/processing/sort_enum.dart';

class ProductDetailState extends Equatable {
  final Product product;

  const ProductDetailState({
    required this.product,
  });

  @override
  List<Object?> get props => [
    product,
  ];

  ProductDetailState copyWith({
    Product? product,
  }) {
    return ProductDetailState(
      product: product ?? this.product,
    );
  }
}