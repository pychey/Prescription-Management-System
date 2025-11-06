import 'dart:io';
import 'package:prescription_management_system/domain/prescription_system.domain.dart';

class BaseUI {
  final PrescriptionSystem system;

  BaseUI(this.system);

  String readInput(String prompt) {
    stdout.write(prompt);
    return stdin.readLineSync() ?? '';
  }

  void clearScreen() {
    if (Platform.isWindows) {
      print(Process.runSync("cls", [], runInShell: true).stdout);
    } else {
      print(Process.runSync("clear", [], runInShell: true).stdout);
    }
  }

  void showHeader(String title) {
    print('═══════════════════════════════════════');
    print('   $title');
    print('═══════════════════════════════════════');
  }

  void pause() {
    print('\nPress Enter to continue...');
    stdin.readLineSync();
  }
}