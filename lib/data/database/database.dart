import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:gizmoglobe_client/objects/manufacturer.dart';
import 'package:gizmoglobe_client/objects/product_related/product.dart';

import '../../enums/product_related/category_enum.dart';
import '../../enums/product_related/cpu_enums/cpu_family.dart';
import '../../enums/product_related/drive_enums/drive_capacity.dart';
import '../../enums/product_related/drive_enums/drive_type.dart';
import '../../enums/product_related/gpu_enums/gpu_bus.dart';
import '../../enums/product_related/gpu_enums/gpu_capacity.dart';
import '../../enums/product_related/gpu_enums/gpu_series.dart';
import '../../enums/product_related/mainboard_enums/mainboard_compatibility.dart';
import '../../enums/product_related/mainboard_enums/mainboard_form_factor.dart';
import '../../enums/product_related/mainboard_enums/mainboard_series.dart';
import '../../enums/product_related/psu_enums/psu_efficiency.dart';
import '../../enums/product_related/psu_enums/psu_modular.dart';
import '../../enums/product_related/ram_enums/ram_bus.dart';
import '../../enums/product_related/ram_enums/ram_capacity_enum.dart';
import '../../enums/product_related/ram_enums/ram_type.dart';
import '../../objects/product_related/product_factory.dart';
import '../../objects/product_related/psu.dart';
import '../../objects/product_related/ram.dart';

class Database {
  static final Database _database = Database._internal();
  String username = '';
  String email = '';
  List<Manufacturer> manufacturerList = [];
  List<Product> productList = [];

  factory Database() {
    return _database;
  }

  Database._internal();

