import 'package:akontaa/providers/debt_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../models/debt.dart';
import '../models/repayment.dart';
import '../models/transaction.dart' as app_transaction; // Alias to avoid conflict with flutter's Transaction
import '../app_colors.dart'; // Import AppColors

enum _DebtFilter { myDebts, owedToMe }

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({super.key});

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  _DebtFilter _selectedFilter = _DebtFilter.myDebts;

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

    // Filter debts based on the selected tab
    final List<Debt> filteredDebts = debtProvider.debts.where((debt) {
      if (_selectedFilter == _DebtFilter.myDebts) {
        return !debt.isOwedToMe; // Debts I owe
      } else {
        return debt.isOwedToMe; // Debts owed to me
      }
    }).toList();

    // Group filtered debts by personName
    final Map<String, List<Debt>> groupedDebts = {};
    for (var debt in filteredDebts) {
      groupedDebts.update(
        debt.personName,
        (value) => value..add(debt),
        ifAbsent: () => [debt],
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Historique des transactions'),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () => _printTransactions(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
            child: Center(
              child: SegmentedButton<_DebtFilter>(
                segments: const <ButtonSegment<_DebtFilter>>[
                  ButtonSegment<_DebtFilter>(
                    value: _DebtFilter.myDebts,
                    label: Text('Dettes', style: TextStyle(fontSize: 16)),
                  ),
                  ButtonSegment<_DebtFilter>(
                    value: _DebtFilter.owedToMe,
                    label: Text('On me doit', style: TextStyle(fontSize: 16)),
                  ),
                ],
                selected: <_DebtFilter>{_selectedFilter},
                onSelectionChanged: (Set<_DebtFilter> newSelection) {
                  setState(() {
                    _selectedFilter = newSelection.first;
                  });
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(150, 70)), // Make buttons larger
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.selected)) {
                        return _selectedFilter == _DebtFilter.myDebts
                            ? AppColors.red
                            : AppColors.green;
                      }
                      return Colors.grey.withOpacity(0.3);
                    },
                  ),
                  foregroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.selected)) {
                        return Colors.white;
                      }
                      return Colors.black; // Or a default color for unselected
                    },
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: groupedDebts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _selectedFilter == _DebtFilter.myDebts ? Icons.money_off : Icons.attach_money,
                          size: 60,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _selectedFilter == _DebtFilter.myDebts
                              ? 'Aucune dette à afficher.'
                              : 'Personne ne vous doit d\'argent.',
                          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: groupedDebts.keys.length,
                    itemBuilder: (context, index) {
                      final personName = groupedDebts.keys.elementAt(index);
                      final debtsOfPerson = groupedDebts[personName]!;

                      double totalRepaid = 0;
                      double totalDebtAmount = 0;
                      bool allPaid = true;

                      for (var debt in debtsOfPerson) {
                        totalDebtAmount += debt.totalAmount;
                        for (var repayment in debt.repayments) {
                          totalRepaid += repayment.amount;
                        }
                        if (!debt.isPaid) {
                          allPaid = false;
                        }
                      }

                      double repaymentProgress = totalDebtAmount > 0 ? (totalRepaid / totalDebtAmount).clamp(0.0, 1.0) : 0.0;

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: ExpansionTile(
                          leading: CircleAvatar(
                            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
                            child: Text(personName[0].toUpperCase(), style: TextStyle(color: Theme.of(context).primaryColor)),
                          ),
                          title: Text(personName, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total remboursé: ${totalRepaid.toStringAsFixed(0)} Fcfa / ${totalDebtAmount.toStringAsFixed(0)} Fcfa',
                                style: TextStyle(color: Colors.grey[700]),
                              ),
                              const SizedBox(height: 4),
                              LinearProgressIndicator(
                                value: repaymentProgress,
                                backgroundColor: Colors.grey[300],
                                color: _selectedFilter == _DebtFilter.myDebts ? Colors.red.withOpacity(0.7) : Colors.green.withOpacity(0.7),
                                minHeight: 5,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ],
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                allPaid ? 'Soldé' : 'En cours',
                                style: TextStyle(
                                  color: allPaid ? Colors.green : Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (!allPaid && _selectedFilter == _DebtFilter.myDebts)
                                Text(
                                  'Reste: ${(totalDebtAmount - totalRepaid).toStringAsFixed(0)} Fcfa',
                                  style: const TextStyle(color: Colors.red, fontSize: 12),
                                ),
                              if (!allPaid && _selectedFilter == _DebtFilter.owedToMe)
                                Text(
                                  'Reste: ${(totalDebtAmount - totalRepaid).toStringAsFixed(0)} Fcfa',
                                  style: const TextStyle(color: Colors.green, fontSize: 12),
                                ),
                            ],
                          ),
                          children: debtsOfPerson.expand((debt) {
                            return [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Dette: ${debt.description} - ${debt.totalAmount.toStringAsFixed(0)} Fcfa',
                                      style: const TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      'Échéance: ${DateFormat.yMd().format(debt.dueDate)}',
                                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                    ),
                                    ...debt.repayments.map((repayment) {
                                      return Padding(
                                        padding: const EdgeInsets.only(left: 16.0, top: 4.0),
                                        child: Row(
                                          children: [
                                            Icon(Icons.check_circle, color: Colors.green[400], size: 16),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Remboursement: ${repayment.amount.toStringAsFixed(0)} Fcfa le ${DateFormat.yMd().format(repayment.date)}',
                                              style: TextStyle(color: Colors.grey[800]),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                    if (debt.repayments.isEmpty)
                                      const Padding(
                                        padding: EdgeInsets.only(left: 16.0, top: 4.0),
                                        child: Text('Aucun remboursement enregistré pour cette dette.', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)),
                                      ),
                                    const Divider(height: 16, thickness: 1),
                                  ],
                                ),
                              ),
                            ];
                          }).toList(),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}