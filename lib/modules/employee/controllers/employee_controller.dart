import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../data/models/employee_model.dart';
import '../../../data/services/api_service.dart';

class EmployeeController extends GetxController {
  final ApiService apiService = ApiService();

  final employees = <EmployeeModel>[].obs;
  final filteredEmployees = <EmployeeModel>[].obs;

  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();

    ever(searchQuery, (_) {
      _filterEmployees();
    });

    fetchEmployees();
  }

  Future<void> fetchEmployees() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await apiService.getEmployees();

      employees.assignAll(result);
      _filterEmployees();
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  void searchEmployees(String query) {
    searchQuery.value = query.trim();
  }

  void _filterEmployees() {
    final query = searchQuery.value.toLowerCase();

    if (query.isEmpty) {
      filteredEmployees.assignAll(employees);
      return;
    }

    filteredEmployees.assignAll(
      employees.where(
        (employee) =>
            employee.name.toLowerCase().contains(query) ||
            employee.employeeId.toLowerCase().contains(query) ||
            employee.designation.toLowerCase().contains(query),
      ),
    );
  }

  Future<bool> addEmployee({
    required String name,
    required String designation,
    required String joiningDate,
    required bool isActive,
  }) async {
    try {
      isLoading.value = true;

      await apiService.addEmployee(
        name: name,
        designation: designation,
        joiningDate: joiningDate,
        isActive: isActive,
      );

      await fetchEmployees();

      return true;
    } catch (e) {
      Get.snackbar(
        'Unable to add employee',
        e.toString().replaceFirst('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.all(16),
        borderRadius: 14,
      );

      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
