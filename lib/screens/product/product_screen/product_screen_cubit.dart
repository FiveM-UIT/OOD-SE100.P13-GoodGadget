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
    applyFilters();
  }

  void updateSelectedTabIndex(int index) {
    emit(state.copyWith(selectedTabIndex: index));
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
    applyFilters();
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
      final matchesManufacturer = state.selectedManufacturerList.contains(product.manufacturer);
      final bool matchesCategory;

      switch (state.selectedTabIndex) {
        case 1:
          matchesCategory = product.category == CategoryEnum.ram;
          break;
        case 2:
          matchesCategory = product.category == CategoryEnum.cpu;
          break;
        case 3:
          matchesCategory = product.category == CategoryEnum.psu;
          break;
        case 4:
          matchesCategory = product.category == CategoryEnum.gpu;
          break;
        case 5:
          matchesCategory = product.category == CategoryEnum.drive;
          break;
        case 6:
          matchesCategory = product.category == CategoryEnum.mainboard;
          break;
        default:
          matchesCategory = state.selectedCategoryList.contains(product.category);
      }
      return matchesSearchText && matchesManufacturer && matchesCategory;
    }).toList();

    switch (state.selectedSortOption) {
      case SortEnum.releaseLatest:
        filteredProducts.sort((a, b) => b.release.compareTo(a.release));
        break;
      case SortEnum.releaseOldest:
        filteredProducts.sort((a, b) => a.release.compareTo(b.release));
        break;
      case SortEnum.stockHighest:
        filteredProducts.sort((a, b) => b.stock.compareTo(a.stock));
        break;
      case SortEnum.stockLowest:
        filteredProducts.sort((a, b) => a.stock.compareTo(b.stock));
        break;
      case SortEnum.salesHighest:
        filteredProducts.sort((a, b) => b.sales.compareTo(a.sales));
        break;
      case SortEnum.salesLowest:
        filteredProducts.sort((a, b) => a.sales.compareTo(b.sales));
    }

    emit(state.copyWith(productList: filteredProducts));
  }
}