  initialize() {
    manufacturerList = [
      Manufacturer(
        manufacturerID: 'Corsair',
        manufacturerName: 'Corsair',
      ),
      Manufacturer(
        manufacturerID: 'G.Skill',
        manufacturerName: 'G.Skill',
      ),
      Manufacturer(
        manufacturerID: 'Crucial',
        manufacturerName: 'Crucial',
      ),
      Manufacturer(
        manufacturerID: 'Kingston',
        manufacturerName: 'Kingston',
      ),
      Manufacturer(
        manufacturerID: 'Intel',
        manufacturerName: 'Intel',
      ),
      Manufacturer(
        manufacturerID: 'AMD',
        manufacturerName: 'AMD',
      ),
      Manufacturer(
        manufacturerID: 'ASUS',
        manufacturerName: 'ASUS',
      ),
      Manufacturer(
        manufacturerID: 'MSI',
        manufacturerName: 'MSI',
      ),
      Manufacturer(
        manufacturerID: 'Gigabyte',
        manufacturerName: 'Gigabyte',
      ),
      Manufacturer(
        manufacturerID: 'Samsung',
        manufacturerName: 'Samsung',
      ),
      Manufacturer(
        manufacturerID: 'Western Digital',
        manufacturerName: 'Western Digital',
      ),
      Manufacturer(
        manufacturerID: 'Seagate',
        manufacturerName: 'Seagate',
      ),
      Manufacturer(
        manufacturerID: 'Seasonic',
        manufacturerName: 'Seasonic',
      ),
      Manufacturer(
        manufacturerID: 'be quiet!',
        manufacturerName: 'be quiet!',
      ),
      Manufacturer(
        manufacturerID: 'Thermaltake',
        manufacturerName: 'Thermaltake',
      ),
    ];

    productList = [
      // RAM samples - sử dụng các nhà sản xuất RAM (index 0-3)
      ProductFactory.createProduct(CategoryEnum.ram, {
        'productName': 'Corsair Vengeance LPX DDR5',
        'manufacturer': manufacturerList[0], // Corsair
        'importPrice': 80.0,
        'sellingPrice': 160.0,
        'discount': 0.3,
        'release': DateTime(2022, 1, 1),
        'bus': RAMBus.mhz4800,
        'capacity': RAMCapacity.gb16,
        'ramType': RAMType.ddr5,
      }),
      ProductFactory.createProduct(CategoryEnum.ram, {
        'productName': 'G.Skill Trident Z RGB DDR4',
        'manufacturer': manufacturerList[1], // G.Skill
        'importPrice': 60.0,
        'sellingPrice': 120.0,
        'discount': 0.2,
        'release': DateTime(2021, 1, 1),
        'bus': RAMBus.mhz3200,
        'capacity': RAMCapacity.gb32,
        'ramType': RAMType.ddr4,
      }),
      ProductFactory.createProduct(CategoryEnum.ram, {
        'productName': 'Crucial Ballistix DDR4',
        'manufacturer': manufacturerList[2], // Crucial
        'importPrice': 50.0,
        'sellingPrice': 100.0,
        'discount': 0.16,
        'release': DateTime(2020, 1, 1),
        'bus': RAMBus.mhz2400,
        'capacity': RAMCapacity.gb32,
        'ramType': RAMType.ddr4,
      }),
      ProductFactory.createProduct(CategoryEnum.ram, {
        'productName': 'Kingston Fury Beast DDR5',
        'manufacturer': manufacturerList[3], // Kingston
        'importPrice': 70.0,
        'sellingPrice': 140.0,
        'discount': 0.25,
        'release': DateTime(2022, 1, 1),
        'bus': RAMBus.mhz2133,
        'capacity': RAMCapacity.gb32,
        'ramType': RAMType.ddr5,
      }),

      // CPU samples - sử dụng Intel và AMD (index 4-5)
      ProductFactory.createProduct(CategoryEnum.cpu, {
        'productName': 'Intel Core i9-12900K',
        'manufacturer': manufacturerList[4], // Intel
        'importPrice': 400.0,
        'sellingPrice': 600.0,
        'discount': 0.1,
        'release': DateTime(2021, 11, 4),
        'family': CPUFamily.corei7Ultra7,
        'core': 16,
        'thread': 24,
        'clockSpeed': 3.2,
      }),
      ProductFactory.createProduct(CategoryEnum.cpu, {
        'productName': 'AMD Ryzen 9 5950X',
        'manufacturer': manufacturerList[5], // AMD
        'importPrice': 350.0,
        'sellingPrice': 550.0,
        'discount': 0.12,
        'release': DateTime(2020, 11, 5),
        'family': CPUFamily.ryzen5,
        'core': 16,
        'thread': 32,
        'clockSpeed': 3.4,
      }),

      // GPU samples - sử dụng ASUS, MSI, Gigabyte (index 6-8)
      ProductFactory.createProduct(CategoryEnum.gpu, {
        'productName': 'ASUS ROG STRIX RTX 3080',
        'manufacturer': manufacturerList[6], // ASUS
        'importPrice': 700.0,
        'sellingPrice': 1000.0,
        'discount': 0.16,
        'release': DateTime(2020, 9, 17),
        'series': GPUSeries.rtx,
        'capacity': GPUCapacity.gb12,
        'busWidth': GPUBus.bit384,
        'clockSpeed': 1.71,
      }),
      ProductFactory.createProduct(CategoryEnum.gpu, {
        'productName': 'MSI Gaming X Trio RX 6900 XT',
        'manufacturer': manufacturerList[7], // MSI
        'importPrice': 800.0,
        'sellingPrice': 1100.0,
        'discount': 0.15,
        'release': DateTime(2020, 12, 8),
        'series': GPUSeries.rx,
        'capacity': GPUCapacity.gb16,
        'busWidth': GPUBus.bit256,
        'clockSpeed': 2.25,
      }),
      ProductFactory.createProduct(CategoryEnum.gpu, {
        'productName': 'Gigabyte AORUS GTX 1660',
        'manufacturer': manufacturerList[8], // Gigabyte
        'importPrice': 200.0,
        'sellingPrice': 300.0,
        'discount': 0.1,
        'release': DateTime(2019, 1, 7),
        'series': GPUSeries.gtx,
        'capacity': GPUCapacity.gb6,
        'busWidth': GPUBus.bit128,
        'clockSpeed': 1.53,
      }),

      // Mainboard samples - thêm các form factor và chipset khác nhau
      ProductFactory.createProduct(CategoryEnum.mainboard, {
        'productName': 'ASUS ROG STRIX B550-F GAMING',
        'manufacturer': manufacturerList[5],
        'importPrice': 150.0,
        'sellingPrice': 250.0,
        'discount': 0.2,
        'release': DateTime(2020, 6, 16),
        'formFactor': MainboardFormFactor.atx,
        'series': MainboardSeries.b,
        'compatibility': MainboardCompatibility.amd,
      }),
      ProductFactory.createProduct(CategoryEnum.mainboard, {
        'productName': 'MSI MPG B560I GAMING EDGE',
        'manufacturer': manufacturerList[6],
        'importPrice': 120.0,
        'sellingPrice': 200.0,
        'discount': 0.15,
        'release': DateTime(2021, 1, 11),
        'formFactor': MainboardFormFactor.miniITX,
        'series': MainboardSeries.b,
        'compatibility': MainboardCompatibility.intel,
      }),
      ProductFactory.createProduct(CategoryEnum.mainboard, {
        'productName': 'ASUS ROG MAXIMUS Z690 HERO',
        'manufacturer': manufacturerList[5],
        'importPrice': 300.0,
        'sellingPrice': 400.0,
        'discount': 0.1,
        'release': DateTime(2021, 11, 4),
        'formFactor': MainboardFormFactor.atx,
        'series': MainboardSeries.z,
        'compatibility': MainboardCompatibility.intel,
      }),
      ProductFactory.createProduct(CategoryEnum.mainboard, {
        'productName': 'MSI MAG X570S TOMAHAWK',
        'manufacturer': manufacturerList[6],
        'importPrice': 200.0,
        'sellingPrice': 300.0,
        'discount': 0.12,
        'release': DateTime(2021, 6, 16),
        'formFactor': MainboardFormFactor.atx,
        'series': MainboardSeries.x,
        'compatibility': MainboardCompatibility.amd,
      }),

      // Drive samples - thêm các loại ổ cứng khác nhau
      ProductFactory.createProduct(CategoryEnum.drive, {
        'productName': 'Samsung 970 EVO Plus',
        'manufacturer': manufacturerList[9], // Samsung
        'importPrice': 100.0,
        'sellingPrice': 150.0,
        'discount': 0.1,
        'release': DateTime(2018, 4, 24),
        'type': DriveType.m2NVME,
        'capacity': DriveCapacity.gb512,
      }),
      ProductFactory.createProduct(CategoryEnum.drive, {
        'productName': 'WD Black SN850X',
        'manufacturer': manufacturerList[10], // Western Digital
        'importPrice': 120.0,
        'sellingPrice': 180.0,
        'discount': 0.12,
        'release': DateTime(2020, 12, 1),
        'type': DriveType.m2NVME,
        'capacity': DriveCapacity.tb1,
      }),
      ProductFactory.createProduct(CategoryEnum.drive, {
        'productName': 'Seagate FireCuda 530',
        'manufacturer': manufacturerList[11], // Seagate
        'importPrice': 80.0,
        'sellingPrice': 130.0,
        'discount': 0.15,
        'release': DateTime(2021, 7, 1),
        'type': DriveType.m2NVME,
        'capacity': DriveCapacity.tb2,
      }),

      // PSU samples - sử dụng Seasonic, be quiet!, Thermaltake (index 12-14)
      ProductFactory.createProduct(CategoryEnum.psu, {
        'productName': 'Seasonic FOCUS GX-750',
        'manufacturer': manufacturerList[12], // Seasonic
        'importPrice': 80.0,
        'sellingPrice': 120.0,
        'discount': 0.1,
        'release': DateTime(2019, 6, 1),
        'wattage': 750,
        'efficiency': PSUEfficiency.gold,
        'modular': PSUModular.fullModular,
      }),
      ProductFactory.createProduct(CategoryEnum.psu, {
        'productName': 'be quiet! Dark Power 12',
        'manufacturer': manufacturerList[13], // be quiet!
        'importPrice': 120.0,
        'sellingPrice': 180.0,
        'discount': 0.12,
        'release': DateTime(2020, 12, 1),
        'wattage': 1000,
        'efficiency': PSUEfficiency.titanium,
        'modular': PSUModular.fullModular,
      }),
      ProductFactory.createProduct(CategoryEnum.psu, {
        'productName': 'Thermaltake Toughpower GF1',
        'manufacturer': manufacturerList[14], // Thermaltake
        'importPrice': 100.0,
        'sellingPrice': 150.0,
        'discount': 0.15,
        'release': DateTime(2021, 3, 1),
        'wattage': 850,
        'efficiency': PSUEfficiency.gold,
        'modular': PSUModular.fullModular,
      }),
    ];
  }


  Future<void> getUsername() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      username = userDoc['username'];
    }
  }

  Future<void> getUser() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      username = userDoc['username'];
      email = userDoc['email'];
    }
  }
}