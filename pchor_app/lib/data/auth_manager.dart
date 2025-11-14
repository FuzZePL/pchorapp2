import 'package:shared_preferences/shared_preferences.dart';

class AuthManager {
  // Klucze używane do przechowywania danych użytkownika w SharedPreferences
  static const String _keyPassword = "_password";
  static const String _keyName = "_name";
  static const String _keySurname = "_surname";
  
  // Instancja SharedPreferences
  final SharedPreferences _prefs;

  // Prywatny konstruktor
  AuthManager._(this._prefs);

  // Fabryka asynchroniczna do inicjalizacji
  static Future<AuthManager> create() async {
    final prefs = await SharedPreferences.getInstance();
    return AuthManager._(prefs);
  }

  /// Funkcja rejestruje nowego użytkownika.
  // ignore: unintended_html_in_doc_comment
  /// @return Future<bool>: true, jeśli rejestracja (zapis) powiodła się, false w przeciwnym razie.
  Future<bool> registerUser(String email, String password, String name, String surname) async {
    // 1. Sprawdzamy, czy użytkownik już istnieje
    if (_prefs.containsKey(email + _keyPassword)) {
      return false; // Użytkownik o tym emailu już istnieje
    }

    // 2. Jeśli nie istnieje, zapisujemy dane
    await _prefs.setString(email + _keyPassword, password);
    await _prefs.setString(email + _keyName, name);
    await _prefs.setString(email + _keySurname, surname);

    return true; // Rejestracja pomyślna
  }

  /// Funkcja weryfikuje użytkownika podczas logowania.
  // ignore: unintended_html_in_doc_comment
  /// @return Future<bool>: true, jeśli dane są poprawne, false w przeciwnym razie.
  Future<bool> verifyUser(String email, String password) async {
    final storedPassword = _prefs.getString(email + _keyPassword);

    // Sprawdzamy, czy hasło istnieje i jest identyczne
    if (storedPassword != null && storedPassword == password) {
      return true;
    }
    return false;
  }
}