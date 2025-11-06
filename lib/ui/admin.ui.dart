import 'package:prescription_management_system/domain/doctor.domain.dart';
import 'package:prescription_management_system/domain/medicine.domain.dart';
import 'package:prescription_management_system/domain/prescription.domain.dart';
import 'package:prescription_management_system/domain/prescription_system.domain.dart';
import 'package:prescription_management_system/ui/base.ui.dart';

class AdminUI extends BaseUI {
  AdminUI(PrescriptionSystem system) : super(system);

  void showAdminMenu() {
    while (true) {
      clearScreen();
      showHeader('ADMIN MENU');
      print('1. Manage Doctors');
      print('2. Manage Medicines');
      print('3. Manage Patients');
      print('4. Manage Prescriptions');
      print('0. Back');
      print('═══════════════════════════════════════');

      final choice = readInput('Select option: ');

      switch (choice) {
        case '1':
          manageDoctors();
          break;
        case '2':
          manageMedicines();
          break;
        case '3':
          managePatients();
          break;
        case '4':
          managePrescriptions();
          break;
        case '0':
          return;
      }
    }
  }

  // ============================================================
  // DOCTOR MANAGEMENT
  // ============================================================

  void manageDoctors() {
    while (true) {
      clearScreen();
      showHeader('DOCTOR MANAGEMENT');

      if (system.doctors.isEmpty) {
        print('No doctors registered.\n');
      } else {
        print('REGISTERED DOCTORS:');
        for (var i = 0; i < system.doctors.length; i++) {
          final doctor = system.doctors[i];
          print('${i + 1}. ${doctor.name} (ID: ${doctor.id})');
        }
        print('');
      }

      print('1. View Doctor Details');
      print('2. Register New Doctor');
      print('3. Update Doctor');
      print('4. Remove Doctor');
      print('0. Back');
      print('═══════════════════════════════════════');

      final choice = readInput('Select option: ');

      switch (choice) {
        case '1':
          viewDoctorDetails();
          break;
        case '2':
          registerDoctor();
          break;
        case '3':
          updateDoctor();
          break;
        case '4':
          removeDoctor();
          break;
        case '0':
          return;
      }
    }
  }

  void viewDoctorDetails() {
    if (system.doctors.isEmpty) {
      print('No doctors to view.');
      pause();
      return;
    }

    final id = readInput('\nEnter doctor ID: ');
    final doctor = system.getDoctorById(id);

    if (doctor == null) {
      print('Doctor not found.');
      pause();
      return;
    }

    clearScreen();
    showHeader('DOCTOR DETAILS');
    print('ID: ${doctor.id}');
    print('Name: ${doctor.name}');
    print('Username: ${doctor.username}');
    pause();
  }

  void registerDoctor() {
    clearScreen();
    showHeader('REGISTER NEW DOCTOR');

    final id = 'DR${DateTime.now().millisecondsSinceEpoch}';
    final name = readInput('Enter name: ');
    final username = readInput('Enter username: ');
    final password = readInput('Enter password: ');

    if (name.isEmpty || username.isEmpty || password.isEmpty) {
      print('All fields are required!');
      pause();
      return;
    }

    final doctor = Doctor(
      id: id,
      name: name,
      username: username,
      password: password,
    );

    system.registerDoctor(doctor);
    print('\n✓ Doctor registered successfully! ID: $id');
    pause();
  }

  void updateDoctor() {
    if (system.doctors.isEmpty) {
      print('No doctors to update.');
      pause();
      return;
    }

    final id = readInput('\nEnter doctor ID to update: ');
    final doctor = system.getDoctorById(id);

    if (doctor == null) {
      print('Doctor not found.');
      pause();
      return;
    }

    clearScreen();
    showHeader('UPDATE DOCTOR');
    print('Current: ${doctor.name}\n');

    final name = readInput('Enter new name [${doctor.name}]: ');
    final username = readInput('Enter new username [${doctor.username}]: ');
    final password = readInput('Enter new password (leave empty to keep): ');

    if (name.isNotEmpty) doctor.name = name;
    if (username.isNotEmpty) doctor.username = username;
    if (password.isNotEmpty) doctor.password = password;

    system.updateDoctor(doctor.id, doctor);
    print('\n✓ Doctor updated successfully!');
    pause();
  }

  void removeDoctor() {
    if (system.doctors.isEmpty) {
      print('No doctors to remove.');
      pause();
      return;
    }

    final id = readInput('\nEnter doctor ID to remove: ');
    final doctor = system.getDoctorById(id);

    if (doctor == null) {
      print('Doctor not found.');
      pause();
      return;
    }

    print('Are you sure you want to remove Dr. ${doctor.name}? (yes/no)');
    final confirm = readInput('> ');

    if (confirm.toLowerCase() == 'yes') {
      system.removeDoctor(id);
      print('\n✓ Doctor removed successfully!');
    } else {
      print('Cancelled.');
    }
    pause();
  }

