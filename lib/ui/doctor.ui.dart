import 'package:prescription_management_system/domain/patient.domain.dart';
import 'package:prescription_management_system/domain/prescription.domain.dart';
import 'package:prescription_management_system/domain/prescription_item.domain.dart';
import 'package:prescription_management_system/domain/prescription_system.domain.dart';
import 'package:prescription_management_system/ui/base.ui.dart';

class DoctorUI extends BaseUI {
  DoctorUI(PrescriptionSystem system) : super(system);

  void showDoctorMenu() {
    while (true) {
      clearScreen();
      showHeader('DOCTOR MENU - Dr. ${system.currentDoctor!.name}');
      print('1. Write Prescription');
      print('2. View Your Patients');
      print('3. View Medicines');
      print('0. Logout');
      print('═══════════════════════════════════════');

      final choice = readInput('Select option: ');

      switch (choice) {
        case '1':
          handleWritePrescription();
          break;
        case '2':
          viewMyPatients();
          break;
        case '3':
          viewMedicines();
          break;
        case '0':
          system.currentDoctor = null;
          return;
        default:
          print('Invalid option.');
          pause();
      }
    }
  }

  void handleWritePrescription() {
    clearScreen();
    showHeader('WRITE PRESCRIPTION');
    print('1. Register New Patient');
    print('0. Back');
    print('═══════════════════════════════════════');

    final choice = readInput('Select option: ');

    if (choice == '1') {
      final patient = registerNewPatient();
      if (patient != null) {
        createPrescription(patient);
      }
    }
  }

  Patient? registerNewPatient() {
    clearScreen();
    showHeader('REGISTER NEW PATIENT');

    final id = 'PT${DateTime.now().millisecondsSinceEpoch}';
    final name = readInput('Enter name: ');
    if (name.isEmpty) return null;

    print('\nSelect gender:');
    print('1. Male');
    print('2. Female');
    final genderChoice = readInput('Choice: ');

    Gender gender = Gender.male;
    if (genderChoice == '2') {
      gender = Gender.female;
    }

    final phone = readInput('Enter phone number: ');

    final patient = Patient(
      id: id,
      name: name,
      gender: gender,
      phoneNumber: phone,
    );

    system.registerPatient(patient);
    print('\nPatient registered successfully! ID: $id');
    pause();

    return patient;
  }

  void createPrescription(Patient patient) {
    clearScreen();
    showHeader('CREATE PRESCRIPTION');
    print('Patient: ${patient.name}');
    print('═══════════════════════════════════════');

    final condition = readInput('Enter Patient Condition: ');
    if (condition.isEmpty) return;

    final prescription = Prescription(
      id: 'RX${DateTime.now().millisecondsSinceEpoch}',
      notes: '',
      issuedDate: DateTime.now(),
      patientCondition: condition,
      doctorId: system.currentDoctor!.id,
      patientId: patient.id,
    );

    print('\nPrescription created. Now add medicines...');
    pause();

    managePrescriptionItems(prescription);

    // Save prescription after items are added
    if (prescription.items.isNotEmpty) {
      system.addPrescription(prescription);
      print('\n✓ Prescription saved successfully!');
    } else {
      print('\n✗ Prescription cancelled (no items added).');
    }
    pause();
  }

  void managePrescriptionItems(Prescription prescription) {
    while (true) {
      clearScreen();
      showHeader('PRESCRIPTION ITEMS');
      
      final patient = system.getPatientById(prescription.patientId);
      print('Prescription ID: ${prescription.id}');
      print('Patient: ${patient?.name}');
      print('Condition: ${prescription.patientCondition}');
      print('───────────────────────────────────────');

      if (prescription.items.isEmpty) {
        print('No items added yet.');
      } else {
        for (var i = 0; i < prescription.items.length; i++) {
          final item = prescription.items[i];
          final medicine = system.getMedicineById(item.medicineId);
          print('${i + 1}. ${medicine?.name ?? "Unknown"} - ${item.quantity}x');
          print('   Dosage: ${item.dosage}');
          print('   Frequency: ${item.frequency}');
          print('   Duration: ${item.getDuration()}');
        }
      }

      print('───────────────────────────────────────');
      print('1. Add Medicine');
      print('2. Remove Item');
      print('3. Add Notes');
      print('0. Finish');
      print('═══════════════════════════════════════');

      final choice = readInput('Select option: ');

      switch (choice) {
        case '1':
          addMedicineToPrescription(prescription);
          break;
        case '2':
          removeItemFromPrescription(prescription);
          break;
        case '3':
          prescription.notes = readInput('Enter notes: ');
          print('Notes saved!');
          pause();
          break;
        case '0':
          return;
      }
    }
  }

