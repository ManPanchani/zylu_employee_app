import 'package:flutter/material.dart';

import '../../../data/models/employee_model.dart';

class EmployeeDetailPage extends StatelessWidget {
  final EmployeeModel employee;

  const EmployeeDetailPage({super.key, required this.employee});

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final isFivePlus = employee.isMoreThanFiveYears;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Employee Profile',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFFE5E7EB)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.035),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 82,
                    height: 82,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE7F5F3),
                      borderRadius: BorderRadius.circular(26),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      employee.initials,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F766E),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    employee.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    employee.designation,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      employee.employeeId,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF374151),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            if (isFivePlus)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF8EF),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFFB7E4C7)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.verified_rounded, color: Color(0xFF16803C)),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'This employee has been active for more than 5 years.',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF166534),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 16),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Column(
                children: [
                  _InfoRow(
                    icon: Icons.badge_outlined,
                    title: 'Employee ID',
                    value: employee.employeeId,
                  ),
                  _Divider(),
                  _InfoRow(
                    icon: Icons.work_outline_rounded,
                    title: 'Designation',
                    value: employee.designation,
                  ),
                  _Divider(),
                  _InfoRow(
                    icon: Icons.calendar_today_outlined,
                    title: 'Joining Date',
                    value: _formatDate(employee.joiningDate),
                  ),
                  _Divider(),
                  _InfoRow(
                    icon: Icons.timelapse_rounded,
                    title: 'Experience',
                    value: '${employee.experienceYears} years',
                  ),
                  _Divider(),
                  _InfoRow(
                    icon: employee.isActive
                        ? Icons.check_circle_outline_rounded
                        : Icons.cancel_outlined,
                    title: 'Status',
                    value: employee.isActive ? 'Active' : 'Inactive',
                    valueColor: employee.isActive
                        ? const Color(0xFF16803C)
                        : const Color(0xFF6B7280),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color? valueColor;

  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: const Color(0xFFF3F7F7),
            borderRadius: BorderRadius.circular(11),
          ),
          child: Icon(icon, size: 19, color: const Color(0xFF0F766E)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF9CA3AF),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: valueColor ?? const Color(0xFF111827),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 14),
      child: Divider(height: 1, color: Color(0xFFF0F1F3)),
    );
  }
}
