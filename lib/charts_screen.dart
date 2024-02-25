import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'config/Colors.dart';

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

  // Dummy counts for live sessions and total followers
  final int liveSessionsCount = 10;
  final int totalFollowersCount = 1000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          ),
        ],
        elevation: 0,
        toolbarHeight: 80,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: AppColors.darkBlue,
        title: Text(
          'Analytics Tracking',
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: Color(0xff131429),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SfCartesianChart(
                primaryXAxis: NumericAxis(
                  title: AxisTitle(
                    text: 'Days',
                    textStyle: TextStyle(color: Colors.white),
                  ),
                ),
                primaryYAxis: NumericAxis(
                  title: AxisTitle(
                    text: 'Calories',
                    textStyle: TextStyle(color: Colors.white),
                  ),
                ),
                series: <CartesianSeries>[
                  LineSeries<ChartData, int>(
                    dataSource: chartData,
                    xValueMapper: (ChartData data, _) => data.day,
                    yValueMapper: (ChartData data, _) => data.calories,
                    name: 'Calories',
                  )
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        'Live Sessions',
                        style: TextStyle(
                          color: Color(0xff40D876),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        liveSessionsCount.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        'Total Followers',
                        style: TextStyle(
                          color: Color(0xff40D876),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        totalFollowersCount.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 24),
                      ),
                    ],
                  ),
                ],
              ),
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
