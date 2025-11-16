import 'package:flutter/material.dart';
import 'package:pchor_app/values/constant_functions.dart';
import 'package:pchor_app/values/size_config.dart';
import 'package:pchor_app/values/strings.dart';
import 'package:pchor_app/widgets/buttons/default_button.dart';
import 'package:pchor_app/widgets/text_fields/rounded_input_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pchor_app/data/auth_manager.dart';
import 'package:pchor_app/screens/main_screen/main_screen.dart';
import 'package:pchor_app/screens/auth_screen/register_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login-screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final double _defaultSize = SizeConfig.defaultSize!;
  final _formKey = GlobalKey<FormState>();
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
    Navigator.of(context).pushReplacementNamed(MainScreen.routeName);
  }

  // --- LOGIKA PRZYCISKÓW ---

  /// Przenosi do ekranu rejestracji
  void _navigateToRegister() {
    Navigator.of(context).pushNamed(RegisterScreen.routeName);
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
      body: Container(
        decoration: BoxDecoration(
          gradient: ConstantFunctions.defaultGradient(),
        ),
        child: SafeArea(
          child: Align(
            alignment: AlignmentGeometry.bottomCenter,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
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
                    RoundedInputField(
                      controller: _emailController,
                      hintText: Strings.email,
                      icon: Icons.email_outlined,
                      onChanged: (val) {},
                      type: 'Email',
                      onSaved: (val) {},
                      textInputAction: TextInputAction.next,
                      inputType: TextInputType.emailAddress,
                      isPassword: false,
                    ),
                    RoundedInputField(
                      controller: _passwordController,
                      hintText: Strings.password,
                      icon: Icons.password_outlined,
                      onChanged: (val) {},
                      type: 'pass',
                      onSaved: (val) {},
                      textInputAction: TextInputAction.done,
                      inputType: TextInputType.text,
                      isPassword: true,
                    ),
                    const SizedBox(height: 24),
                    DefaultButton(
                      defaultSize: _defaultSize,
                      onTap: () {},
                      text: Strings.login,
                      icon: Icons.login_rounded,
                      gradient: ConstantFunctions.secondaryGradient(),
                    ),
                    const SizedBox(height: 16),
                    // Link do Rejestracji
                    TextButton(
                      onPressed: _navigateToRegister,
                      child: const Text("Zarejestruj się"),
                    ),
                    const SizedBox(height: 6),
                    SizedBox(height: _defaultSize * 8),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
