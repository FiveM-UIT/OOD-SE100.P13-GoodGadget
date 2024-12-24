import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gizmoglobe_client/screens/product/product_screen/product_screen_cubit.dart';
import 'package:gizmoglobe_client/screens/product/product_screen/product_screen_state.dart';
import 'package:gizmoglobe_client/widgets/general/app_logo.dart';
import 'package:gizmoglobe_client/widgets/general/checkbox_button.dart';
import 'package:gizmoglobe_client/widgets/general/gradient_icon_button.dart';
import 'package:gizmoglobe_client/widgets/general/field_with_icon.dart';
import '../../../enums/processing/sort_enum.dart';
import '../../../enums/product_related/category_enum.dart';
import '../../../widgets/filter/advanced_filter_search/advanced_filter_search_view.dart';
import '../../../widgets/general/app_text_style.dart';
import '../product_detail/product_detail_view.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  static Widget newInstance() =>
      BlocProvider(
        create: (context) => ProductScreenCubit(),
        child: const ProductScreen(),
      );

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> with SingleTickerProviderStateMixin {
  late TextEditingController searchController;
  late FocusNode searchFocusNode;
  late TabController tabController;
  ProductScreenCubit get cubit => context.read<ProductScreenCubit>();

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    searchFocusNode = FocusNode();
    tabController = TabController(length: CategoryEnum.values.length + 1, vsync: this);
    cubit.initialize();
  }

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: FieldWithIcon(
            height: 40,
            controller: searchController,
            focusNode: searchFocusNode,
            hintText: 'Find your item',
            fillColor: Theme.of(context).colorScheme.surface,
            prefixIcon: Icon(
              FontAwesomeIcons.magnifyingGlass,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            onChanged: (value) {
              cubit.updateSearchText(value);
            },
          ),

          bottom: TabBar(
            controller: tabController,
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
            labelPadding: const EdgeInsets.symmetric(horizontal: 16),
            indicatorColor: Theme.of(context).colorScheme.primary,
            tabAlignment: TabAlignment.start,
            isScrollable: true,
            indicator: const BoxDecoration(),
            tabs: [
              const Tab(text: 'All'),
              ...CategoryEnum.values.map((category) => Tab(
                text: category.toString().split('.').last,
              )),
            ],
            onTap: (index) {
              cubit.updateSelectedTabIndex(index);
            },
          ),
        ),

        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              BlocBuilder<ProductScreenCubit, ProductScreenState>(
                builder: (context, state) {
                  return Row(
                    children: [
                      const Text(
                        'Sort by: ',
                        style: AppTextStyle.smallText,
                      ),
                      const SizedBox(width: 8),

                      DropdownButton<SortEnum>(
                        value: state.selectedSortOption,
                        icon: const Icon(Icons.keyboard_arrow_down),
                        onChanged: (SortEnum? newValue) {
                          if (newValue != null && newValue != state.selectedSortOption) {
                            cubit.updateSortOption(newValue);
                          }
                        },
                        items: SortEnum.values.map<DropdownMenuItem<SortEnum>>((SortEnum value) {
                          return DropdownMenuItem<SortEnum>(
                            value: value,
                            child: Row(
                              children: [
                                Text(value.toString()),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      const Spacer(),

                      Center(
                        child: GradientIconButton(
                          icon: Icons.filter_list_alt,
                          iconSize: 28,
                          onPressed: () async {
                            final FilterSearchArguments arguments = FilterSearchArguments(
                              selectedCategories: state.selectedCategoryList,
                              selectedManufacturers: state.selectedManufacturerList,
                              minPrice: state.minPrice,
                              maxPrice: state.maxPrice,
                            );

                            final result = await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    AdvancedFilterSearchScreen.newInstance(
                                      arguments: arguments,
                                    ),
                              ),
                            );

                            if (result is FilterSearchArguments) {
                              cubit.updateFilter(
                                selectedCategoryList: result.selectedCategories,
                                selectedManufacturerList: result.selectedManufacturers,
                                minPrice: result.minPrice,
                                maxPrice: result.maxPrice,
                              );
                              cubit.applyFilters();
                            }
                          },
                        ),
                      )
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),

              Expanded(
                child: BlocBuilder<ProductScreenCubit, ProductScreenState>(
                  builder: (context, state) {
                    if (state.productList.isEmpty) {
                      return const Center(
                        child: Text('No products found'),
                      );
                    }
                    return ListView.builder(
                      itemCount: state.productList.length,
                      itemBuilder: (context, index) {
                        final product = state.productList[index];
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ProductDetailScreen.newInstance(product),
                              ),
                            );
                          },
                          child: ListTile(
                            title: Text(product.productName),
                            subtitle: Text('đ${product.stock}'),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}