import 'package:prescription_management_system/domain/medicine.domain.dart';

class PrescriptionItem {
  String id;
  String medicineId;
  String dosage;
  String frequency;
  String instruction;
  int quantity;

  PrescriptionItem({
    required this.id,
    required this.medicineId,
    required this.dosage,
    required this.frequency,
    required this.instruction,
    required this.quantity,
  });

  // Computed duration based on frequency
  String getDuration() {
    // Simple logic: extract number from frequency if possible
    final match = RegExp(r'(\d+)').firstMatch(frequency);
    if (match != null) {
      final days = int.tryParse(match.group(1) ?? '0') ?? 0;
      return '$days days';
    }
    return 'As prescribed';
  }

  double calculatePrice(Medicine medicine) => medicine.price * quantity;
}