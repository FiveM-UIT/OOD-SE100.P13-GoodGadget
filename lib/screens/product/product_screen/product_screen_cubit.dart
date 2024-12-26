import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gizmoglobe_client/enums/product_related/category_enum.dart';
import 'package:gizmoglobe_client/objects/manufacturer.dart';
import 'package:gizmoglobe_client/objects/product_related/product.dart';
import 'package:gizmoglobe_client/objects/product_related/product_factory.dart';
import 'package:gizmoglobe_client/screens/product/product_screen/product_screen_state.dart';
import '../../../enums/processing/sort_enum.dart';
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
// Import các enum cần thiết cho từng loại sản phẩm
import '../../../enums/product_related/psu_enums/psu_efficiency.dart';
import '../../../enums/product_related/psu_enums/psu_modular.dart';
import '../../../enums/product_related/ram_enums/ram_bus.dart';
import '../../../enums/product_related/ram_enums/ram_capacity_enum.dart';
import '../../../enums/product_related/ram_enums/ram_type.dart';
// ... thêm các import khác

class ProductScreenCubit extends Cubit<ProductScreenState> {
  ProductScreenCubit() : super(const ProductScreenState());
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void initialize() async {
    try {
      await fetchDataFromFirestore();
    } catch (e) {
      print('Error initializing product screen: $e');
    }
  }

  Future<void> fetchDataFromFirestore() async {
    try {
      // Lấy manufacturers
      final manufacturerSnapshot = await _firestore.collection('manufacturers').get();
      final manufacturers = manufacturerSnapshot.docs.map((doc) => Manufacturer(
        manufacturerID: doc.id,
        manufacturerName: doc['manufacturerName'] as String,
      )).toList();

      // Lấy products
      final productSnapshot = await _firestore.collection('products').get();
      final products = await Future.wait(productSnapshot.docs.map((doc) async {
        try {
          final data = doc.data();
          final manufacturer = manufacturers.firstWhere(
            (m) => m.manufacturerID == data['manufacturerID'],
          );

          final category = CategoryEnum.values.firstWhere(
            (c) => c.getName() == data['category'],
          );

          final specificData = _getSpecificProductData(data, category);
          
          return ProductFactory.createProduct(
            category,
            {
              'productID': doc.id,
              'productName': data['productName'],
              'manufacturer': manufacturer,
              'importPrice': (data['importPrice'] as num).toDouble(),
              'sellingPrice': (data['sellingPrice'] as num).toDouble(),
              'discount': (data['discount'] as num).toDouble(),
              'release': (data['release'] as Timestamp).toDate(),
              'sales': data['sales'] as int,
              'stock': data['stock'] as int,
              'status': ProductStatusEnum.values.firstWhere(
                (s) => s.getName() == data['status'],
              ),
              ...specificData,
            },
          );
        } catch (e) {
          print('Error processing product ${doc.id}: $e');
          return null;
        }
      }));

      emit(state.copyWith(
        manufacturerList: manufacturers,
        productList: products.whereType<Product>().toList(),
      ));

    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Map<String, dynamic> _getSpecificProductData(Map<String, dynamic> data, CategoryEnum category) {
    switch (category) {
      case CategoryEnum.ram:
        return {
          'bus': RAMBus.values.firstWhere((b) => b.getName() == data['bus']),
          'capacity': RAMCapacity.values.firstWhere((c) => c.getName() == data['capacity']),
          'ramType': RAMType.values.firstWhere((t) => t.getName() == data['ramType']),
        };

      case CategoryEnum.cpu:
        return {
          'family': CPUFamily.values.firstWhere((f) => f.getName() == data['family']),
          'core': data['core'],
          'thread': data['thread'],
          'clockSpeed': data['clockSpeed'].toDouble(),
        };
      case CategoryEnum.gpu:
        return {
          'series': GPUSeries.values.firstWhere((s) => s.getName() == data['series']),
          'capacity': GPUCapacity.values.firstWhere((c) => c.getName() == data['capacity']),
          'busWidth': GPUBus.values.firstWhere((b) => b.getName() == data['busWidth']),
          'clockSpeed': data['clockSpeed'].toDouble(),
        };
      case CategoryEnum.mainboard:
        return {
          'formFactor': MainboardFormFactor.values.firstWhere((f) => f.getName() == data['formFactor']),
          'series': MainboardSeries.values.firstWhere((s) => s.getName() == data['series']),
          'compatibility': MainboardCompatibility.values.firstWhere((c) => c.getName() == data['compatibility']),
        };
      case CategoryEnum.drive:
        return {
          'type': DriveType.values.firstWhere((t) => t.getName() == data['type']),
          'capacity': DriveCapacity.values.firstWhere((c) => c.getName() == data['capacity']),
        };
      case CategoryEnum.psu:
        return {
          'wattage': data['wattage'],
          'efficiency': PSUEfficiency.values.firstWhere((e) => e.getName() == data['efficiency']),
          'modular': PSUModular.values.firstWhere((m) => m.getName() == data['modular']),
        };
      default:
        return {};
    }
  }


  void updateSelectedTabIndex(int index) {
    emit(state.copyWith(selectedTabIndex: index));
  }

  void updateSearchText(String? searchText) {
    emit(state.copyWith(searchText: searchText));
  }

  void updateSortOption(SortEnum selectedOption) {
    emit(state.copyWith(selectedSortOption: selectedOption));
  }
}