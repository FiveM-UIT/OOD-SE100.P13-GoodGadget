import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gizmoglobe_client/enums/product_related/cpu_enums/cpu_family.dart';
import 'package:gizmoglobe_client/enums/product_related/drive_enums/drive_capacity.dart';
import 'package:gizmoglobe_client/enums/product_related/drive_enums/drive_type.dart';
import 'package:gizmoglobe_client/enums/product_related/gpu_enums/gpu_bus.dart';
import 'package:gizmoglobe_client/enums/product_related/gpu_enums/gpu_capacity.dart';
import 'package:gizmoglobe_client/enums/product_related/gpu_enums/gpu_series.dart';
import 'package:gizmoglobe_client/enums/product_related/mainboard_enums/mainboard_compatibility.dart';
import 'package:gizmoglobe_client/enums/product_related/mainboard_enums/mainboard_form_factor.dart';
import 'package:gizmoglobe_client/enums/product_related/mainboard_enums/mainboard_series.dart';
import 'package:gizmoglobe_client/enums/product_related/psu_enums/psu_efficiency.dart';
import 'package:gizmoglobe_client/enums/product_related/psu_enums/psu_modular.dart';
import 'package:gizmoglobe_client/enums/product_related/ram_enums/ram_bus.dart';
import 'package:gizmoglobe_client/enums/product_related/ram_enums/ram_capacity_enum.dart';
import 'package:gizmoglobe_client/enums/product_related/ram_enums/ram_type.dart';
import '../../data/database/database.dart';
import 'package:gizmoglobe_client/objects/product_related/cpu.dart';
import 'package:gizmoglobe_client/objects/product_related/drive.dart';
import 'package:gizmoglobe_client/objects/product_related/gpu.dart';
import 'package:gizmoglobe_client/objects/product_related/mainboard.dart';
import 'package:gizmoglobe_client/objects/product_related/psu.dart';
import 'package:gizmoglobe_client/objects/product_related/ram.dart';

import '../../enums/product_related/category_enum.dart';
import '../../enums/product_related/product_status_enum.dart';
import '../../enums/stakeholders/employee_role.dart';
import '../../objects/customer.dart';
import '../../objects/employee.dart';
import '../../objects/manufacturer.dart';
import '../../objects/product_related/product.dart';
import '../../objects/product_related/product_factory.dart';

Future<void> pushProductSamplesToFirebase() async {
  try {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    Database().generateSampleData();
    for (var manufacturer in Database().manufacturerList) {
      await firestore.collection('manufacturers').doc(manufacturer.manufacturerID).set({
        'manufacturerID': manufacturer.manufacturerID,
        'manufacturerName': manufacturer.manufacturerName,
      });
    }

    // Push products to Firestore
    for (var product in Database().productList) {
      Map<String, dynamic> productData = {
        'productName': product.productName,
        'importPrice': product.importPrice,
        'sellingPrice': product.sellingPrice,
        'discount': product.discount,
        'release': product.release,
        'sales': product.sales,
        'stock': product.stock,
        'status': product.status.getName(),
        'manufacturerID': product.manufacturer.manufacturerID,
        'category': product.category.getName(),
      };

      // Thêm các thuộc tính đặc thù cho từng loại sản phẩm
      switch (product.runtimeType) {
        case RAM:
          final ram = product as RAM;
          productData.addAll({
            'bus': ram.bus.getName(),
            'capacity': ram.capacity.getName(),
            'ramType': ram.ramType.getName(),
          });
          break;

        case CPU:
          final cpu = product as CPU;
          productData.addAll({
            'family': cpu.family.getName(),
            'core': cpu.core,
            'thread': cpu.thread,
            'clockSpeed': cpu.clockSpeed,
          });
          break;

        case GPU:
          final gpu = product as GPU;
          productData.addAll({
            'series': gpu.series.getName(),
            'capacity': gpu.capacity.getName(),
            'busWidth': gpu.bus.getName(),
            'clockSpeed': gpu.clockSpeed,
          });
          break;

        case Mainboard:
          final mainboard = product as Mainboard;
          productData.addAll({
            'formFactor': mainboard.formFactor.getName(),
            'series': mainboard.series.getName(),
            'compatibility': mainboard.compatibility.getName(),
          });
          break;

        case Drive:
          final drive = product as Drive;
          productData.addAll({
            'type': drive.type.getName(),
            'capacity': drive.capacity.getName(),
          });
          break;

        case PSU:
          final psu = product as PSU;
          productData.addAll({
            'wattage': psu.wattage,
            'efficiency': psu.efficiency.getName(),
            'modular': psu.modular.getName(),
          });
          break;
      }

      // Thêm sản phẩm vào Firestore với tất cả thuộc tính
      await firestore.collection('products').add(productData);
    }
  } catch (e) {
    print('Error pushing product samples to Firebase: $e');
  }
}

