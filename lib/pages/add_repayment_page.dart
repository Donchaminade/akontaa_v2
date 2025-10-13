import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/debt_provider.dart';
import 'add_repayment_form_page.dart';

class AddRepaymentPage extends StatelessWidget {
  const AddRepaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Sélectionner une dette à rembourser'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<DebtProvider>(
        builder: (context, debtProvider, child) {
          final myDebts = debtProvider.myDebts.where((debt) => !debt.isPaid).toList();

          if (myDebts.isEmpty) {
            return const Center(
              child: Text(
                'Vous n\'avez aucune dette en cours.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            itemCount: myDebts.length,
            itemBuilder: (ctx, i) {
              final debt = myDebts[i];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListTile(
                  title: Text(debt.personName),
                  subtitle: Text(debt.description),
                  trailing: Text('${debt.remainingAmount.toStringAsFixed(2)} Fcfa'),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => AddRepaymentFormPage(debt: debt),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}