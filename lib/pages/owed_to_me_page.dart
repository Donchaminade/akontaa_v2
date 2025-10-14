import 'package:akontaa/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/debt_provider.dart';
import '../widgets/debt_card.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OwedToMePage extends StatelessWidget {
  const OwedToMePage({super.key});

  @override
  Widget build(BuildContext context) {
    final debtProvider = Provider.of<DebtProvider>(context);
    final owedToMeDebts = debtProvider.owedToMeDebts;
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: owedToMeDebts.isEmpty
          ? Center(
              child: Text(
                localizations.personneNeVousDoitDArgent,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: owedToMeDebts.length,
              itemBuilder: (ctx, i) => DebtCard(debt: owedToMeDebts[i]),
            ),
    );
  }
}