  // ============================================================
  // MEDICINE MANAGEMENT
  // ============================================================

  void manageMedicines() {
    while (true) {
      clearScreen();
      showHeader('MEDICINE MANAGEMENT');

      if (system.medicines.isEmpty) {
        print('No medicines registered.\n');
      } else {
        print('REGISTERED MEDICINES:');
        for (var i = 0; i < system.medicines.length; i++) {
          final medicine = system.medicines[i];
          final status = medicine.isExpired() ? '(EXPIRED)' : '(Stock: ${medicine.stockQuantity})';
          print('${i + 1}. ID: ${medicine.id} - ${medicine.name} $status');
        }
        print('');
      }

      print('1. View Medicine Details');
      print('2. Add New Medicine');
      print('3. Update Medicine');
      print('4. Remove Medicine');
      print('0. Back');
      print('═══════════════════════════════════════');

      final choice = readInput('Select option: ');

      switch (choice) {
        case '1':
          viewMedicineDetails();
          break;
        case '2':
          addMedicine();
          break;
        case '3':
          updateMedicine();
          break;
        case '4':
          removeMedicine();
          break;
        case '0':
          return;
      }
    }
  }

  void viewMedicineDetails() {
    if (system.medicines.isEmpty) {
      print('No medicines to view.');
      pause();
      return;
    }

    final id = readInput('\nEnter medicine ID: ');
    final medicine = system.getMedicineById(id);

    if (medicine == null) {
      print('Medicine not found.');
      pause();
      return;
    }

    clearScreen();
    showHeader('MEDICINE DETAILS');
    print('ID: ${medicine.id}');
    print('Name: ${medicine.name}');
    print('Price: \$${medicine.price}');
    print('Stock: ${medicine.stockQuantity}');
    print('Usage: ${medicine.usage}');
    print('Expiry: ${medicine.expiryDate.toString().substring(0, 10)}');
    print('Status: ${medicine.isExpired() ? "EXPIRED" : "Valid"}');
    pause();
  }

  void addMedicine() {
    clearScreen();
    showHeader('ADD NEW MEDICINE');

    final id = 'MED${DateTime.now().millisecondsSinceEpoch}';
    final name = readInput('Enter name: ');
    final stockStr = readInput('Enter stock quantity: ');
    final priceStr = readInput('Enter price: ');
    final usage = readInput('Enter usage: ');
    final expiryStr = readInput('Enter expiry date (YYYY-MM-DD): ');

    final stock = int.tryParse(stockStr) ?? 0;
    final price = double.tryParse(priceStr) ?? 0.0;

    DateTime expiry;
    try {
      expiry = DateTime.parse(expiryStr);
    } catch (e) {
      expiry = DateTime.now().add(Duration(days: 365));
      print('Invalid date format, using default (1 year from now)');
    }

    final medicine = Medicine(
      id: id,
      name: name,
      stockQuantity: stock,
      price: price,
      usage: usage,
      expiryDate: expiry,
    );

    system.addMedicine(medicine);
    print('\n✓ Medicine added successfully! ID: $id');
    pause();
  }

  void updateMedicine() {
    if (system.medicines.isEmpty) {
      print('No medicines to update.');
      pause();
      return;
    }

    final id = readInput('\nEnter medicine ID to update: ');
    final medicine = system.getMedicineById(id);

    if (medicine == null) {
      print('Medicine not found.');
      pause();
      return;
    }

    clearScreen();
    showHeader('UPDATE MEDICINE');
    print('Current: ${medicine.name}\n');

    final name = readInput('Enter new name [${medicine.name}]: ');
    final stock = readInput('Enter new stock [${medicine.stockQuantity}]: ');
    final price = readInput('Enter new price [${medicine.price}]: ');
    final usage = readInput('Enter new usage [${medicine.usage}]: ');

    if (name.isNotEmpty) medicine.name = name;
    if (stock.isNotEmpty) {
      medicine.stockQuantity = int.tryParse(stock) ?? medicine.stockQuantity;
    }
    if (price.isNotEmpty) {
      medicine.price = double.tryParse(price) ?? medicine.price;
    }
    if (usage.isNotEmpty) medicine.usage = usage;

    system.updateMedicine(id, medicine);
    print('\n✓ Medicine updated successfully!');
    pause();
  }

  void removeMedicine() {
    if (system.medicines.isEmpty) {
      print('No medicines to remove.');
      pause();
      return;
    }

    final id = readInput('\nEnter medicine ID to remove: ');
    final medicine = system.getMedicineById(id);

    if (medicine == null) {
      print('Medicine not found.');
      pause();
      return;
    }

    print('Are you sure you want to remove ${medicine.name}? (yes/no)');
    final confirm = readInput('> ');

    if (confirm.toLowerCase() == 'yes') {
      system.removeMedicine(id);
      print('\n✓ Medicine removed successfully!');
    } else {
      print('Cancelled.');
    }
    pause();
  }

