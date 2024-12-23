class Customer {
  final String customerID;
  final String customerName;
  final String phoneNumber;
  final String email;
  final bool banStatus;

  Customer({
    required this.customerID,
    required this.customerName,
    required this.phoneNumber,
    required this.email,
    this.banStatus = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'customerName': customerName,
      'phoneNumber': phoneNumber,
      'email': email,
      'banStatus': banStatus,
    };
  }

  factory Customer.fromMap(String id, Map<String, dynamic> map) {
    return Customer(
      customerID: id,
      customerName: map['customerName'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      email: map['email'] ?? '',
      banStatus: map['banStatus'] ?? false,
    );
  }
} 