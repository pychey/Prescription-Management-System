import 'patient.domain.dart';
import 'Prescription.dart';

class Doctor {
  // ATTRIBUTES  
  final String id;
  String name;
  String email;
  String password;

  // CONSTRUCTOR
  Doctor({
    required this.id,
    required this.name,
    required this.email,
    required this.password
  });

  // METHODS
  Prescription writePrescription(Patient patient, {required String patientCondition, String notes = ''}) {
    return Prescription(
      id: 'RX-${DateTime.now().millisecondsSinceEpoch}',
      doctor: this,
      patient: patient,
      patientCondition: patientCondition,
      notes: notes,
    );
  }

  void updateInfo({String? name, String? email, String? password}) {
    if (name != null) this.name = name;
    if (email != null) this.email = email;
    if (password != null) this.password = password;
  }
}
