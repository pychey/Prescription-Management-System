import 'domain/Doctor.dart';
import 'domain/Medicine.dart';
import 'domain/Patient.dart';
import 'domain/Prescription.dart';
import 'domain/PrescriptionItem.dart';
import 'domain/PrescriptionSystem.dart';

Doctor d1 = Doctor(
  id: '1', 
  name: 'Jam', 
  email: 'gmail',
  password: '123',  
);
Doctor d2 = Doctor(
  id: '2', 
  name: 'Jem', 
  email: 'email', 
  password: '123'
);

Patient p1 = Patient(
  id: '1', 
  name: 'Bob', 
  gender: GENDER.male, 
  phoneNumber: '123'
);
Patient p2 = Patient(
  id: '2', 
  name: 'Jeramy', 
  gender: GENDER.female, 
  phoneNumber: '456'
);

Medicine m1 = Medicine(
  "M001",
  "Paracetamol",
  50,
  10.0,
  "Oral",
  DateTime(2026, 5, 30),
);
Medicine m2 = Medicine(
  "M002", 
  "Ibuprofen",    
  50,
  5.0,
  "Oral",
  DateTime(2026, 5, 30), 
);

PrescriptionItem i1 = PrescriptionItem(
  id: '1', 
  medicine: m1, 
  dosage: '500mg', 
  frequency: '', 
  instruction: '', 
  quantity:  2
);
PrescriptionItem i2 = PrescriptionItem(
  id: '2', 
  medicine: m2, 
  dosage: '200mg', 
  frequency: '', 
  instruction: '', 
  quantity:  3
);

void main () {

  PrescriptionSystem system = new PrescriptionSystem([], [m1, m2], [d1, d2], [p1, p2]);

  Prescription p = d1.writePrescription(
    p1,
    patientCondition: 'Flu',
    notes: 'Hello'
  );

  p.addItem(m1, '', '', '', 10);
  p.addItem(m2, '', '', '', 10);

  print(p.getDetails());
}