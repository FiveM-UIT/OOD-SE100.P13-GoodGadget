class Employee {
  String? employeeID;
  String employeeName;
  String email;
  String phoneNumber;
  String role;
  bool isActive;

  Employee({
    this.employeeID,
    required this.employeeName,
    required this.email,
    required this.phoneNumber,
    required this.role,
    this.isActive = true,
  });

  Employee copyWith({
    String? employeeID,
    String? employeeName,
    String? email,
    String? phoneNumber,
    String? role,
    bool? isActive,
  }) {
    return Employee(
      employeeID: employeeID ?? this.employeeID,
      employeeName: employeeName ?? this.employeeName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'employeeName': employeeName,
      'email': email,
      'phoneNumber': phoneNumber,
      'role': role,
      'isActive': isActive,
    };
  }

  static Employee fromMap(String id, Map<String, dynamic> map) {
    return Employee(
      employeeID: id,
      employeeName: map['employeeName'] ?? '',
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      role: map['role'] ?? '',
      isActive: map['isActive'] ?? true,
    );
  }
} 