class EmployeeModel {
  final int id;
  final String employeeId;
  final String name;
  final String designation;
  final DateTime joiningDate;
  final bool isActive;
  final String createdAt;

  EmployeeModel({
    required this.id,
    required this.employeeId,
    required this.name,
    required this.designation,
    required this.joiningDate,
    required this.isActive,
    required this.createdAt,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      employeeId: json['employee_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      designation: json['designation']?.toString() ?? '',
      joiningDate: DateTime.tryParse(
        json['joining_date']?.toString() ?? '',
      ) ??
          DateTime.now(),
      isActive: json['is_active'].toString() == '1' ||
          json['is_active'].toString().toLowerCase() == 'true',
      createdAt: json['created_at']?.toString() ?? '',
    );
  }

  bool get isMoreThanFiveYears {
    if (!isActive) return false;

    final today = DateTime.now();

    final fiveYearsAgo = DateTime(
      today.year - 5,
      today.month,
      today.day,
    );

    return joiningDate.isBefore(fiveYearsAgo);
  }

  int get experienceYears {
    final today = DateTime.now();

    int years = today.year - joiningDate.year;

    if (today.month < joiningDate.month ||
        (today.month == joiningDate.month &&
            today.day < joiningDate.day)) {
      years--;
    }

    return years < 0 ? 0 : years;
  }

  String get initials {
    final parts = name
        .trim()
        .split(' ')
        .where((element) => element.isNotEmpty)
        .toList();

    if (parts.isEmpty) return '?';

    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }

    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}