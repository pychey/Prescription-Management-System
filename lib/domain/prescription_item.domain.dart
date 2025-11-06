import 'package:prescription_management_system/domain/medicine.domain.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class PrescriptionItem {
  String id;
  String medicineId;
  String dosage;
  String frequency; 
  String instruction;
  int quantity;

  PrescriptionItem({
    String? id,
    required this.medicineId,
    required this.dosage,
    required this.frequency,
    required this.instruction,
    required this.quantity,
  }) : id = id ?? uuid.v4();

  String getDuration() {
    final match = RegExp(r'(\d+)').firstMatch(frequency);
    if (match != null) {
      final freqPerDay = int.tryParse(match.group(1) ?? '0') ?? 0;
      if (freqPerDay > 0) {
        final days = (quantity / freqPerDay).ceil();
        return '$days day${days > 1 ? 's' : ''}';
      }
    }
    return 'As Prescribed';
  }

  double getPrice(Medicine medicine) => medicine.price * quantity;
}
