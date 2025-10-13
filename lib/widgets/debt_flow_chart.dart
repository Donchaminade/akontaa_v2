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

    // Aggregate data by month and year
    Map<String, _ChartDataPoint> monthlyData = {};

    for (var transaction in allTransactions) {
      final monthYearKey = '${transaction.date.year}-${transaction.date.month.toString().padLeft(2, '0')}';
      final monthStartDate = DateTime(transaction.date.year, transaction.date.month, 1);

      monthlyData.putIfAbsent(monthYearKey, () => _ChartDataPoint(monthStartDate, 0, 0));

      if (transaction.type == TransactionType.debt) {
        final debt = transaction.item as Debt;
        if (debt.isOwedToMe) {
          monthlyData[monthYearKey]!.owedToMe += debt.totalAmount;
        } else {
          monthlyData[monthYearKey]!.myDebts += debt.totalAmount;
        }
      } else if (transaction.type == TransactionType.repayment) {
        final repayment = transaction.item as Repayment;
        final debt = debtProvider.debts.firstWhere((d) => d.repayments.any((r) => r.id == repayment.id));
        if (debt.isOwedToMe) {
          monthlyData[monthYearKey]!.owedToMe -= repayment.amount;
        } else {
          monthlyData[monthYearKey]!.myDebts -= repayment.amount;
        }
      }
    }

    // Convert map to a sorted list of _ChartDataPoint
    List<_ChartDataPoint> chartData = monthlyData.values.toList();
    chartData.sort((a, b) => a.month.compareTo(b.month));

    if (chartData.isEmpty) {
      return const Center(child: Text('Aucune donnée de dette ou de remboursement pour le graphique.'));
    }

    return SfCartesianChart(
      primaryXAxis: DateTimeAxis(
        dateFormat: DateFormat.MMM(),
        intervalType: DateTimeIntervalType.months,
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
        numberFormat: NumberFormat.compact(),
        majorGridLines: const MajorGridLines(width: 0),
      ),
      series: <CartesianSeries<dynamic, DateTime>>[
        LineSeries<_ChartDataPoint, DateTime>(
          dataSource: chartData,
          xValueMapper: (_ChartDataPoint data, _) => data.month,
          yValueMapper: (_ChartDataPoint data, _) => data.owedToMe,
          name: 'On me doit',
          color: AppColors.green,
          markerSettings: const MarkerSettings(isVisible: true),
        ),
        LineSeries<_ChartDataPoint, DateTime>(
          dataSource: chartData,
          xValueMapper: (_ChartDataPoint data, _) => data.month,
          yValueMapper: (_ChartDataPoint data, _) => data.myDebts,
          name: 'Mes dettes',
          color: AppColors.red,
          markerSettings: const MarkerSettings(isVisible: true),
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
