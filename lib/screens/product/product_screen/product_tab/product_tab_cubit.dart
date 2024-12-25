import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gizmoglobe_client/enums/product_related/category_enum.dart';
import 'package:gizmoglobe_client/objects/manufacturer.dart';
import 'package:gizmoglobe_client/objects/product_related/product.dart';
import 'package:gizmoglobe_client/data/database/database.dart';
import 'package:gizmoglobe_client/screens/product/product_screen/product_screen_state.dart';

import '../../../../enums/processing/sort_enum.dart';
import '../../../../objects/product_related/filter_argument.dart';
import 'product_tab_state.dart';

abstract class TabCubit extends Cubit<TabState> {
  TabCubit() : super(const TabState());

  void initialize(FilterArgument filter) {
    emit(state.copyWith(filterArgument: filter.copyWith(manufacturerList: Database().manufacturerList), manufacturerList: Database().manufacturerList));
    applyFilters();
  }

  void updateFilter({
    FilterArgument? filter,
  }) {
    emit(state.copyWith(
      filterArgument: filter,
    ));
  }

  void updateSearchText(String? searchText) {
    emit(state.copyWith(searchText: searchText));
    applyFilters();
  }

  void updateTabIndex(int index) {
    emit(state.copyWith(filterArgument: state.filterArgument.copyWith(categoryList: [CategoryEnum.values[index]])));
    applyFilters();
  }

  void updateSortOption(SortEnum selectedOption) {
    emit(state.copyWith(selectedSortOption: selectedOption));
    applyFilters();
  }

  void setSelectedProduct(Product? product) {
    emit(state.copyWith(selectedProduct: product));
  }

  void applyFilters() {
    print('Apply filter');
    final double minStock = double.tryParse(state.filterArgument.minStock) ?? 0;
    final double maxStock = double.tryParse(state.filterArgument.maxStock) ?? double.infinity;

    final filteredProducts = Database().productList.where((product) {
      final matchesSearchText = product.productName.toLowerCase().contains(state.searchText.toLowerCase());
      final matchesManufacturer = state.filterArgument.manufacturerList.contains(product.manufacturer);
      final matchesStock = (product.stock >= minStock) && (product.stock <= maxStock);

      final bool matchesCategory;
      final index = getIndex();
      switch (index) {
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
          matchesCategory = state.filterArgument.categoryList.contains(product.category);
      }
       return matchesSearchText && matchesManufacturer && matchesCategory && matchesStock;
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

  int getIndex();
}

class AllTabCubit extends TabCubit {
  @override
  int getIndex() {
    return 0;
  }
}

class RamTabCubit extends TabCubit {
  @override
  int getIndex() {
    return 1;
  }
}

class CpuTabCubit extends TabCubit {
  @override
  int getIndex() {
    return 2;
  }
}

class PsuTabCubit extends TabCubit {
  @override
  int getIndex() {
    return 3;
  }
}

class GpuTabCubit extends TabCubit {
  @override
  int getIndex() {
    return 4;
  }
}

class DriveTabCubit extends TabCubit {
  @override
  int getIndex() {
    return 5;
  }
}

class MainboardTabCubit extends TabCubit {
  @override
  int getIndex() {
    return 6;
  }
}