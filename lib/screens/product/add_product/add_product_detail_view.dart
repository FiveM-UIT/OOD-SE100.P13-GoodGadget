import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gizmoglobe_client/screens/product/product_detail/product_detail_cubit.dart';
import 'package:gizmoglobe_client/screens/product/product_detail/product_detail_state.dart';
import 'package:gizmoglobe_client/widgets/general/app_text_style.dart';
import 'package:gizmoglobe_client/widgets/general/gradient_icon_button.dart';
import 'package:gizmoglobe_client/widgets/general/gradient_text.dart';
import 'package:intl/intl.dart';

import '../../../data/database/database.dart';
import '../../../enums/product_related/category_enum.dart';
import '../../../enums/product_related/cpu_enums/cpu_family.dart';
import '../../../enums/product_related/drive_enums/drive_capacity.dart';
import '../../../enums/product_related/drive_enums/drive_type.dart';
import '../../../enums/product_related/gpu_enums/gpu_bus.dart';
import '../../../enums/product_related/gpu_enums/gpu_capacity.dart';
import '../../../enums/product_related/gpu_enums/gpu_series.dart';
import '../../../enums/product_related/mainboard_enums/mainboard_compatibility.dart';
import '../../../enums/product_related/mainboard_enums/mainboard_form_factor.dart';
import '../../../enums/product_related/mainboard_enums/mainboard_series.dart';
import '../../../enums/product_related/product_status_enum.dart';
import '../../../enums/product_related/psu_enums/psu_efficiency.dart';
import '../../../enums/product_related/psu_enums/psu_modular.dart';
import '../../../enums/product_related/ram_enums/ram_bus.dart';
import '../../../enums/product_related/ram_enums/ram_capacity_enum.dart';
import '../../../enums/product_related/ram_enums/ram_type.dart';
import '../../../objects/manufacturer.dart';
import '../../../objects/product_related/cpu.dart';
import '../../../objects/product_related/drive.dart';
import '../../../objects/product_related/gpu.dart';
import '../../../objects/product_related/mainboard.dart';
import '../../../objects/product_related/product.dart';
import '../../../objects/product_related/psu.dart';
import '../../../objects/product_related/ram.dart';
import '../../../widgets/general/field_with_icon.dart';
import '../../../widgets/general/gradient_dropdown.dart';
import 'add_product_detail_state.dart';
import 'add_product_screen_cubit.dart';


