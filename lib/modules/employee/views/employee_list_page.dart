import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/employee_controller.dart';
import '../widgets/employee_card.dart';
import 'add_employee_page.dart';
import 'employee_detail_page.dart';

class EmployeeListPage extends StatelessWidget {
  EmployeeListPage({super.key});

  final EmployeeController controller = Get.put(EmployeeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Employees',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.w800),
            ),
            SizedBox(height: 2),
            Text(
              'Manage your team',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20),
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Color(0xFFE5E7EB)),
            ),
            child: const Icon(Icons.groups_rounded, color: Color(0xFF0F766E)),
          ),
          const SizedBox(width: 4),
        ],
      ),

      body: SafeArea(
        child: Column(
          children: [
            // Dashboard has its own Obx
            _DashboardHeader(),

            // Search
            _SearchBar(controller: controller),

            // Employee content has its own Obx
            Expanded(child: _EmployeeContent(controller: controller)),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.to(() => AddEmployeePage(), transition: Transition.rightToLeft);
        },
        backgroundColor: const Color(0xFF0F766E),
        foregroundColor: Colors.white,
        elevation: 4,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Add Employee',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

// ============================================================
// DASHBOARD HEADER
// ============================================================

class _DashboardHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final controller = Get.find<EmployeeController>();

      final totalEmployees = controller.employees.length;

      final fivePlusEmployees = controller.employees
          .where((employee) => employee.isMoreThanFiveYears)
          .length;

      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        child: Row(
          children: [
            Expanded(
              child: _SummaryCard(
                icon: Icons.people_alt_rounded,
                title: 'Total',
                value: totalEmployees.toString(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _SummaryCard(
                icon: Icons.verified_rounded,
                title: '5+ Years',
                value: fivePlusEmployees.toString(),
              ),
            ),
          ],
        ),
      );
    });
  }
}

// ============================================================
// SUMMARY CARD
// ============================================================

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _SummaryCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFE7F5F3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF0F766E), size: 21),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF111827),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// SEARCH BAR
// ============================================================

class _SearchBar extends StatelessWidget {
  final EmployeeController controller;

  const _SearchBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
      child: TextField(
        onChanged: controller.searchEmployees,
        decoration: InputDecoration(
          hintText: 'Search employee, ID or designation',
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: Color(0xFF6B7280),
          ),
          suffixIcon: Obx(() {
            if (controller.searchQuery.value.isEmpty) {
              return const SizedBox.shrink();
            }

            return IconButton(
              onPressed: () {
                controller.searchEmployees('');
              },
              icon: const Icon(Icons.close_rounded),
            );
          }),
        ),
      ),
    );
  }
}

// ============================================================
// EMPLOYEE CONTENT
// ============================================================

class _EmployeeContent extends StatelessWidget {
  final EmployeeController controller;

  const _EmployeeContent({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Loading
      if (controller.isLoading.value && controller.employees.isEmpty) {
        return const Center(
          child: CircularProgressIndicator(color: Color(0xFF0F766E)),
        );
      }

      // Error
      if (controller.errorMessage.value.isNotEmpty &&
          controller.employees.isEmpty) {
        return _ErrorView(controller: controller);
      }

      // Empty
      if (controller.filteredEmployees.isEmpty) {
        return _EmptyView(isSearching: controller.searchQuery.value.isNotEmpty);
      }

      // Employee List
      return RefreshIndicator(
        color: const Color(0xFF0F766E),
        onRefresh: controller.fetchEmployees,
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 2, 20, 100),
          itemCount: controller.filteredEmployees.length,
          itemBuilder: (context, index) {
            final employee = controller.filteredEmployees[index];

            return EmployeeCard(
              employee: employee,
              onTap: () {
                Get.to(
                  () => EmployeeDetailPage(employee: employee),
                  transition: Transition.rightToLeft,
                );
              },
            );
          },
        ),
      );
    });
  }
}

// ============================================================
// ERROR VIEW
// ============================================================

class _ErrorView extends StatelessWidget {
  final EmployeeController controller;

  const _ErrorView({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              size: 56,
              color: Color(0xFF9CA3AF),
            ),
            const SizedBox(height: 14),
            const Text(
              'Unable to load employees',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 7),
            Text(
              controller.errorMessage.value,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF6B7280)),
            ),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              onPressed: controller.fetchEmployees,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// EMPTY VIEW
// ============================================================

class _EmptyView extends StatelessWidget {
  final bool isSearching;

  const _EmptyView({required this.isSearching});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSearching
                  ? Icons.search_off_rounded
                  : Icons.people_outline_rounded,
              size: 62,
              color: const Color(0xFFCBD5E1),
            ),
            const SizedBox(height: 14),
            Text(
              isSearching ? 'No employees found' : 'No employees yet',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            Text(
              isSearching
                  ? 'Try a different search term.'
                  : 'Add your first employee to get started.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF6B7280)),
            ),
          ],
        ),
      ),
    );
  }
}
