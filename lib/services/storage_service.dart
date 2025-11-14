import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/debt.dart';
import '../models/event.dart';

class StorageService {
  static const String _debtsKey = 'debts';
  static const String _eventsKey = 'events';

  // Sauvegarder la liste des dettes en JSON
  Future<void> saveDebts(List<Debt> debts) async {
    final prefs = await SharedPreferences.getInstance();
    final debtsJson = debts.map((debt) => debt.toJson()).toList();
    await prefs.setString(_debtsKey, json.encode(debtsJson));
  }

  // Charger la liste des dettes depuis le JSON
  Future<List<Debt>> loadDebts() async {
    final prefs = await SharedPreferences.getInstance();
    final debtsString = prefs.getString(_debtsKey);

    if (debtsString == null) {
      return []; // Retourne une liste vide si aucune donnée n'est trouvée
    }

    final List<dynamic> debtsJson = json.decode(debtsString);
    return debtsJson.map((json) => Debt.fromJson(json)).toList();
  }

  // Sauvegarder la liste des événements en JSON
  Future<void> saveEvents(List<Event> events) async {
    final prefs = await SharedPreferences.getInstance();
    final eventsJson = events.map((event) => event.toJson()).toList();
    await prefs.setString(_eventsKey, json.encode(eventsJson));
  }

  // Charger la liste des événements depuis le JSON
  Future<List<Event>> loadEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final eventsString = prefs.getString(_eventsKey);

    if (eventsString == null) {
      return []; // Retourne une liste vide si aucune donnée n'est trouvée
    }

    final List<dynamic> eventsJson = json.decode(eventsString);
    return eventsJson.map((json) => Event.fromJson(json)).toList();
  }
}
