import 'package:akontaa/models/transaction.dart';
import 'package:akontaa/services/notification_service.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/debt.dart';
import '../models/repayment.dart';
import '../services/storage_service.dart';

class DebtProvider with ChangeNotifier {
  final StorageService _storageService = StorageService();
  final NotificationService _notificationService = NotificationService();
  List<Debt> _debts = [];

  List<Debt> get debts => [..._debts];

  List<Debt> get myDebts => _debts.where((d) => !d.isOwedToMe).toList();

  List<Debt> get owedToMeDebts => _debts.where((d) => d.isOwedToMe).toList();

  Map<String, List<Debt>> get myDebtsByPerson {
    final Map<String, List<Debt>> groupedDebts = {};
    for (final debt in myDebts) {
      if (groupedDebts.containsKey(debt.personName)) {
        groupedDebts[debt.personName]!.add(debt);
      } else {
        groupedDebts[debt.personName] = [debt];
      }
    }
    return groupedDebts;
  }

  double get totalMyDebts {
    return myDebts.fold(0.0, (sum, debt) => sum + debt.remainingAmount);
  }

  double get totalOwedToMe {
    return owedToMeDebts.fold(0.0, (sum, debt) => sum + debt.remainingAmount);
  }

  List<Transaction> get recentTransactions {
    final List<Transaction> transactions = [];
    for (final debt in _debts) {
      transactions.add(Transaction(
          item: debt, type: TransactionType.debt, date: debt.dueDate));
      for (final repayment in debt.repayments) {
        transactions.add(Transaction(
            item: repayment,
            type: TransactionType.repayment,
            date: repayment.date));
      }
    }
    transactions.sort((a, b) => b.date.compareTo(a.date));
    return transactions.take(5).toList();
  }

  List<Transaction> get allTransactions {
    final List<Transaction> transactions = [];
    for (final debt in _debts) {
      transactions.add(Transaction(
          item: debt, type: TransactionType.debt, date: debt.dueDate));
      for (final repayment in debt.repayments) {
        transactions.add(Transaction(
            item: repayment,
            type: TransactionType.repayment,
            date: repayment.date));
      }
    }
    transactions
        .sort((a, b) => b.date.compareTo(a.date)); // Sort by date, newest first
    return transactions;
  }

  Debt findById(String id) {
    return _debts.firstWhere((debt) => debt.id == id);
  }

  Future<void> loadDebts() async {
    _debts = await _storageService.loadDebts();
    // _addSampleData(); // Removed to prevent data reset
    await _notificationService.rescheduleAllNotifications(_debts);
    notifyListeners();
  }

  Future<void> _saveDebts() async {
    await _storageService.saveDebts(_debts);
    notifyListeners();
  }

  Future<void> addDebt(Debt debt) async {
    _debts.add(debt);
    await _notificationService.scheduleDueDateNotification(debt);
    await _saveDebts();
  }

  Future<void> updateDebt(Debt updatedDebt) async {
    final index = _debts.indexWhere((debt) => debt.id == updatedDebt.id);
    if (index != -1) {
      _debts[index] = updatedDebt;
      await _notificationService.cancelNotification(updatedDebt.id);
      await _notificationService.scheduleDueDateNotification(updatedDebt);
      await _saveDebts();
    }
  }

  Future<void> deleteDebt(String id) async {
    _debts.removeWhere((debt) => debt.id == id);
    await _notificationService.cancelNotification(id);
    await _saveDebts();
  }

  Future<void> addRepayment(String debtId, Repayment repayment) async {
    final debt = findById(debtId);
    debt.repayments.add(repayment);
    if (debt.isPaid) {
      await _notificationService.cancelNotification(debtId);
    }
    await _saveDebts();
  }

  Future<void> clearMyDebts() async {
    final myDebtsIds = myDebts.map((d) => d.id).toList();
    for (final id in myDebtsIds) {
      await _notificationService.cancelNotification(id);
    }
    _debts.removeWhere((debt) => !debt.isOwedToMe);
    await _saveDebts();
  }

  Future<void> clearOwedToMeDebts() async {
    final owedToMeDebtsIds = owedToMeDebts.map((d) => d.id).toList();
    for (final id in owedToMeDebtsIds) {
      await _notificationService.cancelNotification(id);
    }
    _debts.removeWhere((debt) => debt.isOwedToMe);
    await _saveDebts();
  }

  Future<void> clearAllDebts() async {
    for (final debt in _debts) {
      await _notificationService.cancelNotification(debt.id);
    }
    _debts.clear();
    await _saveDebts();
  }

  void _addSampleData() {
    const uuid = Uuid();
    _debts = [
      Debt(
        id: uuid.v4(),
        personName: 'John Doe',
        totalAmount: 150.0,
        description: 'Prêt pour le déjeuner',
        dueDate: DateTime.now().add(const Duration(days: 10)),
        isOwedToMe: true,
        repayments: [
          Repayment(id: uuid.v4(), amount: 50.0, date: DateTime.now()),
        ],
      ),
      Debt(
        id: uuid.v4(),
        personName: 'Jane Smith',
        totalAmount: 200.0,
        description: 'Achat de billets de concert',
        dueDate: DateTime.now().add(const Duration(days: 30)),
        isOwedToMe: false,
      ),
      Debt(
        id: uuid.v4(),
        personName: 'Peter Jones',
        totalAmount: 75.0,
        description: 'Cadeau commun',
        dueDate: DateTime.now().subtract(const Duration(days: 5)),
        isOwedToMe: true,
      ),
    ];
  }
}
