import 'package:prescription_management_system/domain/doctor.domain.dart';
import 'package:prescription_management_system/domain/medicine.domain.dart';
import 'package:prescription_management_system/domain/prescription_system.domain.dart';
import 'package:prescription_management_system/ui/system.ui.dart';

void main() {
  final system = PrescriptionSystem();
  final ui = SystemConsole(system);

  system.registerDoctor(Doctor(
    id: 'DR001',
    name: 'Ronan The Best',
    username: 'pychey',
    password: 'pychey',
  ));

  system.addMedicine(Medicine(
    id: 'MED001',
    name: 'Paracetamol',
    stockQuantity: 100,
    price: 5.99,
    usage: 'Pain Relief and Fever Reduction',
    expiryDate: DateTime(2026, 12, 31),
  ));

  system.addMedicine(Medicine(
    id: 'MED002',
    name: 'Amoxicillin',
    stockQuantity: 50,
    price: 12.50,
    usage: 'Antibiotic for Bacterial Infections',
    expiryDate: DateTime(2025, 6, 30),
  ));

  system.addMedicine(Medicine(
    id: 'MED003',
    name: 'Ibuprofen',
    stockQuantity: 75,
    price: 8.99,
    usage: 'Anti-Inflammatory and Pain Relief',
    expiryDate: DateTime(2026, 3, 15),
  ));

  ui.showMainMenu();
}