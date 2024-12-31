import 'package:gizmoglobe_client/enums/stakeholders/employee_role.dart';
import 'package:gizmoglobe_client/objects/employee.dart';

class EmployeePermissions {
  static bool canViewEmployees(String? userRole) {
    return userRole != null;  // All authenticated users can view
  }

  static bool canAddEmployees(String? userRole) {
    return userRole == 'owner' || userRole == 'manager';
  }

  static bool canEditEmployee(String? userRole, Employee employee) {
    if (employee.role == RoleEnum.owner) {
      return false;  // Owner accounts are read-only
    }
    if (userRole == 'owner') {
      return true;  // Owner can edit all except owner accounts
    }
    if (userRole == 'manager') {
      return employee.role != RoleEnum.owner && employee.role != RoleEnum.manager;  // Managers can edit employees only
    }
    return false;  // Employees can't edit
  }

  static bool canDeleteEmployee(String? userRole, Employee employee) {
    if (employee.role == RoleEnum.owner) {
      return false;  // Owner accounts can't be deleted
    }
    return userRole == 'owner';  // Only owner can delete
  }
} 