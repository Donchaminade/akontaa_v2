import 'dart:io';

import 'package:akontaa/l10n/app_localizations.dart';
import 'package:akontaa/providers/debt_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart' as p_pdf;
import 'package:printing/printing.dart';

import '../models/debt.dart';
import '../models/repayment.dart';
import '../models/transaction.dart'
    as app_transaction; // Alias to avoid conflict with flutter's Transaction
import '../app_colors.dart'; // Import AppColors

enum _DebtFilter { myDebts, owedToMe }

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({super.key});

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage> {
  _DebtFilter _selectedFilter = _DebtFilter.myDebts;

  Future<void> _generatePdf(BuildContext context,
      List<app_transaction.Transaction> transactions) async {
    final pdf = pw.Document();
    final localizations = AppLocalizations.of(context)!;
    final textStyle = pw.TextStyle(
      color: p_pdf.PdfColor.fromInt(Theme.of(context).colorScheme.onSurface.value),
    );

    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context pwContext) => [
          pw.Center(
            child: pw.Text(
              localizations.historiqueDesTransactions,
              style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: textStyle.color),
            ),
          ),
          pw.SizedBox(height: 20),
          ...transactions.map((transaction) {
            if (transaction.type == app_transaction.TransactionType.debt) {
              final debt = transaction.item as Debt;
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(localizations.typeDette,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: textStyle.color)),
                  pw.Text('  ${localizations.personne}: ${debt.personName}', style: textStyle),
                  pw.Text(
                      '  ${localizations.description}: ${debt.description}', style: textStyle),
                  pw.Text(
                      '  ${localizations.montantTotal}: ${debt.totalAmount} Fcfa', style: textStyle),
                  pw.Text(
                      '  ${localizations.dateEcheance}: ${DateFormat.yMd().format(debt.dueDate)}', style: textStyle),
                  pw.Text(
                      '  Statut: ${debt.isPaid ? localizations.rembourse : localizations.enCours}', style: textStyle),
                  pw.Divider(color: textStyle.color),
                ],
              );
            } else {
              final repayment = transaction.item as Repayment;
              final debtProvider =
                  Provider.of<DebtProvider>(context, listen: false);
              final debt = debtProvider.debts
                  .firstWhere((d) => d.repayments.contains(repayment));
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(localizations.typeRemboursement,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: textStyle.color)),
                  pw.Text('  ${localizations.aDe}: ${debt.personName}', style: textStyle),
                  pw.Text(
                      '  ${localizations.montant}: ${repayment.amount} Fcfa', style: textStyle),
                  pw.Text('  Date: ${DateFormat.yMd().format(repayment.date)}', style: textStyle),
                  pw.Text(
                      '  ${localizations.notesOptionnel}: ${repayment.notes ?? localizations.aucune}', style: textStyle),
                  pw.Text(
                      '  ${localizations.methodeDePaiement}: ${repayment.paymentMethod}', style: textStyle),
                  pw.Divider(color: textStyle.color),
                ],
              );
            }
          }).toList(),
        ],
      ),
    );

    await Printing.sharePdf(
        bytes: await pdf.save(), filename: 'transaction_history.pdf');
  }

  void _printTransactions(BuildContext context) async {
    final debtProvider = Provider.of<DebtProvider>(context, listen: false);
    final allTransactions = debtProvider.allTransactions;
    final localizations = AppLocalizations.of(context)!;

    if (allTransactions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizations.aucuneTransactionAImprimer)),
      );
      return;
    }

    // Show dialog for filtering options
    final String? filterOption = await showDialog<String>(
      context: context,
      builder: (BuildContext dialogContext) {
        return SimpleDialog(
          title: Text(localizations.imprimerLHistorique),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(dialogContext, 'all');
              },
              child: Text(localizations.toutesLesTransactions),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(dialogContext, 'myDebts');
              },
              child: Text(localizations.mesDettes),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(dialogContext, 'owedToMe');
              },
              child: Text(localizations.onMeDoit),
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
      filteredTransactions = allTransactions
          .where((t) =>
              t.type == app_transaction.TransactionType.debt &&
              !(t.item as Debt).isOwedToMe) // Filter for my debts
          .toList();
    } else if (filterOption == 'owedToMe') {
      filteredTransactions = allTransactions
          .where((t) =>
              t.type == app_transaction.TransactionType.debt &&
              (t.item as Debt).isOwedToMe) // Filter for owed to me
          .toList();
    } else {
      filteredTransactions = allTransactions; // All transactions
    }

    if (filteredTransactions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text(localizations.aucuneTransactionCorrespondanteAImprimer)),
      );
      return;
    }

    await _generatePdf(context, filteredTransactions);
  }

  @override
  Widget build(BuildContext context) {
    final debtProvider = Provider.of<DebtProvider>(context);
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

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
      appBar: AppBar(
        title: Text(localizations.historiqueDesTransactions),
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
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: Center(
              child: SegmentedButton<_DebtFilter>(
                segments: <ButtonSegment<_DebtFilter>>[
                  ButtonSegment<_DebtFilter>(
                    value: _DebtFilter.myDebts,
                    label: Text(localizations.dettes,
                        style: const TextStyle(fontSize: 16)),
                  ),
                  ButtonSegment<_DebtFilter>(
                    value: _DebtFilter.owedToMe,
                    label: Text(localizations.onMeDoit,
                        style: const TextStyle(fontSize: 16)),
                  ),
                ],
                selected: <_DebtFilter>{_selectedFilter},
                onSelectionChanged: (Set<_DebtFilter> newSelection) {
                  setState(() {
                    _selectedFilter = newSelection.first;
                  });
                },
                style: ButtonStyle(
                  minimumSize:
                      MaterialStateProperty.all(const Size(150, 50)),
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.selected)) {
                        return _selectedFilter == _DebtFilter.myDebts
                            ? AppColors.red
                            : AppColors.green;
                      }
                      return theme.colorScheme.surface.withOpacity(0.3);
                    },
                  ),
                  foregroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.selected)) {
                        return Colors.white;
                      }
                      return theme.colorScheme.onSurface;
                    },
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                      side: BorderSide(color: theme.colorScheme.onSurface.withOpacity(0.2)),
                    ),
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
                          _selectedFilter == _DebtFilter.myDebts
                              ? Icons.money_off
                              : Icons.attach_money,
                          size: 60,
                          color: theme.colorScheme.onSurface.withOpacity(0.4),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _selectedFilter == _DebtFilter.myDebts
                              ? localizations.aucuneDetteAAfficher
                              : localizations.personneNeVousDoitDArgent,
                          style: theme.textTheme.titleMedium!.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
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
                      // bool allPaid = true; // Not used directly

                      for (var debt in debtsOfPerson) {
                        totalDebtAmount += debt.totalAmount;
                        for (var repayment in debt.repayments) {
                          totalRepaid += repayment.amount;
                        }
                        // if (!debt.isPaid) {
                        //   allPaid = false;
                        // }
                      }

                      bool allDebtsPaid = debtsOfPerson.every((debt) => debt.isPaid);


                      double repaymentProgress = totalDebtAmount > 0
                          ? (totalRepaid / totalDebtAmount).clamp(0.0, 1.0)
                          : 0.0;

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: ExpansionTile(
                          leading: CircleAvatar(
                            backgroundColor: theme.colorScheme.secondary
                                .withOpacity(0.1),
                            child: Text(personName[0].toUpperCase(),
                                style: theme.textTheme.titleMedium!.copyWith(
                                    color: theme.colorScheme.secondary)),
                          ),
                          title: Text(personName,
                              style: theme.textTheme.titleMedium!
                                  .copyWith(fontWeight: FontWeight.bold)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${localizations.totalRembourse}: ${totalRepaid.toStringAsFixed(0)} Fcfa / ${totalDebtAmount.toStringAsFixed(0)} Fcfa',
                                style: theme.textTheme.bodySmall,
                              ),
                              const SizedBox(height: 4),
                              LinearProgressIndicator(
                                value: repaymentProgress,
                                backgroundColor:
                                    theme.colorScheme.surface.withOpacity(0.5),
                                color: _selectedFilter == _DebtFilter.myDebts
                                    ? AppColors.red
                                    : AppColors.green,
                                minHeight: 5,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ],
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                allDebtsPaid
                                    ? localizations.solde
                                    : localizations.enCours,
                                style: theme.textTheme.bodyMedium!.copyWith(
                                  color: allDebtsPaid
                                      ? AppColors.green
                                      : Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (!allDebtsPaid)
                                Text(
                                  '${localizations.reste}: ${(totalDebtAmount - totalRepaid).toStringAsFixed(0)} Fcfa',
                                  style: theme.textTheme.bodySmall!.copyWith(
                                      color: _selectedFilter == _DebtFilter.myDebts
                                          ? AppColors.red
                                          : AppColors.green),
                                ),
                            ],
                          ),
                          children: debtsOfPerson.expand((debt) {
                            return [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      localizations.detteDescription(
                                          debt.description,
                                          debt.totalAmount.toStringAsFixed(0)),
                                      style: theme.textTheme.titleSmall!
                                          .copyWith(fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      '${localizations.echeance}: ${DateFormat.yMd().format(debt.dueDate)}',
                                      style: theme.textTheme.bodySmall!
                                          .copyWith(
                                              color: theme.colorScheme.onSurface
                                                  .withOpacity(0.6)),
                                    ),
                                    ...debt.repayments.map((repayment) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16.0, top: 4.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(Icons.check_circle,
                                                    color: AppColors.green,
                                                    size: 16),
                                                const SizedBox(width: 8),
                                                Text(
                                                  '${localizations.remboursement}: ${repayment.amount.toStringAsFixed(0)} Fcfa le ${DateFormat.yMd().format(repayment.date)}',
                                                  style: theme.textTheme.bodyMedium,
                                                ),
                                              ],
                                            ),
                                            Text(
                                              '  ${localizations.methodeDePaiement}: ${repayment.paymentMethod}',
                                              style: theme.textTheme.bodySmall!.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.7)),
                                            ),
                                            if (repayment.notes != null && repayment.notes!.isNotEmpty)
                                              Text(
                                                '  ${localizations.notes}: ${repayment.notes}',
                                                style: theme.textTheme.bodySmall!.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.7)),
                                              ),
                                            if (repayment.proofImagePath != null && repayment.proofImagePath!.isNotEmpty)
                                              Padding(
                                                padding: const EdgeInsets.only(top: 8.0, left: 16.0),
                                                child: Image.file(File(repayment.proofImagePath!), height: 100),
                                              ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                    if (debt.repayments.isEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 16.0, top: 4.0),
                                        child: Text(
                                            localizations
                                                .aucunRemboursementEnregistrePourCetteDette,
                                            style: theme.textTheme.bodySmall!
                                                .copyWith(fontStyle: FontStyle.italic,
                                                color: theme.colorScheme.onSurface.withOpacity(0.6))),
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
