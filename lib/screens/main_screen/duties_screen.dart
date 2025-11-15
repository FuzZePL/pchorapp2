import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // Do obsługi JSON

//#################################################################
//                        EKRAN SŁUŻB 
//#################################################################

class DutiesScreen extends StatefulWidget {
  const DutiesScreen({super.key});

  @override
  State<DutiesScreen> createState() => _DutiesScreenState();
}

class _DutiesScreenState extends State<DutiesScreen> {
  // Lista przechowująca aktualne obiekty Duty w pamięci
  List<Duty> _dutyList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    // Używamy managera zdefiniowanego na dole tego pliku
    final duties = await DutyManager.loadDuties();
    setState(() {
      _dutyList = duties;
      _isLoading = false;
    });
  }

  Future<void> _saveData() async {
    await DutyManager.saveDuties(_dutyList);
  }

  // --- Logika Dialogu i Tabeli ---

  void _showContextMenu(Duty duty) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Opcje dla ${duty.imie} ${duty.nazwisko}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edytuj'),
                onTap: () {
                  Navigator.of(context).pop(); // Zamknij menu kontekstowe
                  _showAddDutyDialog(dutyToEdit: duty); // Otwórz dialog edycji
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Usuń'),
                onTap: () {
                  Navigator.of(context).pop(); // Zamknij menu kontekstowe
                  _showDeleteConfirmation(duty); // Otwórz potwierdzenie usunięcia
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Potwierdzenie usunięcia (z showContextMenu)
  void _showDeleteConfirmation(Duty duty) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Potwierdź usunięcie'),
          content: Text('Czy na pewno chcesz usunąć ten wpis? (${duty.imie} ${duty.nazwisko})'),
          actions: [
            TextButton(
              child: const Text('Anuluj'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Usuń'),
              onPressed: () {
                _deleteDuty(duty);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteDuty(Duty duty) {
    setState(() {
      _dutyList.removeWhere((d) => d.id == duty.id);
      _saveData(); // Zapisz zmiany
      Fluttertoast.showToast(msg: "Wpis usunięty.");
    });
  }

  Future<void> _showAddDutyDialog({Duty? dutyToEdit}) async {
    // Klucz do formularza w dialogu
    final formKey = GlobalKey<FormState>();

    // Kontrolery dla 7 pól
    final dController = TextEditingController(text: dutyToEdit?.d);
    final mController = TextEditingController(text: dutyToEdit?.m);
    final rController = TextEditingController(text: dutyToEdit?.r);
    final stopienController = TextEditingController(text: dutyToEdit?.stopien);
    final imieController = TextEditingController(text: dutyToEdit?.imie);
    final nazwiskoController = TextEditingController(text: dutyToEdit?.nazwisko);
    final rolaController = TextEditingController(text: dutyToEdit?.rola);

    final result = await showDialog<Duty?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(dutyToEdit == null ? 'Dodaj nową służbę' : 'Edytuj wpis'),
          content: SingleChildScrollView( // Używamy ScrollView (jak w XML)
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Pola Daty (D, M, R)
                  Row(
                    children: [
                      Expanded(child: _buildTextField(dController, "D (dzień)", 2)),
                      const SizedBox(width: 8),
                      Expanded(child: _buildTextField(mController, "M (miesiąc)", 2)),
                      const SizedBox(width: 8),
                      Expanded(child: _buildTextField(rController, "R (rok)", 2)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(stopienController, "Stopień"),
                  const SizedBox(height: 10),
                  _buildTextField(imieController, "Imię"),
                  const SizedBox(height: 10),
                  _buildTextField(nazwiskoController, "Nazwisko"),
                  const SizedBox(height: 10),
                  _buildTextField(rolaController, "Rola"),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Anuluj'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(dutyToEdit == null ? 'Dodaj' : 'Zapisz'),
              onPressed: () {
                // Walidacja
                if (formKey.currentState?.validate() ?? false) {
                  final newDuty = Duty(
                    d: dController.text,
                    m: mController.text,
                    r: rController.text,
                    stopien: stopienController.text,
                    imie: imieController.text,
                    nazwisko: nazwiskoController.text,
                    rola: rolaController.text,
                    // Użyj starego ID przy edycji lub nowego ID (czasu) przy dodawaniu
                    id: dutyToEdit?.id ?? DateTime.now().millisecondsSinceEpoch,
                  );
                  // Zwróć nowy obiekt Duty
                  Navigator.of(context).pop(newDuty); 
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
        if (dutyToEdit == null) {
          // TRYB DODAWANIA
          _dutyList.add(result);
          Fluttertoast.showToast(msg: "Dodano nową służbę.");
        } else {
          // TRYB EDYCJI 
          final index = _dutyList.indexWhere((d) => d.id == result.id);
          if (index != -1) {
            _dutyList[index] = result;
            Fluttertoast.showToast(msg: "Dane zapisane pomyślnie.");
          }
        }
        _saveData(); // Zapisz zmiany
      });
    }
  }

  // Pomocnik do budowania pól tekstowych w dialogu (zamiast powtarzania XML)
  TextFormField _buildTextField(TextEditingController controller, String label, [int? maxLength]) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      maxLength: maxLength,
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
      // Odpowiednik Toolbar
      appBar: AppBar(
        title: const Text('Służby'),
        // Przycisk Wstecz jest dodawany automatycznie przez nawigację
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _dutyList.length,
              itemBuilder: (context, index) {
                final duty = _dutyList[index];
                // Budujemy element listy (Karta)
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    // Logika kliknięcia (Edycja/Usuwanie)
                    onTap: () => _showContextMenu(duty),
                    title: Text(
                      duty.rola, // Rola jako główny tytuł
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      '${duty.stopien} ${duty.imie} ${duty.nazwisko}', // Dane osoby
                      style: const TextStyle(fontSize: 16),
                    ),
                    trailing: Text(
                      '${duty.d}.${duty.m}.${duty.r}', // Data
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDutyDialog(),
        tooltip: 'Dodaj służbę',
        child: const Icon(Icons.add),
      ),
    );
  }
}

//#################################################################
// DEFINICJE MODELU I MANAGERA 
// UMIESZCZONE W TYM SAMYM PLIKU
//#################################################################

class Duty {
  final String d;
  final String m;
  final String r;
  final String stopien;
  final String imie;
  final String nazwisko;
  final String rola;
  final int id; // Używamy int dla System.currentTimeMillis()

  Duty({
    required this.d,
    required this.m,
    required this.r,
    required this.stopien,
    required this.imie,
    required this.nazwisko,
    required this.rola,
    required this.id,
  });

  // Metoda do konwersji obiektu Duty na mapę (do zapisu w JSON)
  Map<String, dynamic> toJson() {
    return {
      'd': d,
      'm': m,
      'r': r,
      'stopien': stopien,
      'imie': imie,
      'nazwisko': nazwisko,
      'rola': rola,
      'id': id,
    };
  }

  // Fabryka do konwersji mapy (z JSON) na obiekt Duty
  factory Duty.fromJson(Map<String, dynamic> json) {
    return Duty(
      d: json['d'] as String,
      m: json['m'] as String,
      r: json['r'] as String,
      stopien: json['stopien'] as String,
      imie: json['imie'] as String,
      nazwisko: json['nazwisko'] as String,
      rola: json['rola'] as String,
      id: json['id'] as int,
    );
  }
}

// Klasa pomocnicza do zarządzania listą Duty (Zapis/Odczyt z SharedPreferences)
// Odpowiednik logiki loadDuties() i saveDuties()
class DutyManager {
  static const String _prefsKey = "DUTIES_LIST";

  // Zapisuje listę służb do SharedPreferences jako JSON
  static Future<void> saveDuties(List<Duty> duties) async {
    final prefs = await SharedPreferences.getInstance();
    // 1. Konwertuj listę obiektów Duty na listę Map
    List<Map<String, dynamic>> dutyMaps = duties.map((duty) => duty.toJson()).toList();
    // 2. Konwertuj listę Map na string JSON
    String jsonString = jsonEncode(dutyMaps);
    // 3. Zapisz string
    await prefs.setString(_prefsKey, jsonString);
  }

  // Odczytuje listę służb z SharedPreferences
  static Future<List<Duty>> loadDuties() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_prefsKey);

    if (jsonString != null) {
      // 1. Dekoduj string JSON na listę dynamicznych map
      List<dynamic> dutyMaps = jsonDecode(jsonString);
      // 2. Konwertuj każdą mapę na obiekt Duty
      return dutyMaps.map((map) => Duty.fromJson(map)).toList();
    } else {
      // Zwróć dane testowe, jeśli nic nie ma (jak w Twoim kodzie)
      return [
        Duty(d: "05", m: "11", r: "25", stopien: "szer.", imie: "Jan", nazwisko: "Kowalski", rola: "Oficer Dyżurny", id: 1),
        Duty(d: "06", m: "11", r: "25", stopien: "kpr.", imie: "Anna", nazwisko: "Nowak", rola: "Pomocnik", id: 2),
      ];
    }
  }
}