import 'package:prescription_management_system/domain/prescription_system.domain.dart';
import 'package:prescription_management_system/domain/doctor.domain.dart';
import 'package:prescription_management_system/domain/patient.domain.dart';
import 'package:prescription_management_system/domain/medicine.domain.dart';
import 'package:prescription_management_system/domain/prescription.domain.dart';
import 'package:prescription_management_system/domain/prescription_item.domain.dart';
import 'package:test/test.dart';

void runSystemTests() {
  group('PrescriptionSystem:', () {
    var systemTest = PrescriptionSystemIntegrationTests();
    systemTest.systemReducesMedicineStockOnSave();
    systemTest.systemFindsPrescriptionsByPatientAndDoctor();
    systemTest.doctorLoginWorksWithCorrectCredentials();
    systemTest.systemReturnOnlyAvailableMedicines();
    systemTest.systemHandleMedicineNotFound();
    systemTest.loginFailsWithWrongPassword();
  });
}

class PrescriptionSystemIntegrationTests {
  void systemReducesMedicineStockOnSave() {
    test('System Reduces Medicine Stock On Save', () {
      // INSTANCE
      PrescriptionSystem system = PrescriptionSystem();
      
      Doctor doctor = Doctor(id: 'DR001', name: 'Doctor Ronan', username: 'ronanthebest', password: 'ronanthebest');
      system.registerDoctor(doctor);

      Patient patient = Patient(id: 'PT001', name: 'Patient Pychey', gender: Gender.male, phoneNumber: '123456789');
      system.addPatient(patient);

      Medicine medicine = Medicine(
        id: 'MED001',
        name: 'SiemReap',
        stockQuantity: 100,
        price: 5.99,
        usage: 'Heal',
        expiryDate: DateTime.now().add(Duration(days: 365)),
      );
      system.addMedicine(medicine);

      Prescription prescription = Prescription(doctorId: 'DR001', patientId: 'PT001', patientCondition: 'Fever');

      PrescriptionItem item = PrescriptionItem(
        medicineId: 'MED001',
        dosage: '500mg',
        frequency: '3 Times Daily',
        instruction: 'No More Hurt',
        quantity: 10,
      );
      prescription.addItem(item);

      // METHOD
      system.addPrescription(prescription);

      // EXPECT
      expect(medicine.stockQuantity, equals(90));
    });
  }

  void systemFindsPrescriptionsByPatientAndDoctor() {
    test('System Finds Prescriptions By Patient And Doctor', () {
      // INSTANCE
      PrescriptionSystem system = PrescriptionSystem();
      
      Doctor doctor1 = Doctor(id: 'DR001', name: 'Doctor Ronan 1', username: 'theoneronan', password: 'ronanone');
      Doctor doctor2 = Doctor(id: 'DR002', name: 'Doctor Ronan 2', username: 'thetworonan', password: 'ronantwo');
      system.registerDoctor(doctor1);
      system.registerDoctor(doctor2);

      Patient patient = Patient(id: 'PT001', name: 'Patient Pychey', gender: Gender.male, phoneNumber: '123456789');
      system.addPatient(patient);

      Prescription prs1 = Prescription(id: 'RX001', doctorId: 'DR001', patientId: 'PT001', patientCondition: 'Fever');
      Prescription prs2 = Prescription(id: 'RX002', doctorId: 'DR002', patientId: 'PT001', patientCondition: 'Cough');
      Prescription prs3 = Prescription(id: 'RX003', doctorId: 'DR001', patientId: 'PT001', patientCondition: 'Headache');

      // METHOD
      system.addPrescription(prs1);
      system.addPrescription(prs2);
      system.addPrescription(prs3);

      var patientPrescriptions = system.getPrescriptionsByPatientId('PT001');
      var doctor1Prescriptions = system.getPrescriptionsByDoctorId('DR001');

      // EXPECT
      expect(patientPrescriptions.length, equals(3));
      expect(doctor1Prescriptions.length, equals(2));
      expect(doctor1Prescriptions.every((p) => p.doctorId == 'DR001'), isTrue);
    });
  }

  void doctorLoginWorksWithCorrectCredentials() {
    test('Doctor Login Works With Correct Credentials', () {
      // INSTANCE
      PrescriptionSystem system = PrescriptionSystem();
      
      Doctor doctor = Doctor(name: 'Doctor Ronan', username: 'ronan', password: 'theronan');
      system.registerDoctor(doctor);

      // METHOD
      var loginSuccess = system.loginAsDoctor('ronan', 'theronan');
      var loginFail = system.loginAsDoctor('ronan', 'notronan');

      // EXPECT
      expect(loginSuccess, isTrue);
      expect(system.currentDoctor, isNotNull);
      expect(system.currentDoctor!.username, equals('ronan'));
      expect(loginFail, isFalse);
    });
  }
  
  void systemReturnOnlyAvailableMedicines() {
    test('System Return Only Available Medicines', () {
      // INSTANCE
      PrescriptionSystem system = PrescriptionSystem();

      Medicine availableMedicine = Medicine(
        name: 'SiemReap Available',
        stockQuantity: 100,
        price: 5.99,
        usage: 'Usage',
        expiryDate: DateTime.now().add(Duration(days: 365)),
      );

      Medicine expiredMedicine = Medicine(
        name: 'SiemReap Expired',
        stockQuantity: 50,
        price: 10.00,
        usage: 'Usage',
        expiryDate: DateTime.now().subtract(Duration(days: 1)),
      );

      Medicine outOfStockMedicine = Medicine(
        name: 'SiemReap Out Of Stock',
        stockQuantity: 0,
        price: 7.50,
        usage: 'Usage',
        expiryDate: DateTime.now().add(Duration(days: 365)),
      );

      system.addMedicine(availableMedicine);
      system.addMedicine(expiredMedicine);
      system.addMedicine(outOfStockMedicine);

      // METHOD
      var available = system.getAvailableMedicines();

      // EXPECT
      expect(available.length, equals(1));
      expect(available.first.name, equals('SiemReap Available'));
    });
  }

  void systemHandleMedicineNotFound() {
    test('System Handle Medicine Not Found', () {
      // INSTANCE
      PrescriptionSystem system = PrescriptionSystem();

      // METHOD
      var medicine = system.getMedicineById('NONEXISTENT');

      // EXPECT
      expect(medicine, isNull);
    });
  }

  void loginFailsWithWrongPassword() {
    test('Login Fails With Wrong Password', () {
      // INSTANCE
      PrescriptionSystem system = PrescriptionSystem();
      
      Doctor doctor = Doctor(name: 'Doctor Ronan', username: 'ronan', password: 'correctpass');
      system.registerDoctor(doctor);

      // METHOD
      var loginResult = system.loginAsDoctor('ronan', 'wrongpass');

      // EXPECT
      expect(loginResult, isFalse);
      expect(system.currentDoctor, isNull);
    });
  }
}