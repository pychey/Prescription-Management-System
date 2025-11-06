import 'medicine.domain.dart';

class PrescriptionItem {
  // ATTRIBUTES
  final String id;
  final Medicine medicine;
  String dosage;
  String frequency;
  String instruction;
  int quantity;

  // CONSTRUCTOR
  PrescriptionItem({
    required this.id,
    required this.medicine,
    required this.dosage,
    required this.frequency,
    required this.instruction,
    required this.quantity,
  });

  // METHODS
  double calculatePrice() {
    return medicine.price * quantity;
  }
}
