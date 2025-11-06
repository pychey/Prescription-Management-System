import 'package:uuid/uuid.dart';

var uuid = Uuid();

enum Gender { male, female }

class Patient {
  String id;
  String name;
  Gender gender;
  String phoneNumber;

  Patient({
    String? id,
    required this.name,
    required this.gender,
    required this.phoneNumber,
  }): id = id ?? uuid.v4();
}
