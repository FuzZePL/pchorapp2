import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart'; // Do formatowania daty
import 'package:fluttertoast/fluttertoast.dart'; // Do Toastów
import 'package:pchor_app/screens/login_screen/login_screen.dart';
import 'package:pchor_app/screens/main_screen/duties_screen.dart';
import 'package:pchor_app/screens/main_screen/points_screen.dart';

class MainScreen extends StatefulWidget {
  static const String routeName = '/main-screen';
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String? _currentUsername;
  bool _isLoading =
      true; // Flaga do pokazywania ładowania podczas sprawdzania logowania

  @override
  void initState() {
    super.initState();
    _checkLoginStatus(); // Sprawdź stan logowania przy starcie ekranu
  }

  // --- FUNKCJE TRWAŁEGO ZARZĄDZANIA STANEM ---

  /// Sprawdza, czy użytkownik jest zalogowany, czytając SharedPreferences
  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isLoggedIn = prefs.getBool("IS_LOGGED_IN") ?? false;

    if (isLoggedIn) {
      setState(() {
        _currentUsername = prefs.getString("LOGGED_IN_USERNAME");
        _isLoading = false; // Zakończ ładowanie, pokaż UI
      });
    } else {
      // Jeśli nie jest zalogowany, wymuś powrót do logowania
      _forceLogout();
    }
  }

  /// Wylogowuje użytkownika, czyści SharedPreferences i nawiguje do LoginScreen
  Future<void> _forceLogout() async {
    final prefs = await SharedPreferences.getInstance();
    // Czyścimy SharedPreferences
    await prefs.remove("LOGGED_IN_USERNAME");
    await prefs.setBool("IS_LOGGED_IN", false);

    // Przekierowanie do Logowania i czyszczenie stosu aktywności
    if (mounted) {
      // Sprawdź, czy widget jest nadal w drzewie
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false, // Usuwa wszystkie poprzednie ekrany
      );
    }
  }

  // --- LOGIKA MENU ---

  void _onMenuItemSelected(String item) {
    switch (item) {
      case 'forum':
        Fluttertoast.showToast(msg: "Otwieranie Forum...");
        break;
      case 'duties':
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => const DutiesScreen()));
        break;
      case 'points':
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => const PointsScreen()));
        break;
      case 'history':
        Fluttertoast.showToast(msg: "Otwieranie Historii...");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Jeśli sprawdzamy stan logowania, pokaż kółko ładowania
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Po załadowaniu, pokaż główny interfejs
    return Scaffold(
      appBar: AppBar(
        title: const Text("Menu Główne"),
        // 6 i 7. Ładowanie i Obsługa Menu (Trzy kropki)
        actions: [
          PopupMenuButton<String>(
            onSelected: _onMenuItemSelected, // Użyj funkcji do obsługi kliknięć
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(value: 'forum', child: Text('Forum')),
              const PopupMenuItem<String>(
                value: 'duties',
                child: Text('Służby'),
              ),
              const PopupMenuItem<String>(
                value: 'points',
                child: Text('Punkty'),
              ),
              const PopupMenuItem<String>(
                value: 'history',
                child: Text('Historia'),
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 3. Wyświetlanie Powitania
            Text(
              'Witaj, ${_currentUsername ?? "Użytkowniku"}!',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 24),

            // 4. Wyświetlanie Przykładowych Danych
            Text('Punkty: 150', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),

            // Formatowanie daty
            Text(
              'Data: ${DateFormat("dd.MM.yyyy HH:mm:ss").format(DateTime.now())}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),

            Text(
              'Zbliżające się zadanie: Zadanie A: Zakończenie projektu',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 32),

            // 5. Logika przycisku Wyloguj
            Center(
              child: ElevatedButton(
                onPressed: _forceLogout, // Użyj funkcji wylogowującej
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade700,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Wyloguj'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