  void addMedicineToPrescription(Prescription prescription) {
    clearScreen();
    showHeader('SELECT MEDICINE');

    final availableMedicines = system.getAvailableMedicines();
    
    if (availableMedicines.isEmpty) {
      print('No available medicines (check stock and expiry).');
      pause();
      return;
    }

    for (var i = 0; i < availableMedicines.length; i++) {
      final medicine = availableMedicines[i];
      print('${i + 1}. ${medicine.name} - \$${medicine.price}');
      print('   Stock: ${medicine.stockQuantity}');
      print('   Usage: ${medicine.usage}');
      print('   Expiry: ${medicine.expiryDate.toString().substring(0, 10)}');
      print('');
    }
    print('0. Back');
    print('═══════════════════════════════════════');

    final choice = readInput('Select medicine: ');
    final index = int.tryParse(choice);

    if (index != null && index > 0 && index <= availableMedicines.length) {
      final medicine = availableMedicines[index - 1];

      final dosage = readInput('Enter dosage (e.g., 500mg): ');
      final frequency = readInput('Enter frequency (e.g., 3 times daily): ');
      final instruction = readInput('Enter instruction (e.g., After meals): ');
      final quantityStr = readInput('Enter quantity (max ${medicine.stockQuantity}): ');
      final quantity = int.tryParse(quantityStr) ?? 0;

      if (quantity <= 0) {
        print('Invalid quantity!');
        pause();
        return;
      }

      if (quantity > medicine.stockQuantity) {
        print('Insufficient stock! Available: ${medicine.stockQuantity}');
        pause();
        return;
      }

      final item = PrescriptionItem(
        id: 'ITEM${DateTime.now().millisecondsSinceEpoch}',
        medicineId: medicine.id,
        dosage: dosage,
        frequency: frequency,
        instruction: instruction,
        quantity: quantity,
      );

      prescription.addItem(item);
      print('\n✓ Medicine added successfully!');
      pause();
    }
  }

  void removeItemFromPrescription(Prescription prescription) {
    if (prescription.items.isEmpty) {
      print('No items to remove.');
      pause();
      return;
    }

    clearScreen();
    showHeader('REMOVE ITEM');
    
    for (var i = 0; i < prescription.items.length; i++) {
      final item = prescription.items[i];
      final medicine = system.getMedicineById(item.medicineId);
      print('${i + 1}. ${medicine?.name ?? "Unknown"}');
    }

    final choice = readInput('\nSelect item to remove: ');
    final index = int.tryParse(choice);

    if (index != null && index > 0 && index <= prescription.items.length) {
      prescription.items.removeAt(index - 1);
      print('\n✓ Item removed!');
      pause();
    }
  }

  void viewMyPatients() {
    clearScreen();
    showHeader('YOUR PATIENTS');

    final myPrescriptions = system.getPrescriptionsByDoctorId(system.currentDoctor!.id);
    final patientIds = myPrescriptions.map((p) => p.patientId).toSet();

    if (patientIds.isEmpty) {
      print('You have no patients yet.');
    } else {
      for (var patientId in patientIds) {
        final patient = system.getPatientById(patientId);
        if (patient != null) {
          print('• ${patient.name}');
          print('  Phone: ${patient.phoneNumber}');
          print('  Gender: ${patient.gender.toString().split('.').last}');
          print('');
        }
      }
    }

    pause();
  }

  void viewMedicines() {
    clearScreen();
    showHeader('AVAILABLE MEDICINES');

    final availableMedicines = system.getAvailableMedicines();

    if (availableMedicines.isEmpty) {
      print('No medicines available.');
    } else {
      for (var medicine in availableMedicines) {
        print('─────────────────────────────');
        print('Name: ${medicine.name}');
        print('Price: \$${medicine.price}');
        print('Stock: ${medicine.stockQuantity}');
        print('Usage: ${medicine.usage}');
        print('Expiry: ${medicine.expiryDate.toString().substring(0, 10)}');
      }
    }

    pause();
  }
}