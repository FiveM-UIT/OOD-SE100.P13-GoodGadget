import 'package:gizmoglobe_client/enums/product_related/cpu_enums/cpu_family.dart';

import '../../enums/product_related/category_enum.dart';
import '../manufacturer.dart';
import 'product.dart';

class CPU extends Product {
  CPUFamily family;
  int core;
  int thread;
  double clockSpeed;

  CPU({
    required super.productName,
    required super.importPrice,
    required super.sellingPrice,
    required super.discount,
    required super.release,
    required super.manufacturer,
    super.category = CategoryEnum.cpu,
    required this.family,
    required this.core,
    required this.thread,
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
    CPUFamily? family,
    int? core,
    int? thread,
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

    this.family = family ?? this.family;
    this.core = core ?? this.core;
    this.thread = thread ?? this.thread;
    this.clockSpeed = clockSpeed ?? this.clockSpeed;
  }
}