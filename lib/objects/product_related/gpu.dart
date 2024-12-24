import 'package:gizmoglobe_client/enums/product_related/gpu_enums/gpu_bus.dart';
import 'package:gizmoglobe_client/enums/product_related/gpu_enums/gpu_capacity.dart';
import 'package:gizmoglobe_client/enums/product_related/gpu_enums/gpu_series.dart';

import '../../enums/product_related/category_enum.dart';
import '../manufacturer.dart';
import 'product.dart';

class GPU extends Product {
  GPUSeries series;
  GPUCapacity capacity;
  GPUBus bus;
  double clockSpeed;

  GPU({
    required super.productName,
    required super.importPrice,
    required super.sellingPrice,
    required super.discount,
    required super.release,
    required super.manufacturer,
    super.category = CategoryEnum.gpu,
    required this.series,
    required this.capacity,
    required this.bus,
    required this.clockSpeed,
  });

  @override
  void updateProduct({
    String? productName,
    double? importPrice,
    double? sellingPrice,
    double? discount,
    DateTime? release,
    int? sales,
    int? stock,
    Manufacturer? manufacturer,
    GPUSeries? series,
    GPUCapacity? capacity,
    GPUBus? bus,
    double? clockSpeed,
  }) {
    super.updateProduct(
      productName: productName,
      importPrice: importPrice,
      sellingPrice: sellingPrice,
      discount: discount,
      release: release,
      sales: sales,
      manufacturer: manufacturer,
    );

    this.series = series ?? this.series;
    this.capacity = capacity ?? this.capacity;
    this.bus = bus ?? this.bus;
    this.clockSpeed = clockSpeed ?? this.clockSpeed;
  }
}