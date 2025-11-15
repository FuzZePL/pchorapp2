import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Do filtrowania cyfr
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Do obsługi JSON

//#################################################################
//                        EKRAN PUNKTÓW 
//#################################################################

class PointsScreen extends StatefulWidget {
  const PointsScreen({super.key});

  @override
  State<PointsScreen> createState() => _PointsScreenState();
}

class _PointsScreenState extends State<PointsScreen> {
  // Lista przechowująca aktualne obiekty PersonPoint w pamięci
  List<PersonPoint> _pointList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Wczytuje dane z SharedPreferences
  Future<void> _loadData() async {
    final points = await PointManager.loadPoints();
    setState(() {
      _pointList = points;
      _isLoading = false;
    });
  }

  // Zapisuje dane do SharedPreferences
  Future<void> _saveData() async {
    await PointManager.savePoints(_pointList);
  }

  // --- Logika Dialogu i Listy ---

  void _showContextMenu(PersonPoint person) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Opcje dla ${person.name} ${person.surname}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edytuj'),
                onTap: () {
                  Navigator.of(context).pop(); // Zamknij menu kontekstowe
                  _showAddPersonDialog(personToEdit: person); // Otwórz dialog edycji
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Usuń'),
                onTap: () {
                  Navigator.of(context).pop(); // Zamknij menu kontekstowe
                  _showDeleteConfirmation(person); // Otwórz potwierdzenie usunięcia
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Potwierdzenie usunięcia
  void _showDeleteConfirmation(PersonPoint person) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Potwierdź usunięcie'),
          content: Text('Czy na pewno chcesz usunąć ${person.name} ${person.surname} z tabeli?'),
          actions: [
            TextButton(
              child: const Text('Anuluj'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Usuń'),
              onPressed: () {
                _deletePerson(person);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deletePerson(PersonPoint person) {
    setState(() {
      _pointList.removeWhere((p) => p.id == person.id);
      _saveData(); // Zapisz zmiany
      Fluttertoast.showToast(msg: "Użytkownik usunięty.");
    });
  }

  Future<void> _showAddPersonDialog({PersonPoint? personToEdit}) async {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: personToEdit?.name);
    final surnameController = TextEditingController(text: personToEdit?.surname);
    final pointsController = TextEditingController(text: personToEdit?.points.toString());

    final result = await showDialog<PersonPoint?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(personToEdit == null ? 'Dodaj nową osobę' : 'Edytuj ${personToEdit.name}'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(nameController, "Imię"),
                const SizedBox(height: 10),
                _buildTextField(surnameController, "Nazwisko"),
                const SizedBox(height: 10),
                // Pole na Punkty (tylko cyfry)
                TextFormField(
                  controller: pointsController,
                  decoration: const InputDecoration(
                    labelText: "Punkty",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Tylko cyfry
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Pole jest wymagane';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Wprowadź poprawną liczbę';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Anuluj'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(personToEdit == null ? 'Dodaj' : 'Zapisz'),
              onPressed: () {
                if (formKey.currentState?.validate() ?? false) {
                  final newPerson = PersonPoint(
                    name: nameController.text.trim(),
                    surname: surnameController.text.trim(),
                    points: int.parse(pointsController.text.trim()), // Mamy pewność, że to liczba
                    id: personToEdit?.id ?? DateTime.now().millisecondsSinceEpoch,
                  );
                  Navigator.of(context).pop(newPerson);
                }
              },
            ),
          ],
        );
      },
    );

    // Po zamknięciu dialogu
    if (result != null) {
      setState(() {
        if (personToEdit == null) {
          // TRYB DODAWANIA
          _pointList.add(result);
          Fluttertoast.showToast(msg: "Dodano nową osobę.");
        } else {
          // TRYB EDYCJI
          final index = _pointList.indexWhere((p) => p.id == result.id);
          if (index != -1) {
            _pointList[index] = result;
            Fluttertoast.showToast(msg: "Dane zapisane pomyślnie.");
          }
        }
        _saveData(); // Zapisz zmiany
      });
    }
  }

  // Pomocnik do budowania pól tekstowych (Imię, Nazwisko)
  TextFormField _buildTextField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Pole jest wymagane';
        }
        return null;
      },
    );
  }

  // --- INTERFEJS UŻYTKOWNIKA ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Punkty'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _pointList.length,
              itemBuilder: (context, index) {
                final person = _pointList[index];
                // Budujemy element listy (Karta)
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    // Logika kliknięcia (Edycja/Usuwanie)
                    onTap: () => _showContextMenu(person),
                    title: Text(
                      '${person.name} ${person.surname}', // Imię i Nazwisko
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    // Punkty jako ikona i tekst po prawej
                    trailing: Chip(
                      label: Text(
                        '${person.points} pkt',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      backgroundColor: Colors.blue.shade100,
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddPersonDialog(),
        tooltip: 'Dodaj osobę',
        child: const Icon(Icons.add),
      ),
    );
  }
}

//#################################################################
// DEFINICJE MODELU I MANAGERA (TRWAŁOŚĆ DANYCH)
// UMIESZCZONE W TYM SAMYM PLIKU
//#################################################################

// Odpowiednik modelu danych
class PersonPoint {
  final String name;
  final String surname;
  final int points;
  final int id;

  PersonPoint({
    required this.name,
    required this.surname,
    required this.points,
    required this.id,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'surname': surname,
      'points': points,
      'id': id,
    };
  }

  factory PersonPoint.fromJson(Map<String, dynamic> json) {
    return PersonPoint(
      name: json['name'] as String,
      surname: json['surname'] as String,
      points: json['points'] as int,
      id: json['id'] as int,
    );
  }
}

// Klasa pomocnicza do zarządzania listą (Zapis/Odczyt z SharedPreferences)
class PointManager {
  static const String _prefsKey = "POINTS_LIST";

  // Zapisuje listę osób do SharedPreferences jako JSON
  static Future<void> savePoints(List<PersonPoint> persons) async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> personMaps = persons.map((p) => p.toJson()).toList();
    String jsonString = jsonEncode(personMaps);
    await prefs.setString(_prefsKey, jsonString);
  }

  // Odczytuje listę osób z SharedPreferences
  static Future<List<PersonPoint>> loadPoints() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_prefsKey);

    if (jsonString != null) {
      List<dynamic> personMaps = jsonDecode(jsonString);
      return personMaps.map((map) => PersonPoint.fromJson(map)).toList();
    } else {
      // Zwróć dane testowe, jeśli nic nie ma (jak w Twoim kodzie)
      return [
        PersonPoint(name: "Adam", surname: "Nowak", points: 250, id: 1),
        PersonPoint(name: "Anna", surname: "Kowalska", points: 300, id: 2),
      ];
    }
  }
}