import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/database/database.dart';
import 'package:gizmoglobe_client/objects/product_related/cpu.dart';
import 'package:gizmoglobe_client/objects/product_related/drive.dart';
import 'package:gizmoglobe_client/objects/product_related/gpu.dart';
import 'package:gizmoglobe_client/objects/product_related/mainboard.dart';
import 'package:gizmoglobe_client/objects/product_related/psu.dart';
import 'package:gizmoglobe_client/objects/product_related/ram.dart';

import '../../objects/customer.dart';
import '../../objects/employee.dart';
import '../../objects/manufacturer.dart';

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

class Firebase {
  static final Firebase _firebase = Firebase._internal();

  factory Firebase() {
    return _firebase;
  }

  Firebase._internal();

  Future<void> pushCustomerSampleData() async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Generate sample data
      Database().generateSampleData();

      // Push customers
      for (var customer in Database().customerList) {
        DocumentReference docRef = await firestore.collection('customers').add(
          customer.toMap(),
        );
        customer.customerID = docRef.id;
      }

      // Push employees
      for (var employee in Database().employeeList) {
        DocumentReference docRef = await firestore.collection('employees').add(
          employee.toMap(),
        );
        employee.employeeID = docRef.id;
      }

      // Sync users with customers
      QuerySnapshot userSnapshot = await firestore
          .collection('users')
          .where('role', isEqualTo: 'customer')
          .get();

      for (var doc in userSnapshot.docs) {
        // Check if user exists in customers
        QuerySnapshot existingCustomer = await firestore
            .collection('customers')
            .where('email', isEqualTo: doc['email'])
            .get();

        // Add if not exists
        if (existingCustomer.docs.isEmpty) {
          await firestore.collection('customers').add({
            'customerName': doc['username'] ?? '',
            'phoneNumber': doc['phoneNumber'] ?? '',
            'email': doc['email'] ?? '',
          });
        }
      }

      // Sync users with employees
      // QuerySnapshot employeeUserSnapshot = await firestore
      //     .collection('users')
      //     .where('role', isEqualTo: 'employee')
      //     .get();
      //
      // for (var doc in employeeUserSnapshot.docs) {
      //   // Check if user exists in employees
      //   QuerySnapshot existingEmployee = await firestore
      //       .collection('employees')
      //       .where('email', isEqualTo: doc['email'])
      //       .get();
      //
      //   // Add if not exists
      //   if (existingEmployee.docs.isEmpty) {
      //     await firestore.collection('employees').add({
      //       'employeeName': doc['username'] ?? '',
      //       'phoneNumber': doc['phoneNumber'] ?? '',
      //       'email': doc['email'] ?? '',
      //     });
      //   }

      print('Successfully pushed and synced customer and employee data');
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
      
      await FirebaseFirestore.instance
          .collection('customers')
          .doc(customer.customerID)
          .update({
        'customerName': customer.customerName,
        'email': customer.email,
        'phoneNumber': customer.phoneNumber,
      });
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
          .where('email', isEqualTo: customerId)
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
      DocumentReference docRef = await FirebaseFirestore.instance
          .collection('customers')
          .add(customer.toMap());
      
      customer.customerID = docRef.id;
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
      
      await FirebaseFirestore.instance
          .collection('employees')
          .doc(employee.employeeID)
          .update(employee.toMap());
    } catch (e) {
      print('Lỗi khi cập nhật nhân viên: $e');
      rethrow;
    }
  }

  Future<void> deleteEmployee(String employeeId) async {
    try {
      await FirebaseFirestore.instance
          .collection('employees')
          .doc(employeeId)
          .delete();

      // Delete associated user account if exists
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: employeeId)
          .get();

      for (var doc in userSnapshot.docs) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(doc.id)
            .delete();
      }
    } catch (e) {
      print('Lỗi khi xóa nhân viên: $e');
      rethrow;
    }
  }

  Future<void> createEmployee(Employee employee) async {
    try {
      DocumentReference docRef = await FirebaseFirestore.instance
          .collection('employees')
          .add(employee.toMap());
      
      employee.employeeID = docRef.id;
    } catch (e) {
      print('Lỗi khi tạo nhân viên mới: $e');
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

      // TODO: Add logic to handle related products
      // Example: Mark products as discontinued or delete them
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
}