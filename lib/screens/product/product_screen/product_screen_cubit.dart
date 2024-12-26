import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gizmoglobe_client/enums/product_related/category_enum.dart';
import 'package:gizmoglobe_client/objects/manufacturer.dart';
import 'package:gizmoglobe_client/objects/product_related/product.dart';
import 'package:gizmoglobe_client/data/database/database.dart';
import 'package:gizmoglobe_client/screens/product/product_screen/product_screen_state.dart';

import '../../../enums/processing/sort_enum.dart';

class ProductScreenCubit extends Cubit<ProductScreenState> {
  ProductScreenCubit() : super(const ProductScreenState());

  void initialize() {
    emit(state.copyWith(
      productList: Database().productList,
      manufacturerList: Database().manufacturerList,
    ));
  }

  void updateSelectedTabIndex(int index) {
    emit(state.copyWith(selectedTabIndex: index));
  }

  void updateSearchText(String? searchText) {
    emit(state.copyWith(searchText: searchText));
  }

  void updateSortOption(SortEnum selectedOption) {
    emit(state.copyWith(selectedSortOption: selectedOption));
  }
}