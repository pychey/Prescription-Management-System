import 'package:prescription_management_system/domain/doctor.domain.dart';
import 'package:prescription_management_system/domain/medicine.domain.dart';
import 'package:prescription_management_system/domain/prescription_system.domain.dart';
import 'package:prescription_management_system/ui/admin.ui.dart';
import 'package:prescription_management_system/ui/base.ui.dart';
import 'package:prescription_management_system/ui/doctor.ui.dart';

class MainUI extends BaseUI {
  late DoctorUI doctorUI;
  late AdminUI adminUI;

  MainUI(PrescriptionSystem system) : super(system) {
    doctorUI = DoctorUI(system);
    adminUI = AdminUI(system);
  }

  void showMainMenu() {
    while (true) {
      clearScreen();
      showHeader('PRESCRIPTION MANAGEMENT SYSTEM');
      print('1. Login as Doctor');
      print('2. Admin Access');
      print('0. Exit');
      print('═══════════════════════════════════════');

      final choice = readInput('Select option: ');

      switch (choice) {
        case '1':
          handleLogin();
          break;
        case '2':
          adminUI.showAdminMenu();
          break;
        case '0':
          print('\nGoodbye!');
          return;
        default:
          print('Invalid option.');
          pause();
      }
    }
  }

  void handleLogin() {
    clearScreen();
    showHeader('DOCTOR LOGIN');

    if (system.doctors.isEmpty) {
      print('No doctors registered. Please contact admin.');
      pause();
      return;
    }

    print('Available doctors:');
    for (var doctor in system.doctors) {
      print('• Username: ${doctor.username}');
    }
    print('');

    final username = readInput('Enter username: ');
    final password = readInput('Enter password: ');

    if (system.login(username, password)) {
      print('\n✓ Login successful! Welcome, Dr. ${system.currentDoctor!.name}');
      pause();
      doctorUI.showDoctorMenu();
    } else {
      print('\n✗ Invalid credentials.');
      pause();
    }
  }
}

// ============================================================
// MAIN - main.dart
// ============================================================

void main() {
  final system = PrescriptionSystem();
  final ui = MainUI(system);

  // Sample data for testing
  system.registerDoctor(Doctor(
    id: 'DR001',
    name: 'John Smith',
    username: 'drjohn',
    password: 'pass123',
  ));

  system.addMedicine(Medicine(
    id: 'MED001',
    name: 'Paracetamol',
    stockQuantity: 100,
    price: 5.99,
    usage: 'Pain relief and fever reduction',
    expiryDate: DateTime(2026, 12, 31),
  ));

  system.addMedicine(Medicine(
    id: 'MED002',
    name: 'Amoxicillin',
    stockQuantity: 50,
    price: 12.50,
    usage: 'Antibiotic for bacterial infections',
    expiryDate: DateTime(2025, 6, 30),
  ));

  system.addMedicine(Medicine(
    id: 'MED003',
    name: 'Ibuprofen',
    stockQuantity: 75,
    price: 8.99,
    usage: 'Anti-inflammatory and pain relief',
    expiryDate: DateTime(2026, 3, 15),
  ));

  // Start the application
  ui.showMainMenu();
}