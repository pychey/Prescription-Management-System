import 'package:prescription_management_system/domain/prescription_system.domain.dart';
import 'package:prescription_management_system/ui/admin.ui.dart';
import 'package:prescription_management_system/ui/base.ui.dart';
import 'package:prescription_management_system/ui/doctor.ui.dart';

class SystemConsole extends BaseConsole {
  late DoctorConsole doctorConsole;
  late AdminConsole adminConsole;

  SystemConsole(PrescriptionSystem system) : super(system) {
    doctorConsole = DoctorConsole(system);
    adminConsole = AdminConsole(system);
  }

  void showMainMenu() {
    while (true) {
      clearScreen();
      showHeader('PRESCRIPTION MANAGEMENT SYSTEM');
      print('1. Login as Doctor');
      print('2. Admin Access');
      print('0. Exit');
      print('=======================================');

      final choice = readInput('Select Option: ');

      switch (choice) {
        case '1':
          handleLogin();
          break;
        case '2':
          adminConsole.showAdminMenu();
          break;
        case '0':
          print('\nGoodbye!');
          return;
        default:
          print('Invalid option.');
          pause();
      }
    }
  }

  void handleLogin() {
    clearScreen();
    showHeader('DOCTOR LOGIN');

    if (system.doctors.isEmpty) {
      print('No Doctors Registered Yet!');
      pause();
      return;
    }

    final username = readInput('\nEnter Username: ');
    final password = readInput('Enter Password: ');

    if (system.loginAsDoctor(username, password)) {
      print('\nLogin Successful! Welcome, Dr. ${system.currentDoctor!.name}');
      pause();
      doctorConsole.showDoctorMenu();
    } else {
      print('\nInvalid Credentials.');
      pause();
    }
  }
}