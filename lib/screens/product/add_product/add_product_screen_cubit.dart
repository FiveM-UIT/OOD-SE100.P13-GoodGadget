import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gizmoglobe_client/data/database/database.dart';
import 'package:gizmoglobe_client/objects/product_related/product.dart';
import 'package:gizmoglobe_client/objects/product_related/product_argument.dart';
import 'package:gizmoglobe_client/screens/product/product_detail/product_detail_state.dart';

import '../../../enums/product_related/category_enum.dart';
import '../../../objects/product_related/cpu.dart';
import '../../../objects/product_related/drive.dart';
import '../../../objects/product_related/gpu.dart';
import '../../../objects/product_related/mainboard.dart';
import '../../../objects/product_related/psu.dart';
import '../../../objects/product_related/ram.dart';
import 'add_product_detail_state.dart';

class AddProductScreenCubit extends Cubit<AddProductScreenState> {
  AddProductScreenCubit() : super(const AddProductScreenState()) {
    initialize();
  }

  void initialize() {
    emit(state.copyWith(productArgument: ProductArgument(sales: 0, productName: 'Unknown', release: DateTime.now())));
  }

  void updateProductArgument(ProductArgument productArgument) {
    emit(state.copyWith(productArgument: productArgument));
  }

  void addProduct() {
    Product product = state.productArgument!.buildProduct();
    Firebase().addProduct(product);
  }
}