import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/employee_controller.dart';

class AddEmployeePage extends StatefulWidget {
  const AddEmployeePage({super.key});

  @override
  State<AddEmployeePage> createState() =>
      _AddEmployeePageState();
}

class _AddEmployeePageState extends State<AddEmployeePage> {
  final EmployeeController controller =
  Get.find<EmployeeController>();

  final nameController = TextEditingController();
  final designationController = TextEditingController();
  final joiningDateController = TextEditingController();

  bool isActive = true;
  DateTime? selectedDate;

  @override
  void dispose() {
    nameController.dispose();
    designationController.dispose();
    joiningDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
      helpText: 'Select joining date',
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
        joiningDateController.text =
            DateFormat('yyyy-MM-dd').format(date);
      });
    }
  }

  Future<void> _saveEmployee() async {
    FocusScope.of(context).unfocus();

    final name = nameController.text.trim();
    final designation = designationController.text.trim();

    if (name.isEmpty) {
      _showMessage(
        'Employee name is required',
        isError: true,
      );
      return;
    }

    if (designation.isEmpty) {
      _showMessage(
        'Designation is required',
        isError: true,
      );
      return;
    }

    if (selectedDate == null) {
      _showMessage(
        'Please select joining date',
        isError: true,
      );
      return;
    }

    final success = await controller.addEmployee(
      name: name,
      designation: designation,
      joiningDate:
      DateFormat('yyyy-MM-dd').format(selectedDate!),
      isActive: isActive,
    );

    if (!mounted) return;

    if (success) {
      Get.back();

      Get.snackbar(
        'Employee Added',
        'Employee has been added successfully.',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 14,
        backgroundColor: const Color(0xFF16803C),
        colorText: Colors.white,
        icon: const Icon(
          Icons.check_circle_rounded,
          color: Colors.white,
        ),
      );
    }
  }

  void _showMessage(
      String message, {
        bool isError = false,
      }) {
    Get.snackbar(
      isError ? 'Required' : 'Success',
      message,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      borderRadius: 14,
      backgroundColor: isError
          ? const Color(0xFFB42318)
          : const Color(0xFF16803C),
      colorText: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: Get.back,
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text(
          'Add Employee',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(),
              const SizedBox(height: 25),

              _FieldLabel(
                label: 'Employee name',
                required: true,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: nameController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  hintText: 'e.g. Rahul Sharma',
                  prefixIcon: Icon(
                    Icons.person_outline_rounded,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              _FieldLabel(
                label: 'Designation',
                required: true,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: designationController,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  hintText: 'e.g. Flutter Developer',
                  prefixIcon: Icon(
                    Icons.work_outline_rounded,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              _FieldLabel(
                label: 'Joining date',
                required: true,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: joiningDateController,
                readOnly: true,
                onTap: _selectDate,
                decoration: const InputDecoration(
                  hintText: 'Select joining date',
                  prefixIcon: Icon(
                    Icons.calendar_today_outlined,
                  ),
                  suffixIcon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFE5E7EB),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF8EF),
                        borderRadius:
                        BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.verified_outlined,
                        color: Color(0xFF16803C),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Employee status',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            'Set whether this employee is active.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch.adaptive(
                      value: isActive,
                      activeColor: const Color(0xFF0F766E),
                      onChanged: (value) {
                        setState(() {
                          isActive = value;
                        });
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              Obx(
                    () => SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : _saveEmployee,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      const Color(0xFF0F766E),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(15),
                      ),
                    ),
                    child: controller.isLoading.value
                        ? const SizedBox(
                      width: 22,
                      height: 22,
                      child:
                      CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                        : const Text(
                      'Save Employee',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              const Center(
                child: Text(
                  'Employee ID will be generated automatically.',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE7F5F3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.person_add_alt_1_rounded,
            size: 34,
            color: Color(0xFF0F766E),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'Create employee profile',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF134E4A),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Add the employee details below.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF4B5563),
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

class _FieldLabel extends StatelessWidget {
  final String label;
  final bool required;

  const _FieldLabel({
    required this.label,
    this.required = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF374151),
          ),
        ),
        if (required)
          const Text(
            ' *',
            style: TextStyle(
              color: Color(0xFFB42318),
            ),
          ),
      ],
    );
  }
}