import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/debt.dart';
import '../pages/debt_detail_page.dart';

class DebtCard extends StatelessWidget {
  final Debt debt;

  const DebtCard({super.key, required this.debt});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final currencyFormat =
        NumberFormat.currency(locale: 'fr_FR', symbol: 'Fcfa');
    final remainingAmount = debt.remainingAmount;
    final isOverdue = !debt.isPaid && debt.dueDate.isBefore(DateTime.now());

    final Color amountColor =
        debt.isOwedToMe ? colorScheme.secondary : colorScheme.error;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        leading: CircleAvatar(
          backgroundColor: amountColor.withOpacity(0.15),
          child: Icon(
            debt.isOwedToMe ? Icons.arrow_downward : Icons.arrow_upward,
            color: amountColor,
            size: 28,
          ),
        ),
        title: Text(
          debt.personName,
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          debt.description,
          style: theme.textTheme.bodySmall,
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              currencyFormat.format(remainingAmount),
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: amountColor,
              ),
            ),
            const SizedBox(height: 4),
            if (isOverdue)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Text(
                  'En retard',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => DebtDetailPage(debtId: debt.id),
            ),
          );
        },
      ),
    );
  }
}
