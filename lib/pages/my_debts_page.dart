import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/debt_provider.dart';
import '../widgets/debt_card.dart';

class MyDebtsPage extends StatelessWidget {
  const MyDebtsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final debtProvider = Provider.of<DebtProvider>(context);
    final myDebts = debtProvider.myDebts;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: myDebts.isEmpty
          ? const Center(
              child: Text(
                'Vous n\'avez aucune dette. Félicitations !',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: myDebts.length,
              itemBuilder: (ctx, i) => DebtCard(debt: myDebts[i]),
            ),
    );
  }
}
