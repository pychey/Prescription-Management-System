import 'package:prescription_management_system/domain/doctor.domain.dart';
import 'package:prescription_management_system/domain/medicine.domain.dart';
import 'package:prescription_management_system/domain/patient.domain.dart';
import 'package:prescription_management_system/domain/prescription_item.domain.dart';
import 'package:prescription_management_system/domain/prescription_system.domain.dart';
import 'package:prescription_management_system/ui/system.ui.dart';

void main() {
  var system = PrescriptionSystem();
  var ui = SystemConsole(system);

  system.addMedicine(Medicine(
    id: 'MED001',
    name: 'SiemReap Paracetamol',
    stockQuantity: 100,
    price: 5.99,
    usage: 'No More Hurt (Pain/Fever)',
    expiryDate: DateTime(2026, 12, 31),
  ));

  system.addMedicine(Medicine(
    id: 'MED002',
    name: 'SiemReap Amoxicillin',
    stockQuantity: 50,
    price: 12.50,
    usage: 'Antibiotic For Bacterial Infections',
    expiryDate: DateTime(2025, 6, 30),
  ));

  system.addMedicine(Medicine(
    id: 'MED003',
    name: 'SiemReap Ibuprofen',
    stockQuantity: 75,
    price: 8.99,
    usage: 'No More Hurt (Anti-Inflammatory)',
    expiryDate: DateTime(2026, 3, 15),
  ));

  Doctor doctorRonan = Doctor(
    id: 'DR001',
    name: 'Doctor Ronan',
    username: 'ronan',
    password: 'ronan',
  );
  system.registerDoctor(doctorRonan);

  system.loginAsDoctor('ronan', 'ronan');

  var patientPychey = system.currentDoctor!.registerPatient(name: 'Pychey', gender: Gender.male, phoneNumber: '123456789');
  system.addPatient(patientPychey);
  
  var prescription = system.currentDoctor!.writePrescription(patientPychey, patientCondition: 'Hurt');   
  var item = PrescriptionItem(medicineId: 'MED001', dosage: '200mg', frequency: '3 Times Daily', instruction: 'Dont Play Game', quantity: 10 );
  prescription.addItem(item);
  system.addPrescription(prescription);

  ui.showMainMenu();
}