# Zylu Employee Management App

A Flutter-based Employee Management application developed as part of the Zylu Flutter Developer assignment.

## Features

- View all employees
- Add new employees
- Automatically generate Employee ID
- Search employees by name, ID or designation
- View employee details
- Display joining date
- Active/Inactive employee status
- Highlight active employees with more than 5 years of experience in green
- Pull-to-refresh employee list

## Tech Stack

### Mobile App
- Flutter
- Dart
- GetX
- HTTP

### Backend
- PHP
- MySQL
- XAMPP

## Project Structure

```text
lib/
├── data/
│   ├── models/
│   │   └── employee_model.dart
│   └── services/
│       └── api_service.dart
│
├── modules/
│   └── employee/
│       ├── controllers/
│       ├── views/
│       └── widgets/
│
└── main.dart

backend/
├── config.php
├── employees.php
├── add_employee.php
└── database.sql