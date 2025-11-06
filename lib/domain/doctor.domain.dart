import 'package:prescription_management_system/domain/prescription.domain.dart';
import 'package:prescription_management_system/domain/patient.domain.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class Doctor {
  String id;
  String name;
  String username;
  String password;

  Doctor({
    String? id,
    required this.name,
    required this.username,
    required this.password,
  }): id = id ?? uuid.v4();

  Prescription writePrescription(Patient patient, {required String patientCondition, String notes = ''}) {
    return Prescription(
      patientCondition: patientCondition,
      notes: notes,
      doctorId: this.id,
      patientId: patient.id
    );
  }

  Patient registerPatient({ required String name, required Gender gender, required String phoneNumber }) {
    return Patient(
      name: name, 
      gender: gender, 
      phoneNumber: phoneNumber
    );
  }

  void updateInfo({String? name, String? username, String? password}) {
    if (name != null) this.name = name;
    if (username != null) this.username = username;
    if (password != null) this.password = password;
  }
}