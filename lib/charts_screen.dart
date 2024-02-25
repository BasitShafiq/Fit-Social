import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'config/Colors.dart';

class FitnessProgressChart extends StatefulWidget {
  @override
  _FitnessProgressChartState createState() => _FitnessProgressChartState();
}

class _FitnessProgressChartState extends State<FitnessProgressChart> {
  late List<ChartData> chartData = [];

  @override
  void initState() {
    super.initState();
    fetchChartData();
  }

  Future<List<ChartData>> fetchChartData() async {
    List<ChartData> chartData = [];
    String? userId = await FirebaseAuth.instance.currentUser?.uid;
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('nutritionTracking')
        .where('userId', isEqualTo: userId)
        .get();

    querySnapshot.docs
        .forEach((DocumentSnapshot<Map<String, dynamic>> document) {
      String dateString = document['date'];
      List<String> dateParts = dateString.split('-');
      int day = int.parse(dateParts[2]);

      double calories = document['calories'].toDouble();

      ChartData dataPoint = ChartData(day, calories);
      chartData.add(dataPoint);
    });
    setState(() {
      this.chartData = chartData;
    });
    return chartData;
  }

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
  final double calories;

  ChartData(this.day, this.calories);
}
