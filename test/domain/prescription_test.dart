import 'package:prescription_management_system/domain/prescription.domain.dart';
import 'package:prescription_management_system/domain/prescription_item.domain.dart';
import 'package:prescription_management_system/domain/medicine.domain.dart';
import 'package:test/test.dart';

void runPrescriptionTests() {
  group('Prescription:', () {
    var prescriptionTest = PrescriptionTests();
    prescriptionTest.prescriptionCalculateTotalPriceCorrectly();
    prescriptionTest.prescriptionAddAndRemoveItems();
    prescriptionTest.prescriptionCreatedWithTodaysDate();
  });
}

class PrescriptionTests {
  void prescriptionCalculateTotalPriceCorrectly() {
    test('Prescription Calculate Total Price Correctly', () {
      // INSTANCE
      Prescription prescription = Prescription(
        patientCondition: 'Hurt',
        doctorId: 'DR001',
        patientId: 'PT001',
      );

      Medicine medicine1 = Medicine(
        id: 'MED001',
        name: 'SiemReap 1',
        stockQuantity: 100,
        price: 5.99,
        usage: 'Heal Who Hurt',
        expiryDate: DateTime.now().add(Duration(days: 365)),
      );

      Medicine medicine2 = Medicine(
        id: 'MED002',
        name: 'SiemReap 2',
        stockQuantity: 50,
        price: 8.50,
        usage: 'Heal Who Pain',
        expiryDate: DateTime.now().add(Duration(days: 365)),
      );

      PrescriptionItem item1 = PrescriptionItem(
        medicineId: 'MED001',
        dosage: '500mg',
        frequency: '3 Times Daily',
        instruction: 'After Meals',
        quantity: 10,
      );

      PrescriptionItem item2 = PrescriptionItem(
        medicineId: 'MED002',
        dosage: '400mg',
        frequency: '2 Times Daily',
        instruction: 'With Water',
        quantity: 5,
      );

      // METHOD
      prescription.addItem(item1);
      prescription.addItem(item2);
      var total = prescription.getTotalPrice([medicine1, medicine2]);

      // EXPECT
      // (5.99 × 10) + (8.50 × 5) = 59.90 + 42.50 = 102.40
      expect(total, equals(102.40));
    });
  }

  void prescriptionAddAndRemoveItems() {
    test('Prescription Add And Remove Items', () {
      // INSTANCE
      Prescription prescription = Prescription(
        patientCondition: 'Hurt So Bad',
        doctorId: 'DR001',
        patientId: 'PT001',
      );

      PrescriptionItem item = PrescriptionItem(
        id: 'ITEM001',
        medicineId: 'MED001',
        dosage: '500mg',
        frequency: '3 Times Daily',
        instruction: 'After Meals',
        quantity: 10,
      );

      // METHOD - Add
      prescription.addItem(item);

      // EXPECT - Add
      expect(prescription.items.length, equals(1));
      expect(prescription.items.first.id, equals('ITEM001'));

      // METHOD - Remove
      prescription.removeItem('ITEM001');

      // EXPECT - Remove
      expect(prescription.items.length, equals(0));
    });
  }

  void prescriptionCreatedWithTodaysDate() {
    test('Prescription Created With Todays Date', () {
      // METHOD
      Prescription prescription = Prescription(
        patientCondition: 'No More Hurt',
        doctorId: 'DR001',
        patientId: 'PT001',
      );

      // INSTANCE
      var today = DateTime.now();

      // EXPECT
      expect(prescription.issuedDate.year, equals(today.year));
      expect(prescription.issuedDate.month, equals(today.month));
      expect(prescription.issuedDate.day, equals(today.day));
    });
  }
}