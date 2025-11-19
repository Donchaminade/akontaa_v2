import 'dart:io';
import 'dart:ui';
import 'package:akontaa/app_colors.dart';
import 'package:akontaa/l10n/app_localizations.dart';
import 'package:akontaa/pages/add_repayment_form_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/debt.dart';
import '../models/repayment.dart';
import '../providers/debt_provider.dart';
import 'add_edit_debt_page.dart';

class DebtDetailPage extends StatelessWidget {
  final String debtId;

  const DebtDetailPage({super.key, required this.debtId});

  @override
  Widget build(BuildContext context) {
    final debt = Provider.of<DebtProvider>(context).findById(debtId);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(debt.personName),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => AddEditDebtPage(debt: debt),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: AlertDialog(
                    backgroundColor:
                        Theme.of(context).colorScheme.surface.withOpacity(0.7),
                    title: Text(localizations.confirmerLaSuppression),
                    content: Text(
                        localizations.etesVousSurDeVouloirSupprimerCetteDette),
                    actions: [
                      TextButton(
                        child: Text(localizations.annuler),
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                      TextButton(
                        child: Text(localizations.supprimer,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.error)),
                        onPressed: () {
                          Provider.of<DebtProvider>(context, listen: false)
                              .deleteDebt(debtId);
                          Navigator.of(ctx).pop(); // Ferme la dialog
                          Navigator.of(context)
                              .pop(); // Retourne à l'écran précédent
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailCard(context, debt),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  localizations.historiqueDesRemboursements,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: 10),
              _buildRepaymentsList(context, debt),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80.0),
        child: FloatingActionButton(
          onPressed: debt.isPaid
              ? null
              : () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => AddRepaymentFormPage(debt: debt),
                  ));
                },
          backgroundColor: debt.isPaid
              ? Colors.grey
              : Theme.of(context).colorScheme.secondary,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildDetailCard(BuildContext context, Debt debt) {
    final currencyFormat =
        NumberFormat.currency(locale: 'fr_FR', symbol: 'Fcfa');
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              debt.description,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            const Divider(),
            _buildInfoRow(
              context,
              localizations.montantTotalDeuxPoints,
              currencyFormat.format(debt.totalAmount),
            ),
            _buildInfoRow(
              context,
              localizations.montantRestantDeuxPoints,
              currencyFormat.format(debt.remainingAmount),
              highlight: true,
              color: debt.isOwedToMe ? AppColors.green : AppColors.red,
            ),
            _buildInfoRow(
              context,
              localizations.dateEcheanceDeuxPoints,
              DateFormat('dd/MM/yyyy').format(debt.dueDate),
            ),
            _buildInfoRow(
              context,
              localizations.statutDeuxPoints,
              debt.isPaid ? localizations.rembourse : localizations.enCours,
              color: debt.isPaid ? AppColors.green : Colors.orangeAccent,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value,
      {bool highlight = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyLarge),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: highlight ? FontWeight.bold : FontWeight.normal,
              color: color ?? Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRepaymentsList(BuildContext context, Debt debt) {
    final localizations = AppLocalizations.of(context)!;
    if (debt.repayments.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(localizations.aucunRemboursementPourLeMoment),
        ),
      );
    }

    final currencyFormat =
        NumberFormat.currency(locale: 'fr_FR', symbol: 'Fcfa');

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: debt.repayments.length,
      itemBuilder: (ctx, index) {
        final repayment = debt.repayments[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: ExpansionTile(
            leading: const Icon(Icons.payment),
            title: Text(currencyFormat.format(repayment.amount)),
            subtitle: Text(DateFormat.yMd().add_jm().format(repayment.date)),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow(context, localizations.methodeDePaiement, repayment.paymentMethod),
                    if (repayment.notes != null && repayment.notes!.isNotEmpty)
                      _buildInfoRow(context, localizations.notes, repayment.notes!),
                    if (repayment.proofImagePath != null && repayment.proofImagePath!.isNotEmpty) ...[
                      const SizedBox(height: 10),
                       Text(localizations.preuvePhoto, style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(height: 8),
                      Image.file(File(repayment.proofImagePath!)),
                    ]
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
