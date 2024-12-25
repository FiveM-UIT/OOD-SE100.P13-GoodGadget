import 'package:equatable/equatable.dart';
import 'package:gizmoglobe_client/enums/product_related/category_enum.dart';
import 'package:gizmoglobe_client/objects/manufacturer.dart';
import 'package:gizmoglobe_client/objects/product_related/product.dart';

import '../../../enums/processing/sort_enum.dart';

class ProductScreenState extends Equatable {
  final String? searchText;
  final List<Product> productList;
  final List<Manufacturer> manufacturerList;
  final List<Manufacturer> selectedManufacturerList;
  final List<CategoryEnum> selectedCategoryList;
  final String minStock;
  final String maxStock;
  final SortEnum selectedSortOption;
  final int selectedTabIndex;
  final Product? selectedProduct;

  const ProductScreenState({
    this.searchText,
    this.productList = const [],
    this.manufacturerList = const [],
    this.selectedManufacturerList = const [],
    this.selectedCategoryList = const [],
    this.minStock = '',
    this.maxStock = '',
    this.selectedSortOption = SortEnum.releaseLatest,
    this.selectedTabIndex = 0,
    this.selectedProduct,
  });

  @override
  List<Object?> get props => [
    searchText,
    productList,
    manufacturerList,
    selectedManufacturerList,
    selectedCategoryList,
    minStock,
    maxStock,
    selectedSortOption,
    selectedTabIndex,
    selectedProduct,
  ];

  ProductScreenState copyWith({
    String? searchText,
    List<Product>? productList,
    List<Manufacturer>? manufacturerList,
    List<Manufacturer>? selectedManufacturerList,
    List<CategoryEnum>? selectedCategoryList,
    String? minStock,
    String? maxStock,
    SortEnum? selectedSortOption,
    int? selectedTabIndex,
    Product? selectedProduct,
  }) {
    return ProductScreenState(
      searchText: searchText ?? this.searchText,
      productList: productList ?? this.productList,
      manufacturerList: manufacturerList ?? this.manufacturerList,
      selectedManufacturerList: selectedManufacturerList ?? this.selectedManufacturerList,
      selectedCategoryList: selectedCategoryList ?? this.selectedCategoryList,
      minStock: minStock ?? this.minStock,
      maxStock: maxStock ?? this.maxStock,
      selectedSortOption: selectedSortOption ?? this.selectedSortOption,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      selectedProduct: selectedProduct ?? this.selectedProduct,
    );
  }
}