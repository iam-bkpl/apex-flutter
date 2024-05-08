import 'package:flutter/material.dart';
import 'package:wallet_app/model/daily_total.dart';

class BarChartWidget extends StatelessWidget {
  final List<DailyTotal> dailyTotals;

  const BarChartWidget({super.key, required this.dailyTotals});

  @override
  Widget build(BuildContext context) {

    print("BarChartWidget(): length is ${dailyTotals.length}");

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: dailyTotals.isNotEmpty ? Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Transaction Summary',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20.0),
          Expanded(
            child: ListView.builder(
              itemCount: dailyTotals.length,
              itemBuilder: (context, index) {
                final dailyTotal = dailyTotals[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Text(
                        dailyTotal.date,
                        style: const TextStyle(fontSize: 16.0),
                      ),
                      const SizedBox(width: 10.0),
                      Container(
                        height: 30.0,
                        width: dailyTotal.totalIncome/10,
                        color: Colors.red,
                      ),
                      const SizedBox(width: 5.0),
                      Container(
                        height: 30.0,
                        width: dailyTotal.totalExpense/10,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 5.0),
                      Icon(
                          (dailyTotal.totalExpense - dailyTotal.totalIncome > 0) ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                        color: (dailyTotal.totalExpense - dailyTotal.totalIncome > 0) ? Colors.green : Colors.red,
                      ),
                      Text(
                        "${dailyTotal.totalExpense - dailyTotal.totalIncome}",
                        style: const TextStyle(fontSize: 16.0),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ) : const Text ('No Transactions', textAlign: TextAlign.center,),
    );
  }
}
