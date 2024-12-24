class Customer {
  String? customerID;
  String customerName;
  String email;
  String phoneNumber;

  Customer({
    this.customerID,
    required this.customerName,
    required this.email,
    required this.phoneNumber,
  });

  Customer copyWith({
    String? customerID,
    String? customerName,
    String? email,
    String? phoneNumber,
    bool? banStatus,
  }) {
    return Customer(
      customerID: customerID ?? this.customerID,
      customerName: customerName ?? this.customerName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'customerName': customerName,
      'email': email,
      'phoneNumber': phoneNumber,
    };
  }

  static Customer fromMap(String id, Map<String, dynamic> map) {
    return Customer(
      customerID: id,
      customerName: map['customerName'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
    );
  }
} 