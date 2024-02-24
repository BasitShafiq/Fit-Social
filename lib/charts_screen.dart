import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class FitnessProgressChart extends StatelessWidget {
  final List<ChartData> chartData = [
    ChartData(1, 200),
    ChartData(2, 250),
    ChartData(3, 300),
    ChartData(4, 280),
    ChartData(5, 320),
    ChartData(6, 350),
    ChartData(7, 330),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fitness Progress Chart'),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: SfCartesianChart(
            primaryXAxis: NumericAxis(title: AxisTitle(text: 'Days')),
            primaryYAxis: NumericAxis(title: AxisTitle(text: 'Calories')),
            series: <CartesianSeries>[
              LineSeries<ChartData, int>(
                dataSource: chartData,
                xValueMapper: (ChartData data, _) => data.day,
                yValueMapper: (ChartData data, _) => data.calories,
                name: 'Calories',
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ChartData {
  final int day;
  final int calories;

  ChartData(this.day, this.calories);
}
