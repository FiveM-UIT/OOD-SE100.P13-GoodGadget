import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:gizmoglobe_client/enums/product_related/category_enum.dart';
import 'package:gizmoglobe_client/objects/manufacturer.dart';

import '../../../../objects/product_related/filter_argument.dart';

class FilterScreenState extends Equatable {
  final FilterArgument filterArgument;
  final int selectedTabIndex;

  const FilterScreenState({
    this.filterArgument = const FilterArgument(),
    this.selectedTabIndex = 0,
  });

  @override
  List<Object?> get props => [filterArgument, selectedTabIndex];

  FilterScreenState copyWith({
    FilterArgument? filterArgument,
    int? selectedTabIndex,
  }) {
    return FilterScreenState(
      filterArgument: filterArgument ?? this.filterArgument,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
    );
  }
}