import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitsocial/controller/functionsController/dialogsAndLoadingController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../../../config/Colors.dart';

class FoodSearchScreen extends StatefulWidget {
  @override
  _FoodSearchScreenState createState() => _FoodSearchScreenState();
}

class _FoodSearchScreenState extends State<FoodSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _itemId = '';
  String _calories = '';
  String _totalFat = '';
  String _carbohydrates = '';
  String _protein = '';
  String _sodium = '';

  Future<void> _searchFood(String query) async {
    var url =
        'https://trackapi.nutritionix.com/v2/search/instant/?query=$query';
    var headers = {
      'Content-Type': 'application/json',
      'x-app-id': '5da9c1f9',
      'x-app-key': 'd74e420b370b00a41afde57311af512f',
    };

    var response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      List<dynamic> brandedResults = jsonData['branded'];
      List<dynamic> commonResults = jsonData['common'];

      // Assuming you want to use the first item's nix_item_id
      if (brandedResults.isNotEmpty) {
        _itemId = brandedResults[0]['nix_item_id'];
      } else if (commonResults.isNotEmpty) {
        _itemId = commonResults[0]['nix_item_id'];
      } else {
        _itemId = ''; // No results found
      }

      if (_itemId.isNotEmpty) {
        await _fetchFoodDetails(_itemId);
      } else {
        setState(() {
          _calories = 'No item found';
        });
      }
    } else {
      setState(() {
        _calories = 'Error fetching data';
      });
    }
  }

  Future<void> _fetchFoodDetails(String itemId) async {
    DialogsAndLoadingController dialogsAndLoadingController =
        Get.put(DialogsAndLoadingController());
    dialogsAndLoadingController.showLoading();
    var url =
        'https://trackapi.nutritionix.com/v2/search/item/?nix_item_id=$itemId';
    var headers = {
      'Content-Type': 'application/json',
      'x-app-id': '5da9c1f9',
      'x-app-key': 'd74e420b370b00a41afde57311af512f',
    };

    var response = await http.get(Uri.parse(url), headers: headers);
    print(response);
    if (response.statusCode == 200) {
      print(response.body);
      Map<String, dynamic> json = jsonDecode(response.body);

      Map<String, dynamic> foodData = json['foods'][0];
      double calories = foodData['nf_calories'].toDouble();
      double totalFat = foodData['nf_total_fat'].toDouble();
      double carbohydrates = foodData['nf_total_carbohydrate'].toDouble();
      double protein = foodData['nf_protein'].toDouble();
      double sodium = foodData['nf_sodium'].toDouble();
      setState(() {
        _calories = calories.toString();
        _totalFat = totalFat.toString();
        _carbohydrates = carbohydrates.toString();
        _protein = protein.toString();
        _sodium = sodium.toString();
      });
      await saveFoodDetails(calories, totalFat, carbohydrates, protein, sodium)
          .then((value) => Get.back());
    } else {
      setState(() {
        _calories = 'Error fetching data';
      });
    }
  }

  Future<void> saveFoodDetails(
    double calories,
    double totalFat,
    double carbohydrates,
    double protein,
    double sodium,
  ) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

    String? userId = FirebaseAuth.instance.currentUser?.uid;
    CollectionReference foodDetails =
        FirebaseFirestore.instance.collection('nutritionTracking');

    await foodDetails.add({
      'date': formattedDate,
      'calories': calories,
      'totalFat': totalFat,
      'carbohydrates': carbohydrates,
      'protein': protein,
      'sodium': sodium,
      'userId': userId,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff131429),
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
          'Nutrition Tracking',
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: TextField(
                maxLines: 3,
                controller: _searchController,
                decoration: InputDecoration(labelText: 'Enter Food'),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {
                _searchFood(_searchController.text);
              },
              child: Text('Add Food'),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                "Your Food Nutritions",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              'Calories:        $_calories',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            Text(
              'Total Fat:         $_totalFat',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            Text(
              'Carbohydrates:         $_carbohydrates',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            Text(
              'Protein:         $_protein',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            Text(
              'Sodium:        $_sodium',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
