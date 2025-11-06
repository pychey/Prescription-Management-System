enum Gender { male, female }

class Patient {
  String id;
  String name;
  Gender gender;
  String phoneNumber;

  Patient({
    required this.id,
    required this.name,
    required this.gender,
    required this.phoneNumber,
  });
}
