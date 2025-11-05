import 'Doctor.dart';
import 'Patient.dart';
import 'PrescriptionItem.dart';

class Prescription {
  // ATTRIBUTES
  String id;
  String notes;
  Doctor doctor;
  Patient patient;
  List<PrescriptionItem> items;
  DateTime issuedDate;

  // CONSTRUCTORS
  Prescription(this.id, this.notes, this.doctor, this.patient, this.items, this.issuedDate);
  
  // METHODS

}