import 'package:prescription_management_system/domain/patient.domain.dart';
import 'package:prescription_management_system/domain/prescription.domain.dart';
import 'package:prescription_management_system/domain/prescription_item.domain.dart';
import 'package:prescription_management_system/domain/prescription_system.domain.dart';
import 'package:prescription_management_system/ui/base.ui.dart';

// NEED PRESCRIPTION VIEW LINE 282
class DoctorConsole extends BaseConsole {
  DoctorConsole(PrescriptionSystem system) : super(system);

  void showDoctorMenu() {
    while (true) {
      clearScreen();
      showHeader('DOCTOR MENU - Dr. ${system.currentDoctor!.name}');
      print('1. Write Prescription');
      print('2. View Your Patients');
      print('3. View Medicines');
      print('0. Logout');
      print('=======================================');

      final choice = readInput('Select Option: ');

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
    print('2. Select Existing Patient');
    print('0. Back');
    print('=======================================');

    final choice = readInput('Select Option: ');

    switch (choice) {
      case '1':
        handleRegisterPatient();
        break;
      case '2':
        handleSelectPatient();
        break;
      case '0':
        return;
    }
  }

  void handleSelectPatient() {
    clearScreen();
    showHeader('SELECT EXISTING PATIENT');

    if (system.patients.isEmpty) {
      print('No Registered Patients.');
      pause();
      return;
    }

    for (var i = 0; i < system.patients.length; i++) {
      final patient = system.patients[i];
      print('${i + 1}. ${patient.name} (ID: ${patient.id})');
    }
    print('0. Back');
    print('=======================================');

    final choice = readInput('Select Patient: ');
    final index = int.tryParse(choice);

    if (index != null && index > 0 && index <= system.patients.length) {
      final patient = system.patients[index - 1];
      createPrescription(patient);
    }
  }

  void handleRegisterPatient() {
    clearScreen();
    showHeader('REGISTER NEW PATIENT');

    final name = readInput('Enter Patient Name: ');
    if (name.isEmpty) return null;

    print('\nSelect Gender:');
    print('1. Male');
    print('2. Female');
    final genderChoice = readInput('Choice: ');

    Gender gender = Gender.male;
    if (genderChoice == '2') {
      gender = Gender.female;
    }

    final phoneNumber = readInput('Enter Phone Number: ');

    var patient = system.currentDoctor!.registerPatient(name: name, gender: gender, phoneNumber: phoneNumber);

    system.addPatient(patient);
    print('\nPatient Registered Successfully! ID: ${patient.id}');
    
    createPrescription(patient);
  }

  void createPrescription(Patient patient) {
    clearScreen();
    showHeader('CREATE PRESCRIPTION');
    print('Patient: ${patient.name}');
    print('=======================================');

    final condition = readInput('Enter Patient Condition: ');
    if (condition.isEmpty) return;

    var prescription = system.currentDoctor!.writePrescription(patient, patientCondition: condition);                                                        

    print('\nPrescription Created. Now Add Medicines...');
    pause();

    managePrescriptionItems(prescription);

    if (prescription.items.isNotEmpty) {
      system.addPrescription(prescription);
      print('\nPrescription Saved successfully!');
    } else {
      print('\nPrescription Cancelled (No Items Added).');
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
        print('No Items Added Yet.');
      } else {
        for (var i = 0; i < prescription.items.length; i++) {
          final item = prescription.items[i];
          final medicine = system.getMedicineById(item.medicineId);
          print('${i + 1}. ${medicine?.name ?? "Unknown"}');
          print('   Dosage: ${item.dosage}');
          print('   Frequency: ${item.frequency}');
          print('   Quantity: - ${item.quantity}');
          print('   Duration: ${item.getDuration()}');
        }
      }

      print('───────────────────────────────────────');
      print('1. Add Medicine');
      print('2. Remove Item');
      print('3. Add Notes');
      print('0. Finish');
      print('=======================================');

      final choice = readInput('Select Option: ');

      switch (choice) {
        case '1':
          addMedicineToPrescription(prescription);
          break;
        case '2':
          removeItemFromPrescription(prescription);
          break;
        case '3':
          prescription.notes = readInput('Enter Notes: ');
          print('Notes Saved!');
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
      print('No Available Medicines (Check Stock and Expiry).');
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
    print('=======================================');

    final choice = readInput('Select Medicine: ');
    final index = int.tryParse(choice);

    if (index != null && index > 0 && index <= availableMedicines.length) {
      final medicine = availableMedicines[index - 1];

      final dosage = readInput('Enter Dosage: ');
      final frequency = readInput('Enter Frequency: ');
      final instruction = readInput('Enter Instruction: ');
      final quantityStr = readInput('Enter Quantity (inStock: ${medicine.stockQuantity}): ');
      final quantity = int.tryParse(quantityStr) ?? 0;

      if (quantity <= 0) {
        print('Invalid Quantity!');
        pause();
        return;
      }

      if (quantity > medicine.stockQuantity) {
        print('Insufficient Stock! Available: ${medicine.stockQuantity}');
        pause();
        return;
      }

      final item = PrescriptionItem(
        medicineId: medicine.id,
        dosage: dosage,
        frequency: frequency,
        instruction: instruction,
        quantity: quantity,
      );

      prescription.addItem(item);
      print('\nMedicine added successfully!');
      pause();
    }
  }

  void removeItemFromPrescription(Prescription prescription) {
    if (prescription.items.isEmpty) {
      print('No Items to Remove.');
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

    final choice = readInput('\nSelect Item to Remove: ');
    final index = int.tryParse(choice);

    if (index != null && index > 0 && index <= prescription.items.length) {
      prescription.items.removeAt(index - 1);
      print('\nItem removed!');
      pause();
    }
  }

  void viewMyPatients() {
    while (true) {
      clearScreen();
      showHeader('YOUR PATIENTS');

      final myPrescriptions = system.getPrescriptionsByDoctorId(system.currentDoctor!.id);
      final patientIds = myPrescriptions.map((p) => p.patientId).toSet();

      if (patientIds.isEmpty) {
        print('You Have No Patients Yet.\n');
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

      print('1. View Prescriptions By Patient ID');
      print('0. Back');
      print('=======================================');

      final choice = readInput('Select Option: ');

      switch (choice) {
        case '1':
          viewPatientPrescriptions();
          break;
        case '0':
          return;
      }
    }
  }

  void viewPatientPrescriptions() {
    clearScreen();
    showHeader('VIEW PATIENT PRESCRIPTIONS');

    final myPrescriptions = system.getPrescriptionsByDoctorId(system.currentDoctor!.id);
    final patientIds = myPrescriptions.map((p) => p.patientId).toSet();

    if (patientIds.isEmpty) {
      print('You Have No Patients Yet.');
      pause();
      return;
    }

    print('YOUR PATIENTS:');
    var index = 1;
    for (var patientId in patientIds) {
      final patient = system.getPatientById(patientId);
      if (patient != null) {
        print('$index. ${patient.name} (ID: ${patient.id})');
        index++;
      }
    }

    final patientId = readInput('\nEnter Patient ID: ');
    final patient = system.getPatientById(patientId);

    if (patient == null) {
      print('Patient Not Found.');
      pause();
      return;
    }

    final doctorPrescriptions = myPrescriptions.where((p) => p.patientId == patientId).toList();

    if (doctorPrescriptions.isEmpty) {
      print('No Prescriptions Found for This Patient.');
      pause();
      return;
    }

    clearScreen();
    showHeader('PRESCRIPTIONS FOR: ${patient.name}');

    for (var i = 0; i < doctorPrescriptions.length; i++) {
      final rx = doctorPrescriptions[i];
      print('${i + 1}. Prescription ID: ${rx.id}');
      print('   Date: ${rx.issuedDate.toString().substring(0, 10)}');
      print('   Condition: ${rx.patientCondition}');
      print('   Items: ${rx.items.length}');
      print('   Notes: ${rx.notes.isEmpty ? "None" : rx.notes}');
      
      if (rx.items.isNotEmpty) {
        print('   Medicines:');
        for (var item in rx.items) {
          final medicine = system.getMedicineById(item.medicineId);
          print('     - ${medicine?.name ?? "Unknown"} (${item.quantity}x)');
        }
      }
      print('');
    }

    pause();
  }

  void viewMedicines() {
    clearScreen();
    showHeader('AVAILABLE MEDICINES');

    final availableMedicines = system.getAvailableMedicines();

    if (availableMedicines.isEmpty) {
      print('No Medicines Available.');
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