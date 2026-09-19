import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/employee_model.dart';

class ApiService {
  static const String baseUrl =
      'http://192.168.1.4/employee_api';

  Future<List<EmployeeModel>> getEmployees() async {
    final url = Uri.parse('$baseUrl/employees.php');

    try {
      final response = await http
          .get(url)
          .timeout(const Duration(seconds: 15));

      if (response.statusCode != 200) {
        throw Exception(
          'Server error: ${response.statusCode}',
        );
      }

      final Map<String, dynamic> responseData =
      jsonDecode(response.body);

      if (responseData['success'] != true) {
        throw Exception(
          responseData['message'] ??
              'Unable to fetch employees',
        );
      }

      final List data = responseData['data'] ?? [];

      return data
          .map(
            (employee) => EmployeeModel.fromJson(
          Map<String, dynamic>.from(employee),
        ),
      )
          .toList();
    } catch (e) {
      throw Exception(
        'Unable to connect to server. Please try again.',
      );
    }
  }

  Future<void> addEmployee({
    required String name,
    required String designation,
    required String joiningDate,
    required bool isActive,
  }) async {
    final url = Uri.parse('$baseUrl/add_employee.php');

    final response = await http
        .post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'name': name,
        'designation': designation,
        'joining_date': joiningDate,
        'is_active': isActive ? 1 : 0,
      }),
    )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      throw Exception(
        'Server error: ${response.statusCode}',
      );
    }

    final data = jsonDecode(response.body);

    if (data['success'] != true) {
      throw Exception(
        data['message'] ?? 'Failed to add employee',
      );
    }
  }
}