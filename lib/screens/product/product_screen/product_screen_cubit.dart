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
      selectedManufacturerList: Database().manufacturerList,
      selectedCategoryList: CategoryEnum.values.toList(),
    ));

    updateSearchText(state.searchText);
    applyFilters();
  }

  void updateFilter({
    List<CategoryEnum>? selectedCategoryList,
    List<Manufacturer>? selectedManufacturerList,
    String? minPrice,
    String? maxPrice,
  }) {
    emit(state.copyWith(
      selectedCategoryList: selectedCategoryList,
      selectedManufacturerList: selectedManufacturerList,
      minPrice: minPrice,
      maxPrice: maxPrice,
    ));
  }

  void updateSearchText(String? searchText) {
    emit(state.copyWith(searchText: searchText));
  }

  void updateSortOption(SortEnum selectedOption) {
    emit(state.copyWith(selectedSortOption: selectedOption));
    applyFilters();
  }

  void applyFilters() {
    final double min = double.tryParse(state.minPrice) ?? 0;
    final double max = double.tryParse(state.maxPrice) ?? double.infinity;

    final filteredProducts = Database().productList.where((product) {
      final matchesSearchText = state.searchText == null || product.productName.toLowerCase().contains(state.searchText!.toLowerCase());
      final matchesCategory = state.selectedCategoryList.contains(product.category);
      final matchesManufacturer = state.selectedManufacturerList.contains(product.manufacturer);
      final matchesPrice = (product.price >= min) && (product.price <= max);
      return matchesSearchText & matchesCategory && matchesManufacturer && matchesPrice;
    }).toList();

    switch (state.selectedSortOption) {
      case SortEnum.releaseLatest:
        //filteredProducts.sort((a, b) => b.releaseDate.compareTo(a.releaseDate));
        break;
      case SortEnum.releaseOldest:
        //filteredProducts.sort((a, b) => a.releaseDate.compareTo(b.releaseDate));
        break;
      case SortEnum.stockHighest:
        //filteredProducts.sort((a, b) => b.stock.compareTo(a.stock));
        break;
      case SortEnum.stockLowest:
        //filteredProducts.sort((a, b) => a.stock.compareTo(b.stock));
        break;
      case SortEnum.salesHighest:
        //filteredProducts.sort((a, b) => b.sales.compareTo(a.sales));
        break;
      case SortEnum.salesLowest:
        //filteredProducts.sort((a, b) => a.sales.compareTo(b.sales));
    }

    emit(state.copyWith(productList: filteredProducts));
  }
}