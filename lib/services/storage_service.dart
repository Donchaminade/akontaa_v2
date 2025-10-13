import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/debt.dart';

class StorageService {
  static const String _debtsKey = 'debts';

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
}