Future<void> pushAddressSamplesToFirebase() async {
  try {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    Database().generateSampleData();

    for (var address in Database().addressList) {
      DocumentReference docRef = await firestore.collection('addresses').add({
        'customerID': address.customerID,
        'receiverName': address.receiverName,
        'receiverPhone': address.receiverPhone,
        'provinceCode': address.province?.code,
        'districtCode': address.district?.code,
        'wardCode': address.ward?.code,
        'street': address.street ?? '',
        'isDefault': address.isDefault,
      });

      // Cập nhật lại document với addressID
      await docRef.update({'addressID': docRef.id});
    }
  } catch (e) {
    print('Error pushing address samples to Firebase: $e');
    rethrow;
  }
}

class Firebase {
  static final Firebase _firebase = Firebase._internal();

  factory Firebase() {
    return _firebase;
  }

  Firebase._internal();

  Future<void> pushCustomerSampleData() async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      Database().generateSampleData();

      for (var customer in Database().customerList) {
        DocumentReference docRef = await firestore.collection('customers').add(
          customer.toMap(),
        );
        
        customer.customerID = docRef.id;
        // Cập nhật lại document với ID
        await docRef.update({
          'customerID': docRef.id,
          ...customer.toMap()
        });
      }
      print('Successfully pushed customer data');
    } catch (e) {
      print('Error pushing sample data: $e');
      rethrow;
    }
  }

  Future<List<Customer>> getCustomers() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('customers')
          .get();

      return snapshot.docs.map((doc) {
        return Customer.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print('Lỗi khi lấy danh sách khách hàng: $e');
      rethrow;
    }
  }

  Stream<List<Customer>> customersStream() {
    return FirebaseFirestore.instance
        .collection('customers')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Customer.fromMap(doc.id, doc.data());
      }).toList();
    });
  }

  Future<void> updateCustomer(Customer customer) async {
    try {
      if (customer.customerID == null) {
        throw Exception('Customer ID cannot be null');
      }

      // Cập nhật thông tin khách hàng
      await FirebaseFirestore.instance
          .collection('customers')
          .doc(customer.customerID)
          .update({
        'customerName': customer.customerName,
        'phoneNumber': customer.phoneNumber,
      });

      // Cập nhật thông tin user tương ứng
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('userID', isEqualTo: customer.customerID)
          .get();

      for (var doc in userSnapshot.docs) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(doc.id)
            .update({
          'username': customer.customerName,
        });
      }
    } catch (e) {
      print('Lỗi khi cập nhật khách hàng: $e');
      rethrow;
    }
  }

  Future<void> deleteCustomer(String customerId) async {
    try {
      // Xóa khách hàng từ collection customers
      await FirebaseFirestore.instance
          .collection('customers')
          .doc(customerId)
          .delete();

      // Xóa tài khoản user tương ứng nếu có
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('userID', isEqualTo: customerId)
          .get();

      for (var doc in userSnapshot.docs) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(doc.id)
            .delete();
      }

      // Có thể thêm logic để xóa các dữ liệu liên quan khác
      // như orders, cart items, etc.

    } catch (e) {
      print('Lỗi khi xóa khách hàng: $e');
      rethrow;
    }
  }

  Future<void> createCustomer(Customer customer) async {
    try {
      // Tạo customer trong collection customers
      DocumentReference customerRef = await FirebaseFirestore.instance
          .collection('customers')
          .add(customer.toMap());
      
      String customerId = customerRef.id;
      customer.customerID = customerId;
      
      // Cập nhật customerID trong document customer
      await customerRef.update({'customerID': customerId});

      // Tạo user với cùng ID như customer
      await FirebaseFirestore.instance
          .collection('users')
          .doc(customerId)  // Sử dụng customerId làm document ID
          .set({
        'email': customer.email,
        'username': customer.customerName,
        'role': 'customer',
        'userID': customerId
      });
    } catch (e) {
      print('Lỗi khi tạo khách hàng mới: $e');
      rethrow;
    }
  }

  Future<Customer?> getCustomerByEmail(String email) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('customers')
          .where('email', isEqualTo: email)
          .get();

      if (snapshot.docs.isEmpty) return null;

      return Customer.fromMap(
        snapshot.docs.first.id,
        snapshot.docs.first.data() as Map<String, dynamic>,
      );
    } catch (e) {
      print('Lỗi khi tìm khách hàng theo email: $e');
      rethrow;
    }
  }

  // Employee-related functions
  Future<List<Employee>> getEmployees() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('employees')
          .get();

      return snapshot.docs.map((doc) {
        return Employee.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print('Lỗi khi lấy danh sách nhân viên: $e');
      rethrow;
    }
  }

  Stream<List<Employee>> employeesStream() {
    return FirebaseFirestore.instance
        .collection('employees')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Employee.fromMap(doc.id, doc.data());
      }).toList();
    });
  }

  Future<void> updateEmployee(Employee employee) async {
    try {
      if (employee.employeeID == null) {
        throw Exception('Employee ID cannot be null');
      }

      // Lấy thông tin employee cũ trước khi cập nhật
      DocumentSnapshot oldEmployeeDoc = await FirebaseFirestore.instance
          .collection('employees')
          .doc(employee.employeeID)
          .get();

      if (!oldEmployeeDoc.exists) {
        throw Exception('Employee not found');
      }

      Map<String, dynamic> oldEmployeeData = oldEmployeeDoc.data() as Map<String, dynamic>;
      String oldEmail = oldEmployeeData['email'];

      // Tạo map chứa thông tin cần cập nhật, không bao gồm email
      Map<String, dynamic> updateData = {
        'employeeName': employee.employeeName,
        'phoneNumber': employee.phoneNumber,
        'role': employee.role.toString(),
      };

      // Cập nhật thông tin employee
      await FirebaseFirestore.instance
          .collection('employees')
          .doc(employee.employeeID)
          .update(updateData);
      
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: oldEmail)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        await updateUserInformation(userSnapshot.docs.first.id, {
          'username': employee.employeeName,
          'role': employee.role == RoleEnum.owner ? 'admin' : employee.role.getName(),
        });
      }
    } catch (e) {
      print('Lỗi khi cập nhật nhân viên: $e');
      rethrow;
    }
  }

  Future<void> deleteEmployee(String employeeId) async {
    try {
      // Lấy thông tin nhân viên trước khi xóa
      DocumentSnapshot employeeDoc = await FirebaseFirestore.instance
          .collection('employees')
          .doc(employeeId)
          .get();

      if (employeeDoc.exists) {
        String employeeEmail = (employeeDoc.data() as Map<String, dynamic>)['email'];

        // Xóa nhân viên
        await FirebaseFirestore.instance
            .collection('employees')
            .doc(employeeId)
            .delete();

        // Xóa tài khoản user tương ứng
        QuerySnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: employeeEmail)
            .get();

        for (var doc in userSnapshot.docs) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(doc.id)
              .delete();
        }
      }
    } catch (e) {
      print('Lỗi khi xóa nhân viên: $e');
      rethrow;
    }
  }

  Future<void> addEmployee(Employee employee) async {
    try {
      // Kiểm tra xem email đã tồn tại chưa
      QuerySnapshot existingEmployees = await FirebaseFirestore.instance
          .collection('employees')
          .where('email', isEqualTo: employee.email)
          .get();

      if (existingEmployees.docs.isNotEmpty) {
        throw Exception('Email has already been registered');
      }

      // Thêm nhân viên mới vào collection employees
      DocumentReference docRef = await FirebaseFirestore.instance
          .collection('employees')
          .add(employee.toMap());

      // Cập nhật ID cho nhân viên
      employee.employeeID = docRef.id;

      // Thêm tài khoản user tương ứng
      await FirebaseFirestore.instance.collection('users').doc(docRef.id).set({
        'email': employee.email,
        'username': employee.employeeName,
        'userID': docRef.id,
        'role': employee.role == RoleEnum.owner ? 'admin' : employee.role.getName(),
      });

    } catch (e) {
      print('Error adding employee: $e');
      rethrow;
    }
  }

  // Manufacturer-related functions
  Future<List<Manufacturer>> getManufacturers() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('manufacturers')
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Manufacturer(
          manufacturerID: data['manufacturerID'] ?? '',
          manufacturerName: data['manufacturerName'] ?? '',
        );
      }).toList();
    } catch (e) {
      print('Error getting manufacturers list: $e');
      rethrow;
    }
  }

  Stream<List<Manufacturer>> manufacturersStream() {
    return FirebaseFirestore.instance
        .collection('manufacturers')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Manufacturer(
          manufacturerID: data['manufacturerID'] ?? '',
          manufacturerName: data['manufacturerName'] ?? '',
        );
      }).toList();
    });
  }

  Future<void> updateManufacturer(Manufacturer manufacturer) async {
    try {
      if (manufacturer.manufacturerID == null) {
        throw Exception('Manufacturer ID cannot be null');
      }

      // Find document by manufacturerID field
      final querySnapshot = await FirebaseFirestore.instance
          .collection('manufacturers')
          .where('manufacturerID', isEqualTo: manufacturer.manufacturerID)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception('Manufacturer not found');
      }

      await FirebaseFirestore.instance
          .collection('manufacturers')
          .doc(querySnapshot.docs.first.id)
          .update({
        'manufacturerID': manufacturer.manufacturerID,
        'manufacturerName': manufacturer.manufacturerName,
      });
    } catch (e) {
      print('Error updating manufacturer: $e');
      rethrow;
    }
  }

  Future<void> deleteManufacturer(String manufacturerId) async {
    try {
      // Find document by manufacturerID field
      final querySnapshot = await FirebaseFirestore.instance
          .collection('manufacturers')
          .where('manufacturerID', isEqualTo: manufacturerId)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception('Manufacturer not found');
      }

      await FirebaseFirestore.instance
          .collection('manufacturers')
          .doc(querySnapshot.docs.first.id)
          .delete();
    } catch (e) {
      print('Error deleting manufacturer: $e');
      rethrow;
    }
  }

  Future<void> createManufacturer(Manufacturer manufacturer) async {
    try {
      // Let Firestore generate the document ID
      await FirebaseFirestore.instance
          .collection('manufacturers')
          .add({
        'manufacturerID': manufacturer.manufacturerID,
        'manufacturerName': manufacturer.manufacturerName,
      });
    } catch (e) {
      print('Error creating new manufacturer: $e');
      rethrow;
    }
  }

  Future<Manufacturer?> getManufacturerById(String manufacturerId) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('manufacturers')
          .where('manufacturerID', isEqualTo: manufacturerId)
          .get();

      if (querySnapshot.docs.isEmpty) return null;

      final data = querySnapshot.docs.first.data();
      return Manufacturer(
        manufacturerID: data['manufacturerID'] ?? '',
        manufacturerName: data['manufacturerName'] ?? '',
      );
    } catch (e) {
      print('Error finding manufacturer by ID: $e');
      rethrow;
    }
  }

  Future<void> updateUserInformation(String userId, Map<String, dynamic> userData) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update(userData);
    } catch (e) {
      print('Lỗi khi cập nhật thông tin user: $e');
      rethrow;
    }
  }

  Future<bool> checkUserExistsInDatabase(String email) async {
    try {
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      return userSnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking user exists in database: $e');
      rethrow;
    }
  }

  // Product-related functions
  Future<List<Product>> getProducts() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('products')
          .get();

      List<Product> products = [];
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        
        // Lấy manufacturer từ manufacturerID
        String manufacturerId = data['manufacturerID'];
        Manufacturer? manufacturer = await getManufacturerById(manufacturerId);
        if (manufacturer == null) continue;

        // Chuyển đổi category string thành enum
        CategoryEnum category = CategoryEnum.values.firstWhere(
          (e) => e.getName() == data['category'],
          orElse: () => CategoryEnum.ram,
        );

        // Tạo product với các thuộc tính cơ bản
        Map<String, dynamic> productProps = {
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
            (e) => e.getName() == data['status'],
            orElse: () => ProductStatusEnum.active,
          ),
        };

        // Thêm các thuộc tính đặc thù theo category
        switch (category) {
          case CategoryEnum.ram:
            productProps.addAll({
              'bus': RAMBus.values.firstWhere(
                (e) => e.getName() == data['bus'],
                orElse: () => RAMBus.mhz3200,
              ),
              'capacity': RAMCapacity.values.firstWhere(
                (e) => e.getName() == data['capacity'],
                orElse: () => RAMCapacity.gb8,
              ),
              'ramType': RAMType.values.firstWhere(
                (e) => e.getName() == data['ramType'],
                orElse: () => RAMType.ddr4,
              ),
            });
            break;
          case CategoryEnum.cpu:
            productProps.addAll({
              'family': CPUFamily.values.firstWhere(
                (e) => e.getName() == data['family'],
                orElse: () => CPUFamily.corei3Ultra3,
              ),
              'core': data['core'] as int,
              'thread': data['thread'] as int,
              'clockSpeed': (data['clockSpeed'] as num).toDouble(),
            });
            break;
          case CategoryEnum.gpu:
            productProps.addAll({
              'series': GPUSeries.values.firstWhere(
                (e) => e.getName() == data['series'],
                orElse: () => GPUSeries.rtx,
              ),
              'capacity': GPUCapacity.values.firstWhere(
                (e) => e.getName() == data['capacity'],
                orElse: () => GPUCapacity.gb8,
              ),
              'busWidth': GPUBus.values.firstWhere(
                (e) => e.getName() == data['busWidth'],
                orElse: () => GPUBus.bit128,
              ),
              'clockSpeed': (data['clockSpeed'] as num).toDouble(),
            });
            break;
          case CategoryEnum.mainboard:
            productProps.addAll({
              'formFactor': MainboardFormFactor.values.firstWhere(
                (e) => e.getName() == data['formFactor'],
                orElse: () => MainboardFormFactor.atx,
              ),
              'series': MainboardSeries.values.firstWhere(
                (e) => e.getName() == data['series'],
                orElse: () => MainboardSeries.h,
              ),
              'compatibility': MainboardCompatibility.values.firstWhere(
                (e) => e.getName() == data['compatibility'],
                orElse: () => MainboardCompatibility.intel,
              ),
            });
            break;
          case CategoryEnum.drive:
            productProps.addAll({
              'type': DriveType.values.firstWhere(
                (e) => e.getName() == data['type'],
                orElse: () => DriveType.sataSSD,
              ),
              'capacity': DriveCapacity.values.firstWhere(
                (e) => e.getName() == data['capacity'],
                orElse: () => DriveCapacity.gb256,
              ),
            });
            break;
          case CategoryEnum.psu:
            productProps.addAll({
              'wattage': data['wattage'] as int,
              'efficiency': PSUEfficiency.values.firstWhere(
                (e) => e.getName() == data['efficiency'],
                orElse: () => PSUEfficiency.gold,
              ),
              'modular': PSUModular.values.firstWhere(
                (e) => e.getName() == data['modular'],
                orElse: () => PSUModular.fullModular,
              ),
            });
            break;
        }

        // Tạo product instance thông qua factory
        Product product = ProductFactory.createProduct(category, productProps);
        products.add(product);
      }

      return products;
    } catch (e) {
      print('Error getting products: $e');
      rethrow;
    }
  }

  Stream<List<Product>> productsStream() {
    return FirebaseFirestore.instance
        .collection('products')
        .snapshots()
        .asyncMap((snapshot) async {
      List<Product> products = [];
      for (var doc in snapshot.docs) {
        try {
          Map<String, dynamic> data = doc.data();
          
          String manufacturerId = data['manufacturerID'];
          Manufacturer? manufacturer = await getManufacturerById(manufacturerId);
          if (manufacturer == null) continue;

          CategoryEnum category = CategoryEnum.values.firstWhere(
            (e) => e.getName() == data['category'],
            orElse: () => CategoryEnum.ram,
          );

          Map<String, dynamic> productProps = {
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
              (e) => e.getName() == data['status'],
              orElse: () => ProductStatusEnum.active,
            ),
          };

          switch (category) {
            case CategoryEnum.ram:
              productProps.addAll({
                'bus': RAMBus.values.firstWhere(
                  (e) => e.getName() == data['bus'],
                  orElse: () => RAMBus.mhz3200,
                ),
                'capacity': RAMCapacity.values.firstWhere(
                  (e) => e.getName() == data['capacity'],
                  orElse: () => RAMCapacity.gb8,
                ),
                'ramType': RAMType.values.firstWhere(
                  (e) => e.getName() == data['ramType'],
                  orElse: () => RAMType.ddr4,
                ),
              });
              break;

            case CategoryEnum.cpu:
              productProps.addAll({
                'family': CPUFamily.values.firstWhere(
                  (e) => e.getName() == data['family'],
                  orElse: () => CPUFamily.corei3Ultra3,
                ),
                'core': data['core'],
                'thread': data['thread'],
                'clockSpeed': (data['clockSpeed'] as num).toDouble(),
              });
              break;

            case CategoryEnum.gpu:
              productProps.addAll({
                'series': GPUSeries.values.firstWhere(
                  (e) => e.getName() == data['series'],
                  orElse: () => GPUSeries.rtx,
                ),
                'capacity': GPUCapacity.values.firstWhere(
                  (e) => e.getName() == data['capacity'],
                  orElse: () => GPUCapacity.gb4,
                ),
                'busWidth': GPUBus.values.firstWhere(
                  (e) => e.getName() == data['busWidth'],
                  orElse: () => GPUBus.bit128,
                ),
                'clockSpeed': (data['clockSpeed'] as num).toDouble(),
              });
              break;

            case CategoryEnum.mainboard:
              productProps.addAll({
                'formFactor': MainboardFormFactor.values.firstWhere(
                  (e) => e.getName() == data['formFactor'],
                  orElse: () => MainboardFormFactor.atx,
                ),
                'series': MainboardSeries.values.firstWhere(
                  (e) => e.getName() == data['series'],
                  orElse: () => MainboardSeries.h,
                ),
                'compatibility': MainboardCompatibility.values.firstWhere(
                  (e) => e.getName() == data['compatibility'],
                  orElse: () => MainboardCompatibility.intel,
                ),
              });
              break;

            case CategoryEnum.drive:
              productProps.addAll({
                'type': DriveType.values.firstWhere(
                  (e) => e.getName() == data['type'],
                  orElse: () => DriveType.sataSSD,
                ),
                'capacity': DriveCapacity.values.firstWhere(
                  (e) => e.getName() == data['capacity'],
                  orElse: () => DriveCapacity.gb256,
                ),
              });
              break;

            case CategoryEnum.psu:
              productProps.addAll({
                'wattage': data['wattage'] as int,
                'efficiency': PSUEfficiency.values.firstWhere(
                  (e) => e.getName() == data['efficiency'],
                  orElse: () => PSUEfficiency.bronze,
                ),
                'modular': PSUModular.values.firstWhere(
                  (e) => e.getName() == data['modular'],
                  orElse: () => PSUModular.nonModular,
                ),
              });
              break;
          }

          Product product = ProductFactory.createProduct(category, productProps);
          products.add(product);
        } catch (e) {
          print('Error processing product ${doc.id}: $e');
          continue;
        }
      }
      return products;
    });
  }

  Future<void> changeProductStatus(String productId, ProductStatusEnum status) async {
    try {
      await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .update({'status': status.getName()});

      List<Product> products = await getProducts();
      Database().updateProductList(products);
    } catch (e) {
      print('Error changing product status: $e');
      rethrow;
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      Map<String, dynamic> productData = {
        'productName': product.productName,
        'importPrice': product.importPrice,
        'sellingPrice': product.sellingPrice,
        'discount': product.discount,
        'release': product.release,
        'sales': product.sales,
        'stock': product.stock,
        'status': product.status.getName(),
        'manufacturerID': product.manufacturer.manufacturerID,
        'category': product.category.getName(),
      };

      switch (product.runtimeType) {
        case RAM:
          final ram = product as RAM;
          productData.addAll({
            'bus': ram.bus.getName(),
            'capacity': ram.capacity.getName(),
            'ramType': ram.ramType.getName(),
          });
          break;

        case CPU:
          final cpu = product as CPU;
          productData.addAll({
            'family': cpu.family.getName(),
            'core': cpu.core,
            'thread': cpu.thread,
            'clockSpeed': cpu.clockSpeed,
          });
          break;

        case GPU:
          final gpu = product as GPU;
          productData.addAll({
            'series': gpu.series.getName(),
            'capacity': gpu.capacity.getName(),
            'busWidth': gpu.bus.getName(),
            'clockSpeed': gpu.clockSpeed,
          });
          break;

        case Mainboard:
          final mainboard = product as Mainboard;
          productData.addAll({
            'formFactor': mainboard.formFactor.getName(),
            'series': mainboard.series.getName(),
            'compatibility': mainboard.compatibility.getName(),
          });
          break;

        case Drive:
          final drive = product as Drive;
          productData.addAll({
            'type': drive.type.getName(),
            'capacity': drive.capacity.getName(),
          });
          break;

        case PSU:
          final psu = product as PSU;
          productData.addAll({
            'wattage': psu.wattage,
            'efficiency': psu.efficiency.getName(),
            'modular': psu.modular.getName(),
          });
          break;
      }

      await FirebaseFirestore.instance
          .collection('products')
          .doc(product.productID)
          .update(productData);

      List<Product> products = await getProducts();
      Database().updateProductList(products);
    } catch (e) {
      print('Error updating product: $e');
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    try {
      Map<String, dynamic> productData = {
        'productName': product.productName,
        'importPrice': product.importPrice,
        'sellingPrice': product.sellingPrice,
        'discount': product.discount,
        'release': product.release,
        'sales': product.sales,
        'stock': product.stock,
        'status': product.status.getName(),
        'manufacturerID': product.manufacturer.manufacturerID,
        'category': product.category.getName(),
      };

      switch (product.runtimeType) {
        case RAM:
          final ram = product as RAM;
          productData.addAll({
            'bus': ram.bus.getName(),
            'capacity': ram.capacity.getName(),
            'ramType': ram.ramType.getName(),
          });
          break;

        case CPU:
          final cpu = product as CPU;
          productData.addAll({
            'family': cpu.family.getName(),
            'core': cpu.core,
            'thread': cpu.thread,
            'clockSpeed': cpu.clockSpeed,
          });
          break;

        case GPU:
          final gpu = product as GPU;
          productData.addAll({
            'series': gpu.series.getName(),
            'capacity': gpu.capacity.getName(),
            'busWidth': gpu.bus.getName(),
            'clockSpeed': gpu.clockSpeed,
          });
          break;

        case Mainboard:
          final mainboard = product as Mainboard;
          productData.addAll({
            'formFactor': mainboard.formFactor.getName(),
            'series': mainboard.series.getName(),
            'compatibility': mainboard.compatibility.getName(),
          });
          break;

        case Drive:
          final drive = product as Drive;
          productData.addAll({
            'type': drive.type.getName(),
            'capacity': drive.capacity.getName(),
          });
          break;

        case PSU:
          final psu = product as PSU;
          productData.addAll({
            'wattage': psu.wattage,
            'efficiency': psu.efficiency.getName(),
            'modular': psu.modular.getName(),
          });
          break;
      }

      await FirebaseFirestore.instance.collection('products').add(productData);
      List<Product> products = await getProducts();
      Database().updateProductList(products);
    } catch (e) {
      print('Error adding product: $e');
      rethrow;
    }
  }
}