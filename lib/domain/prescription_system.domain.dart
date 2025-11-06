import 'package:prescription_management_system/domain/doctor.domain.dart';
import 'package:prescription_management_system/domain/medicine.domain.dart';
import 'package:prescription_management_system/domain/patient.domain.dart';
import 'package:prescription_management_system/domain/prescription.domain.dart';

class PrescriptionSystem {
  final List<Doctor> doctors = [];
  final List<Patient> patients = [];
  final List<Medicine> medicines = [];
  final List<Prescription> prescriptions = [];
  Doctor? currentDoctor;

  // Doctor Management
  void registerDoctor(Doctor doctor) => doctors.add(doctor);

  List<Doctor> getDoctors() => doctors;

  Doctor? getDoctorById(String id) {
    try {
      return doctors.firstWhere((d) => d.id == id);
    } catch (e) {
      return null;
    }
  }

  void updateDoctor(String id, Doctor updatedDoctor) {
    final index = doctors.indexWhere((d) => d.id == id);
    if (index != -1) doctors[index] = updatedDoctor;
  }

  void removeDoctor(String id) => doctors.removeWhere((d) => d.id == id);

  bool login(String username, String password) {
    try {
      currentDoctor = doctors.firstWhere(
        (d) => d.username == username && d.password == password,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  // Patient Management
  void registerPatient(Patient patient) => patients.add(patient);

  List<Patient> getPatients() => patients;

  Patient? getPatientById(String id) {
    try {
      return patients.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  void updatePatient(String id, Patient updatedPatient) {
    final index = patients.indexWhere((p) => p.id == id);
    if (index != -1) patients[index] = updatedPatient;
  }

  void removePatient(String id) => patients.removeWhere((p) => p.id == id);

  // Medicine Management
  void addMedicine(Medicine medicine) => medicines.add(medicine);

  List<Medicine> getMedicines() => medicines;

  List<Medicine> getAvailableMedicines() {
    return medicines.where((m) => !m.isExpired() && m.stockQuantity > 0).toList();
  }

  Medicine? getMedicineById(String id) {
    try {
      return medicines.firstWhere((m) => m.id == id);
    } catch (e) {
      return null;
    }
  }

  void updateMedicine(String id, Medicine updatedMedicine) {
    final index = medicines.indexWhere((m) => m.id == id);
    if (index != -1) medicines[index] = updatedMedicine;
  }

  void removeMedicine(String id) => medicines.removeWhere((m) => m.id == id);

  // Prescription Management
  void addPrescription(Prescription prescription) {
    // Reduce stock for each medicine in the prescription
    for (var item in prescription.items) {
      final medicine = getMedicineById(item.medicineId);
      if (medicine != null) {
        medicine.reduceStock(item.quantity);
      }
    }
    prescriptions.add(prescription);
  }

  List<Prescription> getPrescriptions() => prescriptions;

  Prescription? getPrescriptionById(String id) {
    try {
      return prescriptions.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Prescription> getPrescriptionsByPatientId(String patientId) =>
      prescriptions.where((p) => p.patientId == patientId).toList();

  List<Prescription> getPrescriptionsByDoctorId(String doctorId) =>
      prescriptions.where((p) => p.doctorId == doctorId).toList();

  void updatePrescription(String id, Prescription updatedPrescription) {
    final index = prescriptions.indexWhere((p) => p.id == id);
    if (index != -1) prescriptions[index] = updatedPrescription;
  }

  void removePrescription(String id) =>
      prescriptions.removeWhere((p) => p.id == id);
}