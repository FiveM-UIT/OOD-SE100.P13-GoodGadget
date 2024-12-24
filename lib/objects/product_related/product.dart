import 'package:gizmoglobe_client/enums/product_related/product_status_enum.dart';
import 'package:gizmoglobe_client/objects/manufacturer.dart';

import '../../enums/product_related/category_enum.dart';
import 'product_factory.dart';

abstract class Product {
  String? productID;
  final String productName;
  final CategoryEnum category;
  final double importPrice;
  final double sellingPrice;
  final double discount;
  final double release;
  final double sales;
  final double stock;
  final Manufacturer manufacturer;
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
}