class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  static Widget newInstance() =>
      BlocProvider(
        create: (context) => AddProductScreenCubit(),
        child: const AddProductScreen(),
      );


  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  AddProductScreenCubit get cubit => context.read<AddProductScreenCubit>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: GradientIconButton(
          icon: Icons.chevron_left,
          onPressed: () => Navigator.pop(context),
          fillColor: Colors.transparent,
        ),
        title: const GradientText(text: 'Add Product'),
        actions: [
          TextButton(
          onPressed: () {
              cubit.addProduct();
              Navigator.pop(context);
            },
            child: const Text('Save', style: AppTextStyle.regularText),
          )
        ],
      ),
      body: BlocBuilder<AddProductScreenCubit, AddProductScreenState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Image Section - smaller size
                Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                  ),
                  child: Image.network(
                    'https://ramleather.vn/wp-content/uploads/2022/07/woocommerce-placeholder-200x200-1.jpg',
                    fit: BoxFit.contain,
                  ),
                ),

                // Product Input Section
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildInputWidget<String>(
                        'Product Name',
                        state.productArgument?.productName,
                            (value) {
                         cubit.updateProductArgument(state.productArgument!.copyWith(productName: value));
                        },
                      ),
                      buildInputWidget<double>(
                        'Import Price',
                        state.productArgument?.importPrice,
                            (value) {
                          cubit.updateProductArgument(state.productArgument!.copyWith(importPrice: value));
                        },
                      ),
                      buildInputWidget<double>(
                        'Selling Price',
                        state.productArgument?.sellingPrice,
                            (value) {
                          cubit.updateProductArgument(state.productArgument!.copyWith(sellingPrice: value));
                        },
                      ),
                      buildInputWidget<double>(
                        'Discount',
                        state.productArgument?.discount,
                            (value) {
                          cubit.updateProductArgument(state.productArgument!.copyWith(discount: value));
                        },
                      ),
                      buildInputWidget<DateTime>(
                        'Release Date',
                        state.productArgument?.release ?? DateTime.now(),
                            (value) {
                          cubit.updateProductArgument(state.productArgument!.copyWith(release: value));
                        },
                      ),
                      buildInputWidget<int>(
                        'Stock',
                        state.productArgument?.stock,
                            (value) {
                          final newStatus = value! > 0 ? ProductStatusEnum.active : ProductStatusEnum.outOfStock;
                          cubit.updateProductArgument(state.productArgument!.copyWith(stock: value, status: newStatus));
                        },
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text('Manufacturer', style: AppTextStyle.smallText),
                          DropdownSearch<Manufacturer>(
                            items: (String filter, dynamic infiniteScrollProps) => Database().manufacturerList,
                            compareFn: (Manufacturer? m1, Manufacturer? m2) => m1?.manufacturerID == m2?.manufacturerID,
                            itemAsString: (Manufacturer m) => m.manufacturerName,
                            onChanged: (value) {
                              cubit.updateProductArgument(state.productArgument!.copyWith(manufacturer: value));
                            },
                            selectedItem: state.productArgument?.manufacturer,
                            decoratorProps: DropDownDecoratorProps(
                              decoration: InputDecoration(
                                hintText: 'Select Manufacturer',
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text('Status', style: AppTextStyle.smallText),
                          BlocBuilder<AddProductScreenCubit, AddProductScreenState>(
                            builder: (context, state) {
                              final status = (state.productArgument?.stock ?? 0) > 0
                                  ? ProductStatusEnum.active
                                  : ProductStatusEnum.outOfStock;

                              return Text(
                                status.toString(),
                                style: AppTextStyle.smallText,
                              );
                            },
                          ),
                        ],
                      ),

                      buildInputWidget<CategoryEnum>(
                        'Category',
                        state.productArgument?.category,
                            (value) {
                          cubit.updateProductArgument(state.productArgument!.copyWith(category: value));
                        },
                        CategoryEnum.values,
                      ),

                      BlocBuilder<AddProductScreenCubit, AddProductScreenState>(
                        builder: (context, state) {
                          return buildCategorySpecificInputs(state.productArgument?.category ?? CategoryEnum.empty, state, cubit);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

Widget buildInputWidget<T>(String propertyName, T? propertyValue, void Function(T?) onChanged, [List<T>? enumValues]) {
  return Builder(
    builder: (BuildContext context) {
      if (T == DateTime) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(propertyName, style: AppTextStyle.smallText),
            GestureDetector(
              onTap: () async {
                print("Tapped"); // Để debug
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: propertyValue as DateTime? ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  onChanged(picked as T?);
                }
              },
              child: AbsorbPointer(
                child: FieldWithIcon(
                  controller: TextEditingController(
                    text: (propertyValue as DateTime?)?.toString().split(' ')[0] ?? '',
                  ),
                  readOnly: true,
                  hintText: 'Select $propertyName',
                  fillColor: const Color(0xFF202046),
                  suffixIcon: const Icon(Icons.calendar_today), // Thêm icon calendar
                ),
              ),
            ),
          ],
        );
      } else if (enumValues != null) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(propertyName, style: AppTextStyle.smallText),
            GradientDropdown<T>(
              items: (String filter, dynamic infiniteScrollProps) => enumValues,
              compareFn: (T? d1, T? d2) => d1 == d2,
              itemAsString: (T d) => d.toString(),
              onChanged: onChanged,
              selectedItem: propertyValue,
              hintText: 'Select $propertyName',
            ),
          ],
        );
      } else {
        final controller = TextEditingController(text: propertyValue?.toString() ?? '');
        controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));

        TextInputType keyboardType;
        List<TextInputFormatter> inputFormatters;

        if (T == int) {
          keyboardType = TextInputType.number;
          inputFormatters = [FilteringTextInputFormatter.digitsOnly];
        } else if (T == double) {
          keyboardType = const TextInputType.numberWithOptions(decimal: true);
          inputFormatters = [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))];
        } else {
          keyboardType = TextInputType.text;
          inputFormatters = [FilteringTextInputFormatter.allow(RegExp(r'.*'))];
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(propertyName, style: AppTextStyle.smallText),
            FieldWithIcon(
              controller: controller,
              hintText: 'Enter $propertyName',
              onChanged: (value) {
                if (value.isEmpty) {
                  onChanged(null);
                } else if (T == int) {
                  onChanged(int.tryParse(value) as T?);
                } else if (T == double) {
                  onChanged(double.tryParse(value) as T?);
                } else {
                  onChanged(value as T?);
                }
              },
              fillColor: const Color(0xFF202046),
              keyboardType: keyboardType,
              inputFormatters: inputFormatters,
            ),
          ],
        );
      }
    }
  );
}

