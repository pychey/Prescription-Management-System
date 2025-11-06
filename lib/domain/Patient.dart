import 'Condition.dart';

enum GENDER { male, female, other }

class Patient {
  // ATTRIBUTES
  final String id;
  String name;
  GENDER gender;
  String phoneNumber;
  Condition? condition;

  // CONSTRUCTOR
  Patient({
    required this.id,
    required this.name,
    required this.gender,
    required this.phoneNumber,
    this.condition,
  });
}
