import 'package:equatable/equatable.dart';
import 'package:gizmoglobe_client/enums/product_related/category_enum.dart';
import 'package:gizmoglobe_client/enums/product_related/cpu_enums/cpu_family.dart';
import 'package:gizmoglobe_client/objects/manufacturer.dart';
import 'package:gizmoglobe_client/objects/product_related/product.dart';

import '../../../../enums/processing/sort_enum.dart';
import '../../../../objects/product_related/filter_argument.dart';

class TabState extends Equatable{
  final String searchText;
  final int selectedTabIndex;
  final List<Product> productList;
  final List<Manufacturer> manufacturerList;
  final SortEnum selectedSortOption;
  final Product? selectedProduct;
  final FilterArgument filterArgument;

  const TabState({
    this.searchText = '',
    this.selectedTabIndex = 0,
    this.productList = const [],
    this.manufacturerList = const [],
    this.selectedSortOption = SortEnum.releaseLatest,
    this.selectedProduct,
    this.filterArgument = const FilterArgument(),
  });

  @override
  List<Object?> get props => [
    searchText,
    selectedTabIndex,
    productList,
    manufacturerList,
    selectedSortOption,
    selectedProduct,
    filterArgument,
  ];

  TabState copyWith({
    String? searchText,
    int? selectedTabIndex,
    List<Product>? productList,
    List<Manufacturer>? manufacturerList,
    List<Manufacturer>? selectedManufacturerList,
    SortEnum? selectedSortOption,
    Product? selectedProduct,
    FilterArgument? filterArgument,
  }) {
    return TabState(
      searchText: searchText ?? this.searchText,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      productList: productList ?? this.productList,
      manufacturerList: manufacturerList ?? this.manufacturerList,
      selectedSortOption: selectedSortOption ?? this.selectedSortOption,
      selectedProduct: selectedProduct,
      filterArgument: filterArgument ?? this.filterArgument,
    );
  }
}