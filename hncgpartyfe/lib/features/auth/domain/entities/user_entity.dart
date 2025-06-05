class UserEntity {
  final String fullname;
  final String username;
  final String email;
  final String gender;
  final DateTime? birthdate;

  UserEntity({
    required this.fullname,
    required this.username,
    required this.email,
    required this.gender,
    this.birthdate,
  });
}
