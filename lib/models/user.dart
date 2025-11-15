class AppUser {
  final String id;
  String email;
  String username;

  AppUser(this.id, this.email, this.username);

  Map<String, Object?> toJson() => {
    'id': id,
    'email': email,
    'username': username,
  };

  Map<String, Object?> toJsonLimited() => {'username': username};

  static AppUser fromMap(Map<String, dynamic> map) {
    return AppUser(map['id'], map['email'], map['username']);
  }

  static AppUser fromMapLimited(Map<String, dynamic> map) {
    return AppUser('', '', map['username']);
  }
}
