import 'package:prescription_management_system/domain/doctor.domain.dart';
import 'package:prescription_management_system/domain/medicine.domain.dart';
import 'package:prescription_management_system/domain/prescription_system.domain.dart';
import 'package:prescription_management_system/ui/main.ui.dart';

void main() {
  final system = PrescriptionSystem();
  final ui = MainUI(system);

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

  ui.showMainMenu();
}