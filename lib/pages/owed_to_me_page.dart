import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/debt_provider.dart';
import '../widgets/debt_card.dart';

class OwedToMePage extends StatelessWidget {
  const OwedToMePage({super.key});

  @override
  Widget build(BuildContext context) {
    final debtProvider = Provider.of<DebtProvider>(context);
    final owedToMeDebts = debtProvider.owedToMeDebts;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: owedToMeDebts.isEmpty
          ? const Center(
              child: Text(
                'Personne ne vous doit d\'argent.',
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
