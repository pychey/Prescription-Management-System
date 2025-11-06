import 'Doctor.dart';
import 'Patient.dart';
import 'PrescriptionItem.dart';
import 'Medicine.dart';

class Prescription {
  // ATTRIBUTES
  final String id;
  String notes;
  final Doctor doctor;
  final Patient patient;  
  DateTime issuedDate;
  final List<PrescriptionItem> items = [];

  // CONSTRUCTORS
  Prescription({
    required this.id,
    required this.doctor,
    required this.patient,
    this.notes = '',
  }) : issuedDate = DateTime.now();

  // METHODS
  void addItem(Medicine medicine, String dosage, String frequency, String instruction, int quantity) {
    String itemId = (items.length + 1).toString();
    items.add(PrescriptionItem(
      id: itemId, 
      medicine: medicine, 
      dosage: dosage, 
      frequency: frequency, 
      instruction: instruction, 
      quantity: quantity
    ));
  }

  bool updateItem(String itemId, {Medicine? medicine, String? dosage, String? frequency, String? instruction, int? quantity}) {
    final index = items.indexWhere((item) => item.id == itemId);
    if (index == -1) return false;

    PrescriptionItem item = items[index];
    items[index] = PrescriptionItem(
      id: itemId, 
      medicine: medicine ?? item.medicine, 
      dosage: dosage ?? item.dosage, 
      frequency: frequency ?? item.frequency, 
      instruction: instruction ?? item.instruction, 
      quantity: quantity ?? item.quantity
    );
    return true;
  }

  bool removeItem(String itemId) {
    int before = items.length;
    items.removeWhere((item) => item.id == itemId);
    return items.length < before;
  }

  String getDetails() {
    final buffer = StringBuffer();
    buffer.writeln('Prescription ID: $id');
    buffer.writeln('Doctor: ${doctor.name}');
    buffer.writeln('Patient: ${patient.name}');
    buffer.writeln('Issued Date: ${issuedDate.toLocal()}');
    buffer.writeln('Notes: $notes');
    buffer.writeln('\nItems:');
    for (var item in items) {
      buffer.writeln(
        '- ${item.medicine.name} (${item.dosage}), ${item.frequency}, Qty: ${item.quantity}, Instruction: ${item.instruction}, Price: \$${item.calculatePrice().toStringAsFixed(2)}',
      );
    }
    buffer.writeln('\nTotal Price: \$${getTotalPrice().toStringAsFixed(2)}');
    return buffer.toString();
  }

  double getTotalPrice() {
    double total = 0;
    for (var item in items) {
      total += item.calculatePrice();
    }

    return total;
  }
}