  // ============================================================
  // PATIENT MANAGEMENT
  // ============================================================

  void managePatients() {
    while (true) {
      clearScreen();
      showHeader('PATIENT MANAGEMENT');

      if (system.patients.isEmpty) {
        print('No patients registered.\n');
      } else {
        print('REGISTERED PATIENTS:');
        for (var i = 0; i < system.patients.length; i++) {
          final patient = system.patients[i];
          print('${i + 1}. ${patient.name} (ID: ${patient.id})');
        }
        print('');
      }

      print('1. View Patient Details');
      print('2. Update Patient');
      print('3. Remove Patient');
      print('0. Back');
      print('═══════════════════════════════════════');

      final choice = readInput('Select option: ');

      switch (choice) {
        case '1':
          viewPatientDetails();
          break;
        case '2':
          updatePatient();
          break;
        case '3':
          removePatient();
          break;
        case '0':
          return;
      }
    }
  }

  void viewPatientDetails() {
    if (system.patients.isEmpty) {
      print('No patients to view.');
      pause();
      return;
    }

    final id = readInput('\nEnter patient ID: ');
    final patient = system.getPatientById(id);

    if (patient == null) {
      print('Patient not found.');
      pause();
      return;
    }

    clearScreen();
    showHeader('PATIENT DETAILS');
    print('ID: ${patient.id}');
    print('Name: ${patient.name}');
    print('Gender: ${patient.gender.toString().split('.').last}');
    print('Phone: ${patient.phoneNumber}');
    pause();
  }

  void updatePatient() {
    if (system.patients.isEmpty) {
      print('No patients to update.');
      pause();
      return;
    }

    final id = readInput('\nEnter patient ID to update: ');
    final patient = system.getPatientById(id);

    if (patient == null) {
      print('Patient not found.');
      pause();
      return;
    }

    clearScreen();
    showHeader('UPDATE PATIENT');
    print('Current: ${patient.name}\n');

    final name = readInput('Enter new name [${patient.name}]: ');
    final phone = readInput('Enter new phone [${patient.phoneNumber}]: ');

    if (name.isNotEmpty) patient.name = name;
    if (phone.isNotEmpty) patient.phoneNumber = phone;

    system.updatePatient(id, patient);
    print('\n✓ Patient updated successfully!');
    pause();
  }

  void removePatient() {
    if (system.patients.isEmpty) {
      print('No patients to remove.');
      pause();
      return;
    }

    final id = readInput('\nEnter patient ID to remove: ');
    final patient = system.getPatientById(id);

    if (patient == null) {
      print('Patient not found.');
      pause();
      return;
    }

    print('Are you sure you want to remove ${patient.name}? (yes/no)');
    final confirm = readInput('> ');

    if (confirm.toLowerCase() == 'yes') {
      system.removePatient(id);
      print('\n✓ Patient removed successfully!');
    } else {
      print('Cancelled.');
    }
    pause();
  }

  // ============================================================
  // PRESCRIPTION MANAGEMENT
  // ============================================================

  void managePrescriptions() {
    while (true) {
      clearScreen();
      showHeader('PRESCRIPTION MANAGEMENT');

      if (system.prescriptions.isEmpty) {
        print('No prescriptions found.\n');
      } else {
        print('ALL PRESCRIPTIONS:');
        for (var i = 0; i < system.prescriptions.length; i++) {
          final rx = system.prescriptions[i];
          final patient = system.getPatientById(rx.patientId);
          print('${i + 1}. ${rx.id} - Patient: ${patient?.name ?? "Unknown"}');
        }
        print('');
      }

      print('1. View by Prescription ID');
      print('2. View by Patient ID');
      print('3. View by Doctor ID');
      print('4. Remove Prescription');
      print('0. Back');
      print('═══════════════════════════════════════');

      final choice = readInput('Select option: ');

      switch (choice) {
        case '1':
          viewPrescriptionById();
          break;
        case '2':
          viewPrescriptionsByPatient();
          break;
        case '3':
          viewPrescriptionsByDoctor();
          break;
        case '4':
          removePrescription();
          break;
        case '0':
          return;
      }
    }
  }

  void viewPrescriptionById() {
    if (system.prescriptions.isEmpty) {
      print('No prescriptions to view.');
      pause();
      return;
    }

    final id = readInput('\nEnter prescription ID: ');
    final rx = system.getPrescriptionById(id);

    if (rx == null) {
      print('Prescription not found.');
      pause();
      return;
    }

    displayPrescriptionDetails(rx);
  }

