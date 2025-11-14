import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pchor_app/data/auth_manager.dart'; 
import 'package:pchor_app/screens/main_screen.dart';
import 'package:pchor_app/screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Klucz do zarządzania walidacją formularza
  final _formKey = GlobalKey<FormState>();
  
  // Kontrolery do odczytu danych z pól tekstowych
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Do pokazywania kółka ładowania podczas logowania
  bool _isLoading = false;

  // Wymagana domena 
  final String _requiredDomain = "@student.wat.edu.pl";

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  @override
  void dispose() {
    // Ważne: czyść kontrolery, gdy widget jest usuwany
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // --- FUNKCJE OBSŁUGI STANU SESJI ---

  /// Sprawdza, czy flagi IS_LOGGED_IN są ustawione w SharedPreferences.
  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool("IS_LOGGED_IN") ?? false) {
      _navigateToMainActivity();
    }
  }

  /// Zapisuje stan zalogowania i nazwę użytkownika w SharedPreferences.
  Future<void> _saveLoginState(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("LOGGED_IN_USERNAME", email);
    await prefs.setBool("IS_LOGGED_IN", true);
  }

  /// Przekierowuje do MainActivity i czyści stos.
  void _navigateToMainActivity() {
    if (!mounted) return; // Sprawdzenie, czy widget jest nadal aktywny
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const MainScreen()),
      (Route<dynamic> route) => false, // Usuwa wszystkie ekrany ze stosu
    );
  }

  // --- LOGIKA PRZYCISKÓW ---

  /// Przenosi do ekranu rejestracji
  void _navigateToRegister() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const RegisterScreen()),
    );
  }

  /// Główna funkcja logowania (wywoływana przez przycisk)
  Future<void> _login() async {
    // 1. Walidacja formularza (sprawdza wszystkie validatory)
    if (!_formKey.currentState!.validate()) {
      return; // Przerwij, jeśli walidacja się nie powiodła
    }

    setState(() {
      _isLoading = true; // Pokaż kółko ładowania
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text;

    // Inicjalizacja AuthManager
    final authManager = await AuthManager.create();

    // 3. Weryfikacja i Logowanie
    final bool isSuccess = await authManager.verifyUser(email, password);

    if (isSuccess) {
      // DANE POPRAWNE:
      
      // KROK KRYTYCZNY: ZAPISUJEMY STAN LOGOWANIA
      await _saveLoginState(email);

      Fluttertoast.showToast(msg: "Logowanie pomyślne!");
      _navigateToMainActivity();
    } else {
      // DANE BŁĘDNE
      Fluttertoast.showToast(msg: "Nieprawidłowy e-mail lub hasło.");
    }

    // Ukryj kółko ładowania (nawet jeśli błąd)
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // --- INTERFEJS UŻYTKOWNIKA ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Logowanie"),
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
                  "Zaloguj się",
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Pole E-mail
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: "Adres e-mail",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) { // Walidacja (odpowiednik .error)
                    if (value == null || value.isEmpty) {
                      return "Pole e-mail jest wymagane";
                    }
                    if (!value.endsWith(_requiredDomain)) {
                      return "Wymagany e-mail w domenie $_requiredDomain";
                    }
                    return null; // OK
                  },
                ),
                const SizedBox(height: 16),

                // Pole Hasło
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: "Hasło",
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true, // Ukrywa hasło
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Pole hasła jest wymagane";
                    }
                    return null; // OK
                  },
                ),
                const SizedBox(height: 24),

                // Przycisk Logowania lub Kółko Ładowania
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  ElevatedButton(
                    onPressed: _login, // Wywołaj funkcję logowania
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text("ZALOGUJ"),
                  ),
                const SizedBox(height: 16),

                // Link do Rejestracji
                TextButton(
                  onPressed: _navigateToRegister,
                  child: const Text("Zarejestruj się"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}