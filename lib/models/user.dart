class AppUser {
  final String id;
  String email;
  String name;
  String surname;

  AppUser(this.id, this.email, this.name, this.surname);

  Map<String, Object?> toJson() => {
    'id': id,
    'email': email,
    'name': name,
    'surname': surname,
  };

  Map<String, Object?> toJsonLimited() => {'name': name, 'surname': surname};

  static AppUser fromMap(Map<String, dynamic> map) {
    return AppUser(map['id'], map['email'], map['name'], map['surname']);
  }

  static AppUser fromMapLimited(Map<String, dynamic> map) {
    return AppUser('', '', map['name'], map['surname']);
  }
}