  void viewPrescriptionsByPatient() {
    if (system.patients.isEmpty) {
      print('No patients registered.');
      pause();
      return;
    }

    clearScreen();
    showHeader('SELECT PATIENT');
    for (var i = 0; i < system.patients.length; i++) {
      final patient = system.patients[i];
      print('${i + 1}. ${patient.name} (ID: ${patient.id})');
    }

    final id = readInput('\nEnter patient ID: ');
    final patient = system.getPatientById(id);

    if (patient == null) {
      print('Patient not found.');
      pause();
      return;
    }

    final prescriptions = system.getPrescriptionsByPatientId(id);

    clearScreen();
    showHeader('PRESCRIPTIONS FOR: ${patient.name}');

    if (prescriptions.isEmpty) {
      print('No prescriptions found.');
    } else {
      for (var i = 0; i < prescriptions.length; i++) {
        final rx = prescriptions[i];
        print('${i + 1}. ${rx.id}');
        print('   Date: ${rx.issuedDate.toString().substring(0, 10)}');
        print('   Condition: ${rx.patientCondition}');
        print('   Items: ${rx.items.length}');
        print('');
      }
    }

    pause();
  }

  void viewPrescriptionsByDoctor() {
    if (system.doctors.isEmpty) {
      print('No doctors registered.');
      pause();
      return;
    }

    clearScreen();
    showHeader('SELECT DOCTOR');
    for (var i = 0; i < system.doctors.length; i++) {
      final doctor = system.doctors[i];
      print('${i + 1}. Dr. ${doctor.name} (ID: ${doctor.id})');
    }

    final id = readInput('\nEnter doctor ID: ');
    final doctor = system.getDoctorById(id);

    if (doctor == null) {
      print('Doctor not found.');
      pause();
      return;
    }

    final prescriptions = system.getPrescriptionsByDoctorId(id);

    clearScreen();
    showHeader('PRESCRIPTIONS BY: Dr. ${doctor.name}');

    if (prescriptions.isEmpty) {
      print('No prescriptions found.');
    } else {
      for (var i = 0; i < prescriptions.length; i++) {
        final rx = prescriptions[i];
        final patient = system.getPatientById(rx.patientId);
        print('${i + 1}. ${rx.id}');
        print('   Patient: ${patient?.name ?? "Unknown"}');
        print('   Date: ${rx.issuedDate.toString().substring(0, 10)}');
        print('   Condition: ${rx.patientCondition}');
        print('');
      }
    }

    pause();
  }

  void displayPrescriptionDetails(Prescription rx) {
    final patient = system.getPatientById(rx.patientId);
    final doctor = system.getDoctorById(rx.doctorId);

    clearScreen();
    showHeader('PRESCRIPTION DETAILS');
    print('ID: ${rx.id}');
    print('Patient: ${patient?.name ?? "Unknown"}');
    print('Doctor: Dr. ${doctor?.name ?? "Unknown"}');
    print('Date: ${rx.issuedDate.toString().substring(0, 10)}');
    print('Condition: ${rx.patientCondition}');
    print('Notes: ${rx.notes.isEmpty ? "None" : rx.notes}');
    print('───────────────────────────────────────');
    print('ITEMS:');

    if (rx.items.isEmpty) {
      print('No items.');
    } else {
      for (var i = 0; i < rx.items.length; i++) {
        final item = rx.items[i];
        final medicine = system.getMedicineById(item.medicineId);
        print('\n${i + 1}. ${medicine?.name ?? "Unknown"}');
        print('   Dosage: ${item.dosage}');
        print('   Frequency: ${item.frequency}');
        print('   Duration: ${item.getDuration()}');
        print('   Quantity: ${item.quantity}');
        print('   Instructions: ${item.instruction}');
        if (medicine != null) {
          print('   Price: \${item.calculatePrice(medicine).toStringAsFixed(2)}');
        }
      }

      final total = rx.getTotalPrice(system.medicines);
      print('\n───────────────────────────────────────');
      print('TOTAL PRICE: \$${total.toStringAsFixed(2)}');
    }

    print('═══════════════════════════════════════');
    pause();
  }

  void removePrescription() {
    if (system.prescriptions.isEmpty) {
      print('No prescriptions to remove.');
      pause();
      return;
    }

    final id = readInput('\nEnter prescription ID to remove: ');
    final rx = system.getPrescriptionById(id);

    if (rx == null) {
      print('Prescription not found.');
      pause();
      return;
    }

    print('Are you sure you want to remove prescription ${rx.id}? (yes/no)');
    final confirm = readInput('> ');

    if (confirm.toLowerCase() == 'yes') {
      system.removePrescription(id);
      print('\n✓ Prescription removed successfully!');
    } else {
      print('Cancelled.');
    }
    pause();
  }
}