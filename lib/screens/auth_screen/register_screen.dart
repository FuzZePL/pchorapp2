import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pchor_app/data/auth_manager.dart';
import 'package:pchor_app/screens/main_screen/main_screen.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = '/register-screen';
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Klucz do zarządzania walidacją formularza
  final _formKey = GlobalKey<FormState>();

  // Kontrolery do odczytu danych z pól tekstowych
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();

  // Do pokazywania kółka ładowania podczas rejestracji
  bool _isLoading = false;

  // Wymagana domena
  final String _requiredDomain = "@student.wat.edu.pl";

  // Minimalna długość hasła x znaków
  final int _minPasswordLength = 8;

  @override
  void dispose() {
    // Czyścimy kontrolery, gdy widget jest usuwany
    _emailController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    _nameController.dispose();
    _surnameController.dispose();
    super.dispose();
  }

  // --- LOGIKA OBSŁUGI STANU SESJI ---

  /// Zapisuje stan zalogowania i nazwę użytkownika w SharedPreferences (Automatyczne logowanie).
  Future<void> _saveLoginState(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("LOGGED_IN_USERNAME", email);
    await prefs.setBool("IS_LOGGED_IN", true);
  }

  /// Przekierowuje do MainActivity i czyści stos.
  void _navigateToMainActivity() {
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const MainScreen()),
      (Route<dynamic> route) => false, // Usuwa wszystkie ekrany ze stosu
    );
  }

  // --- LOGIKA PRZYCISKU REJESTRACJI ---

  Future<void> _register() async {
    // Walidacja wszystkich pól za pomocą GlobalKey
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true; // Pokaż kółko ładowania
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final name = _nameController.text.trim();
    final surname = _surnameController.text.trim();

    // Inicjalizacja AuthManager
    final authManager = await AuthManager.create();

    // Zapisywanie nowego użytkownika
    final bool registrationSuccessful = await authManager.registerUser(
      email,
      password,
      name,
      surname,
    );

    if (registrationSuccessful) {
      // TRWAŁY ZAPIS STANU ZALOGOWANIA (Automatyczne logowanie)
      await _saveLoginState(email);

      Fluttertoast.showToast(msg: "Rejestracja pomyślna!");

      // PRZECHODZIMY BEZPOŚREDNIO DO MainActivity
      _navigateToMainActivity();
    } else {
      Fluttertoast.showToast(
        msg: "Rejestracja nieudana. Użytkownik już istnieje lub błąd.",
      );
    }

    if (mounted) {
      setState(() {
        _isLoading = false; // Ukryj kółko ładowania
      });
    }
  }

  // --- INTERFEJS UŻYTKOWNIKA ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Konfiguracja AppBar (Odpowiednik Toolbar z przyciskiem Wstecz)
      appBar: AppBar(
        title: const Text("Rejestracja"),
        // Flutter automatycznie dodaje przycisk Wstecz (strzałkę)
        // jeśli jest co najmniej jeden ekran pod tym w stosie nawigacji.
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey, // Podłączenie klucza do formularza
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Tytuł
                Text(
                  "Utwórz nowe konto",
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Pole Imię
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Imię",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Imię jest wymagane";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Pole Nazwisko
                TextFormField(
                  controller: _surnameController,
                  decoration: const InputDecoration(
                    labelText: "Nazwisko",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Nazwisko jest wymagane";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Pole E-mail
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: "Adres e-mail",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "E-mail jest wymagany";
                    }
                    if (!value.endsWith(_requiredDomain)) {
                      return "Wymagany e-mail w domenie $_requiredDomain";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Pole Hasło
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: "Hasło (min. $_minPasswordLength znaków)",
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Hasło jest wymagane";
                    }
                    if (value.length < _minPasswordLength) {
                      return "Hasło musi mieć co najmniej $_minPasswordLength znaków";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Pole Powtórzenie Hasła
                TextFormField(
                  controller: _repeatPasswordController,
                  decoration: const InputDecoration(
                    labelText: "Powtórz Hasło",
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Powtórzenie hasła jest wymagane";
                    }
                    if (_passwordController.text != value) {
                      return "Hasła nie są identyczne";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // Przycisk Rejestracji lub Kółko Ładowania
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  ElevatedButton(
                    onPressed: _register,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text("ZAREJESTRUJ"),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
