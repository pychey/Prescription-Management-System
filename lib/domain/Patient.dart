enum GENDER { male, female, other }

class Patient {
  // ATTRIBUTES
  final String id;
  String name;
  final GENDER gender;
  String phoneNumber;

  // CONSTRUCTOR
  Patient({
    required this.id,
    required this.name,
    required this.gender,
    required this.phoneNumber,
  });
}
