import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wallet_app/model/transaction.dart';
import 'package:wallet_app/provider/transaction_provider.dart';

class WalletBarChart2 extends StatefulWidget {
  WalletBarChart2(this.groupDatedTransactionList, {super.key});
  final Color leftBarColor = const Color.fromRGBO(157, 195, 132, 1);
  final Color rightBarColor = const Color.fromRGBO(209, 109, 106, 1);
  final Color avgColor =
      Colors.blue.shade300;

  List<List<WalletTransaction>> groupDatedTransactionList = [];

  @override
  State<StatefulWidget> createState() => WalletBarChart2State();
}

class WalletBarChart2State extends State<WalletBarChart2> {
  final double width = 10;

  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;
  late List<double> maxMedVal;

  int touchedGroupIndex = -1;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    List<String> dailyTotal = [];
    final List<BarChartGroupData> items = [];


    int count = 0;
    for (List<WalletTransaction> transactionList in widget.groupDatedTransactionList) {
      dailyTotal = context.watch<TransactionProvider>().calculateDailyTotals(transactionList);
      items.add(makeGroupData(count, dailyTotal[0], double.parse(dailyTotal[1]) ?? 0, double.parse(dailyTotal[2]) ?? 0));
      count++;
    }

    maxMedVal = calculateMaxAndMedian(widget.groupDatedTransactionList);

    rawBarGroups = items;

    showingBarGroups = rawBarGroups;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Transactions in last 7 days',
              style: TextStyle(color: Colors.purple, fontSize: 22),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 38,
            ),
            Expanded(
              child: BarChart(
                BarChartData(
                  maxY: 20,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: ((group) {
                        return Colors.grey;
                      }),
                      getTooltipItem: (a, b, c, d) => null,
                    ),
                    touchCallback: (FlTouchEvent event, response) {
                      if (response == null || response.spot == null) {
                        setState(() {
                          touchedGroupIndex = -1;
                          showingBarGroups = List.of(rawBarGroups);
                        });
                        return;
                      }

                      touchedGroupIndex = response.spot!.touchedBarGroupIndex;

                      setState(() {
                        if (!event.isInterestedForInteractions) {
                          touchedGroupIndex = -1;
                          showingBarGroups = List.of(rawBarGroups);
                          return;
                        }
                        showingBarGroups = List.of(rawBarGroups);
                        if (touchedGroupIndex != -1) {
                          var sum = 0.0;
                          for (final rod
                          in showingBarGroups[touchedGroupIndex].barRods) {
                            sum += rod.toY;
                          }
                          final avg = sum /
                              showingBarGroups[touchedGroupIndex]
                                  .barRods
                                  .length;

                          showingBarGroups[touchedGroupIndex] =
                              showingBarGroups[touchedGroupIndex].copyWith(
                                barRods: showingBarGroups[touchedGroupIndex]
                                    .barRods
                                    .map((rod) {
                                  return rod.copyWith(
                                      toY: avg, color: widget.avgColor);
                                }).toList(),
                              );
                        }
                      });
                    },
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: bottomTitles,
                        reservedSize: 42,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        interval: 1,
                        getTitlesWidget: leftTitles,
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  barGroups: showingBarGroups,
                  gridData: const FlGridData(show: false),
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
          ],
        ),
      ),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    String text;

    if (value == 0) {
      text = '0';
    } else if (value == maxMedVal[1]) {
      text = '${maxMedVal[1]}';
    } else if (value == maxMedVal[0]) {
      text = '${maxMedVal[0]}';
    } else {
      return Container();
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Text(text, style: style),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final titles = <String>['Mn', 'Te', 'Wd', 'Tu', 'Fr', 'St', 'Su'];

    final Widget text = Text(
      titles[value.toInt()],
      style: const TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16, //margin top
      child: text,
    );
  }

  BarChartGroupData makeGroupData(int count, String x, double y1, double y2) {
    return BarChartGroupData(
      barsSpace: 4,
      barRods: [
        BarChartRodData(
          toY: y1,
          color: widget.leftBarColor,
          width: width,
        ),
        BarChartRodData(
          toY: y2,
          color: widget.rightBarColor,
          width: width,
        ),
      ], x: count,
    );
  }

  List<double> calculateMaxAndMedian(List<List<WalletTransaction>> lists) {
    double maxSum = double.negativeInfinity;
    double medianSum = 0;

    // Iterate over each list of WalletTransaction objects
    for (List<WalletTransaction> transactionsList in lists) {
      // Calculate the sum of transaction amounts
      double sum = transactionsList.fold(0, (previous, transaction) => previous + transaction.transactionAmount);

      // Update the maximum sum if needed
      maxSum = sum > maxSum ? sum : maxSum;

      // Add the sum to calculate the median later
      medianSum += sum;
    }

    // Calculate the median
    medianSum /= lists.length;

    return [maxSum, medianSum];
  }

}