import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

import '../providers/debt_provider.dart';
import '../app_colors.dart';
import '../models/debt.dart';
import '../models/repayment.dart';
import '../models/transaction.dart';

class DebtFlowChart extends StatefulWidget {
  const DebtFlowChart({super.key});

  @override
  State<DebtFlowChart> createState() => _DebtFlowChartState();
}

class _DebtFlowChartState extends State<DebtFlowChart> {
  @override
  Widget build(BuildContext context) {
    final debtProvider = Provider.of<DebtProvider>(context);
    final allTransactions = debtProvider.allTransactions;

    // Convert map to a sorted list of _ChartDataPoint
    List<_ChartDataPoint> chartData = [];
    List<_ChartDataPoint> weeklyRepaymentData = [];

    if (allTransactions.isEmpty) {
      return const Center(
        child: Text('Aucune donnée de dette ou de remboursement pour le graphique.'),
      );
    }

    // Déterminer la période totale
    final firstTransactionDate = allTransactions.last.date; // oldest
    final lastTransactionDate = allTransactions.first.date; // newest

    // Données cumulées mensuelles
    DateTime currentMonth = DateTime(firstTransactionDate.year, firstTransactionDate.month, 1);
    double cumulativeOwedToMe = 0;
    double cumulativeMyDebts = 0;

    while (currentMonth.isBefore(lastTransactionDate) ||
        currentMonth.isAtSameMomentAs(lastTransactionDate)) {
      double monthOwedToMeChange = 0;
      double monthMyDebtsChange = 0;

      // Calcul des montants mensuels
      for (var transaction in allTransactions.where((t) =>
          t.date.year == currentMonth.year && t.date.month == currentMonth.month)) {
        if (transaction.type == TransactionType.debt) {
          final debt = transaction.item as Debt;
          if (debt.isOwedToMe) {
            monthOwedToMeChange += debt.totalAmount;
          } else {
            monthMyDebtsChange += debt.totalAmount;
          }
        } else if (transaction.type == TransactionType.repayment) {
          final repayment = transaction.item as Repayment;
          final debt = debtProvider.debts.firstWhere(
              (d) => d.repayments.any((r) => r.id == repayment.id));
          if (debt.isOwedToMe) {
            monthOwedToMeChange -= repayment.amount;
          } else {
            monthMyDebtsChange -= repayment.amount;
          }
        }
      }

      cumulativeOwedToMe += monthOwedToMeChange;
      cumulativeMyDebts += monthMyDebtsChange;

      chartData.add(_ChartDataPoint(currentMonth, cumulativeOwedToMe, cumulativeMyDebts));

      currentMonth = DateTime(currentMonth.year, currentMonth.month + 1, 1);
    }

    // Données hebdomadaires pour remboursements
    Map<String, double> weeklyRepaymentTotals = {};
    for (var transaction in allTransactions) {
      if (transaction.type == TransactionType.repayment) {
        final repayment = transaction.item as Repayment;
        final weekStartDate =
            transaction.date.subtract(Duration(days: transaction.date.weekday - 1));
        final weekKey =
            '${weekStartDate.year}-${weekStartDate.month.toString().padLeft(2, '0')}-${weekStartDate.day.toString().padLeft(2, '0')}';
        weeklyRepaymentTotals.update(
          weekKey,
          (value) => value + repayment.amount,
          ifAbsent: () => repayment.amount,
        );
      }
    }

    final sortedWeekKeys = weeklyRepaymentTotals.keys.toList()..sort();
    for (final weekKey in sortedWeekKeys) {
      final parts = weekKey.split('-');
      final weekStartDate =
          DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
      weeklyRepaymentData.add(
          _ChartDataPoint(weekStartDate, weeklyRepaymentTotals[weekKey]!, 0));
    }

    if (chartData.isEmpty && weeklyRepaymentData.isEmpty) {
      return const Center(
        child: Center(child: Text('Aucune donnée de dette ou de remboursement pour le graphique.')),
      );
    }

    return SfCartesianChart(
      backgroundColor: Colors.transparent,
      plotAreaBackgroundColor: Colors.transparent,
      primaryXAxis: DateTimeAxis(
        dateFormat: DateFormat.MMM(),
        intervalType: DateTimeIntervalType.months,
        majorGridLines: const MajorGridLines(width: 0),
        axisLine: const AxisLine(width: 0.5, color: Colors.grey),
      ),
      primaryYAxis: NumericAxis(
        numberFormat: NumberFormat.compact(),
        majorGridLines: const MajorGridLines(width: 0.3, color: Colors.grey),
        axisLine: const AxisLine(width: 0.5, color: Colors.grey),
      ),
      series: <CartesianSeries<dynamic, DateTime>>[
        // 🌊 Courbe 1 : On me doit
        SplineSeries<_ChartDataPoint, DateTime>(
          dataSource: chartData,
          xValueMapper: (data, _) => data.month,
          yValueMapper: (data, _) => data.owedToMe,
          name: 'On me doit',
          color: AppColors.green,
          width: 4,
          splineType: SplineType.natural, // rend la ligne plus fluide
          markerSettings: const MarkerSettings(isVisible: true),
          animationDuration: 1500,
        ),

        // ❤️ Courbe 2 : Mes dettes
        SplineSeries<_ChartDataPoint, DateTime>(
          dataSource: chartData,
          xValueMapper: (data, _) => data.month,
          yValueMapper: (data, _) => data.myDebts,
          name: 'Mes dettes',
          color: AppColors.red,
          width: 4,
          splineType: SplineType.natural,
          markerSettings: const MarkerSettings(isVisible: true),
          animationDuration: 1500,
        ),

        // 🔵 Courbe 3 : Remboursements hebdo
        SplineSeries<_ChartDataPoint, DateTime>(
          dataSource: weeklyRepaymentData,
          xValueMapper: (data, _) => data.month,
          yValueMapper: (data, _) => data.owedToMe, // utilisé pour le total hebdo
          name: 'Remboursements (hebdo)',
          color: Colors.blueAccent,
          width: 3,
          splineType: SplineType.natural,
          markerSettings: const MarkerSettings(isVisible: true),
          animationDuration: 1500,
        ),
      ],
      tooltipBehavior: TooltipBehavior(enable: true),
      legend: const Legend(isVisible: true),
    );
  }
}

class _ChartDataPoint {
  _ChartDataPoint(this.month, this.owedToMe, this.myDebts);
  final DateTime month;
  double owedToMe;
  double myDebts;
}
