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

    if (allTransactions.isEmpty) {
      return const Center(child: Text('Aucune donnée de dette ou de remboursement pour le graphique.'));
    }

    // Determine the date range for the chart
    final firstTransactionDate = allTransactions.last.date; // allTransactions is sorted newest first
    final lastTransactionDate = allTransactions.first.date;

    DateTime currentMonth = DateTime(firstTransactionDate.year, firstTransactionDate.month, 1);
    double cumulativeOwedToMe = 0;
    double cumulativeMyDebts = 0;

    while (currentMonth.isBefore(lastTransactionDate) || currentMonth.isAtSameMomentAs(lastTransactionDate)) {
      final monthYearKey = '${currentMonth.year}-${currentMonth.month.toString().padLeft(2, '0')}';

      double monthOwedToMeChange = 0;
      double monthMyDebtsChange = 0;

      // Calculate changes for the current month from actual transactions
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
          final debt = debtProvider.debts.firstWhere((d) => d.repayments.any((r) => r.id == repayment.id));
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

      currentMonth = DateTime(currentMonth.year, currentMonth.month + 1, 1); // Move to next month
    }

    if (chartData.isEmpty) {
      return const Center(child: Text('Aucune donnée de dette ou de remboursement pour le graphique.'));
    }

    // return SfCartesianChart(
    //   primaryXAxis: DateTimeAxis(
    //     dateFormat: DateFormat.MMM(),
    //     intervalType: DateTimeIntervalType.months,
    //     majorGridLines: const MajorGridLines(width: 0),
    //   ),
    //   primaryYAxis: NumericAxis(
    //     numberFormat: NumberFormat.compact(),
    //     majorGridLines: const MajorGridLines(width: 0),
    //   ),
    //   series: <CartesianSeries<dynamic, DateTime>>[
    //     SplineSeries<_ChartDataPoint, DateTime>(
    //       dataSource: chartData,
    //       xValueMapper: (_ChartDataPoint data, _) => data.month,
    //       yValueMapper: (_ChartDataPoint data, _) => data.owedToMe,
    //       name: 'On me doit',
    //       color: AppColors.green,
    //       markerSettings: const MarkerSettings(isVisible: true),
    //       splineType: SplineType.cardinal,
    //     ),
      
    //     SplineSeries<_ChartDataPoint, DateTime>(
    //       dataSource: chartData,
    //       xValueMapper: (_ChartDataPoint data, _) => data.month,
    //       yValueMapper: (_ChartDataPoint data, _) => data.myDebts,
    //       name: 'Mes dettes',
    //       color: AppColors.red,
    //       markerSettings: const MarkerSettings(isVisible: true),
    //       splineType: SplineType.cardinal,
    //     ),
    //   ],
    //   tooltipBehavior: TooltipBehavior(enable: true),
    //   legend: const Legend(isVisible: true),
    // );

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
  series: <CartesianSeries>[
    // 🌊 Ligne 1 : On me doit
    SplineAreaSeries<_ChartDataPoint, DateTime>(
      dataSource: chartData,
      xValueMapper: (data, _) => data.month,
      yValueMapper: (data, _) => data.owedToMe,
      name: 'On me doit',
      gradient: LinearGradient(
        colors: [AppColors.green.withOpacity(0.4), Colors.transparent],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      borderColor: AppColors.green,
      borderWidth: 3,
      splineType: SplineType.cardinal,
      animationDuration: 1500,
    ),

    // 🔴 Ligne 2 : Mes dettes
    SplineAreaSeries<_ChartDataPoint, DateTime>(
      dataSource: chartData,
      xValueMapper: (data, _) => data.month,
      yValueMapper: (data, _) => data.myDebts,
      name: 'Mes dettes',
      gradient: LinearGradient(
        colors: [AppColors.red.withOpacity(0.4), Colors.transparent],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      borderColor: AppColors.red,
      borderWidth: 3,
      splineType: SplineType.cardinal,
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
