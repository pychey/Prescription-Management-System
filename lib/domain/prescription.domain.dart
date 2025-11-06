import 'package:prescription_management_system/domain/medicine.domain.dart';
import 'package:prescription_management_system/domain/prescription_item.domain.dart';
import 'package:uuid/uuid.dart';

var uuid = Uuid();

class Prescription {
  String id;
  String notes;
  DateTime issuedDate;
  String patientCondition;
  String doctorId;
  String patientId;
  List<PrescriptionItem> items;

  Prescription({
    String? id,
    String? notes,
    required this.patientCondition,
    required this.doctorId,
    required this.patientId,
    List<PrescriptionItem>? items,
  }) : id = id ?? uuid.v4(), notes = notes ?? '', issuedDate = DateTime.now(), items = items ?? [];

  void addItem(PrescriptionItem item) => items.add(item);

  void updateItem(String itemId, PrescriptionItem updatedItem) {
    final index = items.indexWhere((item) => item.id == itemId);
    if (index != -1) items[index] = updatedItem;
  }

  void removeItem(String itemId) =>
      items.removeWhere((item) => item.id == itemId);

  double getTotalPrice(List<Medicine> medicines) {
    double total = 0;
    for (var item in items) {
      try {
        final medicine = medicines.firstWhere((m) => m.id == item.medicineId);
        total += item.getPrice(medicine);
      } catch (e) {
        // SKIP
      }
    }
    return total;
  }
}