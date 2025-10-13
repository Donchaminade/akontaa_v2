import 'dart:ui';
import 'package:akontaa/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../models/debt.dart';
import '../models/repayment.dart';
import '../providers/debt_provider.dart';
import 'add_edit_debt_page.dart';

class DebtDetailPage extends StatelessWidget {
  final String debtId;

  const DebtDetailPage({super.key, required this.debtId});

  void _showAddRepaymentDialog(BuildContext context, Debt debt) {
    final amountController = TextEditingController();
    final notesController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.7),
          title: const Text('Ajouter un remboursement'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: amountController,
                  decoration: const InputDecoration(labelText: 'Montant'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null ||
                        double.tryParse(value) == null ||
                        double.parse(value) <= 0) {
                      return 'Montant invalide.';
                    }
                    if (double.parse(value) > debt.remainingAmount) {
                      return 'Le montant ne peut pas dépasser le solde restant.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: notesController,
                  decoration: const InputDecoration(labelText: 'Notes (optionnel)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Annuler'),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Ajouter'),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final newRepayment = Repayment(
                    id: const Uuid().v4(),
                    amount: double.parse(amountController.text),
                    date: DateTime.now(),
                    notes: notesController.text,
                  );
                  Provider.of<DebtProvider>(context, listen: false)
                      .addRepayment(debt.id, newRepayment);
                  Navigator.of(ctx).pop();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final debt = Provider.of<DebtProvider>(context).findById(debtId);

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
                    backgroundColor: Theme.of(context).colorScheme.surface.withOpacity(0.7),
                    title: const Text('Confirmer la suppression'),
                    content: const Text(
                        'Êtes-vous sûr de vouloir supprimer cette dette ?'),
                    actions: [
                      TextButton(
                        child: const Text('Annuler'),
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                      TextButton(
                        child: Text('Supprimer', style: TextStyle(color: Theme.of(context).colorScheme.error)),
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
                  'Historique des remboursements',
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
          onPressed: debt.isPaid ? null : () => _showAddRepaymentDialog(context, debt),
          backgroundColor: debt.isPaid ? Colors.grey : Theme.of(context).colorScheme.secondary,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildDetailCard(BuildContext context, Debt debt) {
    final currencyFormat = NumberFormat.currency(locale: 'fr_FR', symbol: 'Fcfa');
    final theme = Theme.of(context);

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
              'Montant total:',
              currencyFormat.format(debt.totalAmount),
            ),
            _buildInfoRow(
              context,
              'Montant restant:',
              currencyFormat.format(debt.remainingAmount),
              highlight: true,
              color: debt.isOwedToMe ? AppColors.green : AppColors.red,
            ),
            _buildInfoRow(
              context,
              'Date d\'échéance:',
              DateFormat('dd/MM/yyyy').format(debt.dueDate),
            ),
            _buildInfoRow(
              context,
              'Statut:',
              debt.isPaid ? 'Remboursé' : 'En cours',
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
    if (debt.repayments.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text('Aucun remboursement pour le moment.'),
        ),
      );
    }

    final currencyFormat = NumberFormat.currency(locale: 'fr_FR', symbol: 'Fcfa');

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: debt.repayments.length,
      itemBuilder: (ctx, index) {
        final repayment = debt.repayments[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          child: ListTile(
            leading: const Icon(Icons.payment),
            title: Text(currencyFormat.format(repayment.amount)),
            subtitle: Text(DateFormat('dd/MM/yyyy').format(repayment.date)),
            trailing: repayment.notes != null && repayment.notes!.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.comment),
                    onPressed: () {
                      showDialog(
                        context: ctx,
                        builder: (dCtx) => AlertDialog(
                          title: const Text('Notes'),
                          content: Text(repayment.notes!),
                          actions: [
                            TextButton(
                              child: const Text('Fermer'),
                              onPressed: () => Navigator.of(dCtx).pop(),
                            )
                          ],
                        ),
                      );
                    },
                  )
                : null,
          ),
        );
      },
    );
  }
}