Widget buildCategorySpecificInputs(CategoryEnum category, AddProductScreenState state, AddProductScreenCubit cubit) {
  switch (category) {
    case CategoryEnum.ram:
      return Column(
        children: [
          buildInputWidget<RAMBus>(
            'RAM Bus',
            state.productArgument?.ramBus,
                (value) {
              cubit.updateProductArgument(state.productArgument!.copyWith(ramBus: value));
            },
            RAMBus.values,
          ),
          buildInputWidget<RAMCapacity>(
            'RAM Capacity',
            state.productArgument?.ramCapacity,
                (value) {
              cubit.updateProductArgument(state.productArgument!.copyWith(ramCapacity: value));
            },
            RAMCapacity.values,
          ),
          buildInputWidget<RAMType>(
            'RAM Type',
            state.productArgument?.ramType,
                (value) {
              cubit.updateProductArgument(state.productArgument!.copyWith(ramType: value));
            },
            RAMType.values,
          ),
        ],
      );
    case CategoryEnum.cpu:
      return Column(
        children: [
          buildInputWidget<CPUFamily>(
            'CPU Family',
            state.productArgument?.family,
                (value) {
              cubit.updateProductArgument(state.productArgument!.copyWith(family: value));
            },
            CPUFamily.values,
          ),
          buildInputWidget<int>(
            'CPU Core',
            state.productArgument?.core,
                (value) {
              cubit.updateProductArgument(state.productArgument!.copyWith(core: value));
            },
          ),
          buildInputWidget<int>(
            'CPU Thread',
            state.productArgument?.thread,
                (value) {
              cubit.updateProductArgument(state.productArgument!.copyWith(thread: value));
            },
          ),
          buildInputWidget<double>(
            'CPU Clock Speed',
            state.productArgument?.cpuClockSpeed,
                (value) {
              cubit.updateProductArgument(state.productArgument!.copyWith(cpuClockSpeed: value));
            },
          ),
        ],
      );
    case CategoryEnum.psu:
      return Column(
        children: [
          buildInputWidget<int>(
            'PSU Wattage',
            state.productArgument?.wattage,
                (value) {
              cubit.updateProductArgument(state.productArgument!.copyWith(wattage: value));
            },
          ),
          buildInputWidget<PSUEfficiency>(
            'PSU Efficiency',
            state.productArgument?.efficiency,
                (value) {
              cubit.updateProductArgument(state.productArgument!.copyWith(efficiency: value));
            },
            PSUEfficiency.values,
          ),
          buildInputWidget<PSUModular>(
            'PSU Modular',
            state.productArgument?.modular,
                (value) {
              cubit.updateProductArgument(state.productArgument!.copyWith(modular: value));
            },
            PSUModular.values,
          ),
        ],
      );
    case CategoryEnum.gpu:
      return Column(
        children: [
          buildInputWidget<GPUSeries>(
            'GPU Series',
            state.productArgument?.gpuSeries,
                (value) {
              cubit.updateProductArgument(state.productArgument!.copyWith(gpuSeries: value));
            },
            GPUSeries.values,
          ),
          buildInputWidget<GPUCapacity>(
            'GPU Capacity',
            state.productArgument?.gpuCapacity,
                (value) {
              cubit.updateProductArgument(state.productArgument!.copyWith(gpuCapacity: value));
            },
            GPUCapacity.values,
          ),
          buildInputWidget<GPUBus>(
            'GPU Bus',
            state.productArgument?.gpuBus,
                (value) {
              cubit.updateProductArgument(state.productArgument!.copyWith(gpuBus: value));
            },
            GPUBus.values,
          ),
          buildInputWidget<double>(
            'GPU Clock Speed',
            state.productArgument?.gpuClockSpeed,
                (value) {
              cubit.updateProductArgument(state.productArgument!.copyWith(gpuClockSpeed: value));
            },
          ),
        ],
      );
    case CategoryEnum.mainboard:
      return Column(
        children: [
          buildInputWidget<MainboardFormFactor>(
            'Form Factor',
            state.productArgument?.formFactor,
                (value) {
              cubit.updateProductArgument(state.productArgument!.copyWith(formFactor: value));
            },
            MainboardFormFactor.values,
          ),
          buildInputWidget<MainboardSeries>(
            'Series',
            state.productArgument?.mainboardSeries,
                (value) {
              cubit.updateProductArgument(state.productArgument!.copyWith(mainboardSeries: value));
            },
            MainboardSeries.values,
          ),
          buildInputWidget<MainboardCompatibility>(
            'Compatibility',
            state.productArgument?.compatibility,
                (value) {
              cubit.updateProductArgument(state.productArgument!.copyWith(compatibility: value));
            },
            MainboardCompatibility.values,
          ),
        ],
      );
    case CategoryEnum.drive:
      return Column(
        children: [
          buildInputWidget<DriveType>(
            'Drive Type',
            state.productArgument?.driveType,
                (value) {
              cubit.updateProductArgument(state.productArgument!.copyWith(driveType: value));
            },
            DriveType.values,
          ),
          buildInputWidget<DriveCapacity>(
            'Drive Capacity',
            state.productArgument?.driveCapacity,
                (value) {
              cubit.updateProductArgument(state.productArgument!.copyWith(driveCapacity: value));
            },
            DriveCapacity.values,
          ),
        ],
      );
    default:
      return Container();
  }
}