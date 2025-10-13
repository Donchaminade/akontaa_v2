import 'package:akontaa/providers/debt_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../models/debt.dart';
import '../models/repayment.dart';
import '../models/transaction.dart' as app_transaction; // Alias to avoid conflict with flutter's Transaction

class TransactionHistoryPage extends StatelessWidget {
  const TransactionHistoryPage({super.key});

  Future<void> _generatePdf(BuildContext context, List<app_transaction.Transaction> transactions) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context pwContext) => [
          pw.Center(
            child: pw.Text(
              'Historique des transactions',
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 20),
          ...transactions.map((transaction) {
            if (transaction.type == app_transaction.TransactionType.debt) {
              final debt = transaction.item as Debt;
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Type: Dette', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('  Personne: ${debt.personName}'),
                  pw.Text('  Description: ${debt.description}'),
                  pw.Text('  Montant total: ${debt.totalAmount} Fcfa'),
                  pw.Text('  Date d\'échéance: ${DateFormat.yMd().format(debt.dueDate)}'),
                  pw.Text('  Statut: ${debt.isPaid ? 'Remboursé' : 'En cours'}'),
                  pw.Divider(),
                ],
              );
            } else {
              final repayment = transaction.item as Repayment;
              final debtProvider = Provider.of<DebtProvider>(context, listen: false);
              final debt = debtProvider.debts.firstWhere((d) => d.repayments.contains(repayment));
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Type: Remboursement', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text('  À/De: ${debt.personName}'),
                  pw.Text('  Montant: ${repayment.amount} Fcfa'),
                  pw.Text('  Date: ${DateFormat.yMd().format(repayment.date)}'),
                  pw.Text('  Notes/Preuve: ${repayment.notes ?? 'Aucune'}'), // Updated label
                  pw.Divider(),
                ],
              );
            }
          }).toList(),
        ],
      ),
    );

    await Printing.sharePdf(bytes: await pdf.save(), filename: 'transaction_history.pdf');
  }

  void _printTransactions(BuildContext context) async {
    final debtProvider = Provider.of<DebtProvider>(context, listen: false);
    final allTransactions = debtProvider.allTransactions;

    if (allTransactions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aucune transaction à imprimer.')),
      );
      return;
    }

    // Show dialog for filtering options
    final String? filterOption = await showDialog<String>(
      context: context,
      builder: (BuildContext dialogContext) {
        return SimpleDialog(
          title: const Text('Imprimer l\'historique'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(dialogContext, 'all');
              },
              child: const Text('Toutes les transactions'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(dialogContext, 'myDebts');
              },
              child: const Text('Mes dettes'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(dialogContext, 'owedToMe');
              },
              child: const Text('On me doit'),
            ),
          ],
        );
      },
    );

    if (filterOption == null) {
      return; // User cancelled the dialog
    }

    List<app_transaction.Transaction> filteredTransactions = [];
    if (filterOption == 'myDebts') {
      filteredTransactions =
          allTransactions.where((t) => t.type == app_transaction.TransactionType.debt && !(t.item as Debt).isOwedToMe) // Filter for my debts
              .toList();
    } else if (filterOption == 'owedToMe') {
      filteredTransactions =
          allTransactions.where((t) => t.type == app_transaction.TransactionType.debt && (t.item as Debt).isOwedToMe) // Filter for owed to me
              .toList();
    } else {
      filteredTransactions = allTransactions; // All transactions
    }

    if (filteredTransactions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aucune transaction correspondante à imprimer.')),
      );
      return;
    }

    await _generatePdf(context, filteredTransactions);
  }

  @override
  Widget build(BuildContext context) {
    final debtProvider = Provider.of<DebtProvider>(context);
    final allTransactions = debtProvider.allTransactions;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: allTransactions.isEmpty
          ? const Center(child: Text('Aucune transaction à afficher.'))
          : ListView.builder(
              itemCount: allTransactions.length,
              itemBuilder: (context, index) {
                final transaction = allTransactions[index];
                if (transaction.type == app_transaction.TransactionType.debt) {
                  final debt = transaction.item as Debt;
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                    child: ListTile(
                      leading: Icon(debt.isOwedToMe ? Icons.arrow_downward : Icons.arrow_upward,
                          color: debt.isOwedToMe ? Colors.green : Colors.red),
                      title: Text('${debt.personName} - ${debt.description}'),
                      subtitle: Text('Montant: ${debt.totalAmount} Fcfa, Échéance: ${DateFormat.yMd().format(debt.dueDate)}'),
                      trailing: Text(debt.isPaid ? 'Remboursé' : 'En cours'),
                    ),
                  );
                } else {
                  final repayment = transaction.item as Repayment;
                  final debtProvider = Provider.of<DebtProvider>(context, listen: false);
                  final debt = debtProvider.debts.firstWhere((d) => d.repayments.contains(repayment));
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                    child: ListTile(
                      leading: const Icon(Icons.payment, color: Colors.blue), // Changed to a generic payment icon
                      title: Text('Remboursement à ${debt.personName}'),
                      subtitle: Text('Montant: ${repayment.amount} Fcfa, Date: ${DateFormat.yMd().format(repayment.date)}'),
                      trailing: Text(repayment.notes ?? ''),
                    ),
                  );
                }
              },
            ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80.0),
        child: FloatingActionButton(
          onPressed: () => _printTransactions(context),
          child: const Icon(Icons.print),
        ),
      ),
    );
  }
}