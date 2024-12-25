import 'package:equatable/equatable.dart';
import 'package:gizmoglobe_client/enums/product_related/category_enum.dart';
import 'package:gizmoglobe_client/objects/manufacturer.dart';

class AdvancedFilterSearchState extends Equatable {
  final List<CategoryEnum> selectedCategories;
  final List<Manufacturer> selectedManufacturers;
  final String minStock;
  final String maxStock;

  const AdvancedFilterSearchState({
    this.selectedCategories = const [],
    this.selectedManufacturers = const [],
    this.minStock = '',
    this.maxStock = '',
  });

  @override
  List<Object?> get props => [selectedCategories, selectedManufacturers, minStock, maxStock];

  AdvancedFilterSearchState copyWith({
    List<CategoryEnum>? selectedCategories,
    List<Manufacturer>? selectedManufacturers,
    String? minStock,
    String? maxStock,
  }) {
    return AdvancedFilterSearchState(
      selectedCategories: selectedCategories ?? this.selectedCategories,
      selectedManufacturers: selectedManufacturers ?? this.selectedManufacturers,
      minStock: minStock ?? this.minStock,
      maxStock: maxStock ?? this.maxStock,
    );
  }
}