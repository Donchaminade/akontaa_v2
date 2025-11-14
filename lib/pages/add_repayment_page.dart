import 'package:akontaa/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/debt_provider.dart';
import 'add_repayment_form_page.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddRepaymentPage extends StatelessWidget {
  const AddRepaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(localizations.selectionnerUneDetteARembourser),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<DebtProvider>(
        builder: (context, debtProvider, child) {
          final myDebts =
              debtProvider.myDebts.where((debt) => !debt.isPaid).toList();

          if (myDebts.isEmpty) {
            return Center(
              child: Text(
                localizations.vousNavezAucuneDetteEnCours,
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
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListTile(
                  title: Text(debt.personName),
                  subtitle: Text(debt.description),
                  trailing:
                      Text('${debt.remainingAmount.toStringAsFixed(2)} Fcfa'),
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
