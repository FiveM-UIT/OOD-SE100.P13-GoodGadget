import 'package:gizmoglobe_client/enums/product_related/product_status_enum.dart';
import 'package:gizmoglobe_client/objects/manufacturer.dart';

import '../../enums/product_related/category_enum.dart';
import 'product_factory.dart';

abstract class Product {
  String? productID;
  String productName;
  CategoryEnum category;
  double importPrice;
  double sellingPrice;
  double discount;
  DateTime release;
  int sales;
  int stock;
  Manufacturer manufacturer;
  ProductStatusEnum status;

  Product({
    this.productID,
    required this.productName,
    required this.manufacturer,
    required this.category,
    required this.importPrice,
    required this.sellingPrice,
    required this.discount,
    required this.release,
    this.sales = 0,
    this.stock = 0,
    this.status = ProductStatusEnum.outOfStock,
  });

  Product changeCategory(CategoryEnum newCategory, Map<String, dynamic> properties) {
    properties['productID'] = productID;
    return ProductFactory.createProduct(newCategory, properties);
  }

  void updateStatus(ProductStatusEnum newStatus) {
    status = newStatus;
  }

  void updateProduct({
    String? productName,
    double? importPrice,
    double? sellingPrice,
    double? discount,
    DateTime? release,
    int? sales,
    int? stock,
    Manufacturer? manufacturer,
  }) {
    this.productName = productName ?? this.productName;
    this.importPrice = importPrice ?? this.importPrice;
    this.sellingPrice = sellingPrice ?? this.sellingPrice;
    this.discount = discount ?? this.discount;
    this.release = release ?? this.release;
    this.sales = sales ?? this.sales;
    this.stock = stock ?? this.stock;
    this.manufacturer = manufacturer ?? this.manufacturer;
  }

}