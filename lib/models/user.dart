class AppUser {
  final String id;
  String email;
  String name;
  String surname;
  String unit;
  String password;

  AppUser(
    this.id,
    this.email,
    this.name,
    this.surname,
    this.unit,
    this.password,
  );

  Map<String, Object?> toJson() => {
    'id': id,
    'email': email,
    'name': name,
    'surname': surname,
    'unit': unit,
    'password': password,
  };

  Map<String, Object?> toJsonLimited() => {
    'name': name,
    'surname': surname,
    'unit': unit,
  };

  static AppUser fromMap(Map<String, dynamic> map) {
    return AppUser(
      map['id'],
      map['email'],
      map['name'],
      map['surname'],
      map['unit'],
      map['password'],
    );
  }

  static AppUser fromMapLimited(Map<String, dynamic> map) {
    return AppUser(
      '',
      '',
      map['name'],
      map['surname'],
      map['unit'],
      map['password'],
    );
  }
}
