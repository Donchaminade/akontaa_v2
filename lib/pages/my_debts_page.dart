import 'package:akontaa/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/debt_provider.dart';
import '../widgets/debt_card.dart';

class MyDebtsPage extends StatelessWidget {
  const MyDebtsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final debtProvider = Provider.of<DebtProvider>(context);
    final myDebts = debtProvider.myDebts;
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: myDebts.isEmpty
          ? Center(
              child: Text(
                localizations.vousNavezAucuneDettePourLeMoment,
                style: const TextStyle(fontSize: 18, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              itemCount: myDebts.length,
              itemBuilder: (context, index) {
                return DebtCard(debt: myDebts[index]);
              },
            ),
    );
  }
}
