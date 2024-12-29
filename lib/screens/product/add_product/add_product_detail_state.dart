import 'package:equatable/equatable.dart';
import 'package:gizmoglobe_client/enums/product_related/category_enum.dart';
import 'package:gizmoglobe_client/objects/manufacturer.dart';
import 'package:gizmoglobe_client/objects/product_related/filter_argument.dart';
import 'package:gizmoglobe_client/objects/product_related/product.dart';
import 'package:gizmoglobe_client/objects/product_related/product_argument.dart';

import '../../../enums/processing/sort_enum.dart';

class AddProductScreenState extends Equatable {
  final ProductArgument? productArgument;

  const AddProductScreenState({
    this.productArgument,
  });

  @override
  List<Object?> get props => [productArgument];

  AddProductScreenState copyWith({
    ProductArgument? productArgument,
  }) {
    return AddProductScreenState(
      productArgument: productArgument ?? this.productArgument,
    );
  }
}