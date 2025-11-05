import 'Condition.dart';

enum GENDER {male, female}

class Patient {
  // ATTRIBUTES  
  String id;
  String name;
  GENDER gender;
  String phoneNumber;
  Condition condition;

  // CONSTRUCTORS
  Patient(this.id, this.name, this.gender, this.phoneNumber, this.condition);

  // METHODS

}