import 'package:akontaa/providers/debt_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PaymentsByPersonPage extends StatelessWidget {
  const PaymentsByPersonPage({super.key});

  void _printDebts(BuildContext context) {
    final debtProvider = Provider.of<DebtProvider>(context, listen: false);
    final groupedDebts = debtProvider.myDebtsByPerson;

    final buffer = StringBuffer();
    buffer.writeln('--- Mes dettes par personne ---');
    groupedDebts.forEach((personName, debts) {
      buffer.writeln('\nPersonne: $personName');
      for (final debt in debts) {
        buffer.writeln('  Description: ${debt.description}');
        buffer.writeln('  Montant total: ${debt.totalAmount} Fcfa');
        buffer.writeln('  Remboursements:');
        for (final repayment in debt.repayments) {
          buffer.writeln('    - ${repayment.amount} Fcfa le ${DateFormat.yMd().format(repayment.date)}');
        }
      }
    });

    // ignore: avoid_print
    print(buffer.toString());

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Données imprimées dans la console')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final debtProvider = Provider.of<DebtProvider>(context);
    final groupedDebts = debtProvider.myDebtsByPerson;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: groupedDebts.isEmpty
          ? const Center(child: Text('Aucune dette à afficher.'))
          : ListView.builder(
              itemCount: groupedDebts.length,
              itemBuilder: (context, index) {
                final personName = groupedDebts.keys.elementAt(index);
                final debts = groupedDebts[personName]!;
                return ExpansionTile(
                  title: Text(personName),
                  children: debts.map((debt) {
                    return ListTile(
                      title: Text(debt.description),
                      subtitle: Text('Total: ${debt.totalAmount} Fcfa'),
                      trailing: Text('Restant: ${debt.remainingAmount} Fcfa'),
                    );
                  }).toList(),
                );
              },
            ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80.0),
        child: FloatingActionButton(
          onPressed: () => _printDebts(context),
          child: const Icon(Icons.print),
        ),
      ),
    );
  }
}
