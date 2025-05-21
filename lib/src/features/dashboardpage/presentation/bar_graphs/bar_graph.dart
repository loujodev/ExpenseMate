import 'package:expense_mate/src/features/dashboardpage/dashboard_page.dart';
import 'package:expense_mate/src/shared/extension/custom_theme_extension.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// BarGraph is a widget used on the [DashboardPage]
///
/// The graph is used to display the distribution of expenses over a year.
///
/// Parameters:
/// -[monthlyData]: a map with the month as key and the sum of expenses as value
/// -[maxValue]: a height the bars on the chart should not exceed (=maxValue inside the map *1.05)
///
class BarGraph extends StatefulWidget {
  final Map<int, double> monthlyData;
  final double maxValue;

  const BarGraph({
    super.key,
    required this.monthlyData,
    required this.maxValue,
  });

  @override
  State<BarGraph> createState() => _BarGraphState();
}

class _BarGraphState extends State<BarGraph> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<CustomThemeColorsExtension>();

    // Sortiere die Map nach den Keys (Monaten)
    final sortedMonthlyData = Map.fromEntries(
      widget.monthlyData.entries.toList()
        ..sort((a, b) => a.key.compareTo(b.key)),
    );

    return SizedBox(
      width: 12 * 40, // Platz für 12 Monate
      child: BarChart(
        BarChartData(
          minY: 0,
          maxY: widget.maxValue,
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            show: true,
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final month = value.toInt();
                  return Text(
                    month >= 1 && month <= 12 ? month.toString() : '',
                    style: TextStyle(color: theme?.textColor),
                  );
                },
                reservedSize: 50,
              ),
            ),
          ),
          barGroups:
              sortedMonthlyData.entries.map((index) {
                return BarChartGroupData(
                  x: index.key,
                  barRods: [
                    BarChartRodData(
                      toY: index.value,
                      width: 18,
                      color: theme?.purpleThemeColor,
                      borderRadius: BorderRadius.circular(4),
                      backDrawRodData: BackgroundBarChartRodData(
                        show: true,
                        color: theme?.secondaryBackgroundColor,
                        toY: widget.maxValue,
                      ),
                    ),
                  ],
                );
              }).toList(),
        ),
      ),
    );
  }
}
