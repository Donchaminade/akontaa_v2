import 'package:akontaa/app_colors.dart';
import 'package:akontaa/models/debt.dart';
import 'package:akontaa/models/repayment.dart';
import 'package:akontaa/models/transaction.dart';
import 'package:akontaa/pages/add_edit_debt_page.dart';
import 'package:akontaa/pages/add_repayment_page.dart';
import 'package:akontaa/pages/transaction_history_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/debt_provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final PageController _pageController = PageController(viewportFraction: 0.85);
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final debtProvider = Provider.of<DebtProvider>(context);
    final totalOwedToMe = debtProvider.totalOwedToMe;
    final totalMyDebts = debtProvider.totalMyDebts;
    final recentTransactions = debtProvider.recentTransactions;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 160,
                child: PageView(
                  controller: _pageController,
                  children: [
                    _buildSummaryCard(context, 'On me doit', totalOwedToMe, AppColors.green),
                    _buildSummaryCard(context, 'Mes dettes', totalMyDebts, AppColors.red),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(2, (index) => _buildDot(index, context)),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildQuickAction(context, Icons.add, 'Ajouter', () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) => const AddEditDebtPage()),
                      );
                    }),
                    _buildQuickAction(context, Icons.payment, 'Rembourser', () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) => const AddRepaymentPage()),
                      );
                    }),
                    _buildQuickAction(context, Icons.history, 'Historique', () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) => const TransactionHistoryPage()),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('Activité récente', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 16),
              if (recentTransactions.isEmpty)
                const Center(child: Text('Aucune activité récente.'))
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recentTransactions.length,
                  itemBuilder: (context, index) {
                    final transaction = recentTransactions[index];
                    return _buildTransactionItem(context, transaction);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDot(int index, BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: _currentPage == index ? 24 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index ? Theme.of(context).colorScheme.secondary : Colors.grey,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, String title, double amount, Color color) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.7), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            Text('${amount.toStringAsFixed(2)} Fcfa', style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
            child: Icon(icon, size: 30, color: Theme.of(context).colorScheme.secondary),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(BuildContext context, Transaction transaction) {
    if (transaction.type == TransactionType.debt) {
      final debt = transaction.item as Debt;
      return ListTile(
        leading: CircleAvatar(backgroundColor: debt.isOwedToMe ? AppColors.green.withOpacity(0.2) : AppColors.red.withOpacity(0.2), child: Icon(Icons.arrow_downward, color: debt.isOwedToMe ? AppColors.green : AppColors.red)),
        title: Text(debt.personName),
        subtitle: Text(debt.description),
        trailing: Text('${debt.totalAmount} Fcfa', style: TextStyle(color: debt.isOwedToMe ? AppColors.green : AppColors.red)),
      );
    } else {
      final repayment = transaction.item as Repayment;
      // Find the debt this repayment belongs to
      final debtProvider = Provider.of<DebtProvider>(context, listen: false);
      final debt = debtProvider.debts.firstWhere((d) => d.repayments.contains(repayment));
      return ListTile(
        leading: CircleAvatar(backgroundColor: Colors.blue.withOpacity(0.2), child: const Icon(Icons.arrow_upward, color: Colors.blue)),
        title: Text('Remboursement à ${debt.personName}'),
        subtitle: Text(repayment.notes ?? 'Pas de notes'),
        trailing: Text('${repayment.amount} Fcfa', style: const TextStyle(color: Colors.blue)),
      );
    }
  }
}
