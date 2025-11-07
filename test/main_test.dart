import 'package:test/test.dart';
import 'domain/doctor_test.dart'; 
import 'domain/medicine_test.dart';
import 'domain/patient_test.dart';
import 'domain/prescription_test.dart';
import 'domain/system_test.dart';

void main() {
  group('Test Case', () {
    runDoctorTests();
    runPatientTests();
    runMedicineTests();
    runPrescriptionTests();
    runSystemTests(); 
  });
}