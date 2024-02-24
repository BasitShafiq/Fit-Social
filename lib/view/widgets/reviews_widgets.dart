import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fitsocial/controller/functionsController/dialogsAndLoadingController.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

void showModal(BuildContext context) {
  double rating = 0;
  String reviewText = '';

  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Write a Review',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.0),
              RatingBar.builder(
                initialRating: rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 30.0,
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (newRating) {
                  rating = newRating;
                },
              ),
              SizedBox(height: 16.0),
              TextField(
                onChanged: (value) {
                  reviewText = value;
                },
                decoration: InputDecoration(
                  hintText: 'Enter your review',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                focusNode: FocusNode(),
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      saveReview(context, rating, reviewText);
                    },
                    child: Text('Submit'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> saveReview(
    BuildContext context, double rating, String reviewText) async {
  DialogsAndLoadingController dialogsAndLoadingController =
      Get.put(DialogsAndLoadingController());
  dialogsAndLoadingController.showLoading();

  String? userId = FirebaseAuth.instance.currentUser?.uid;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  firestore.collection('reviews').add({
    'fromId': userId,
    'rating': rating,
    'feedback': reviewText,
    'toId': '123',
    'timestamp': Timestamp.now(),
  }).then((value) {
    Get.back();
    Get.back();
  }).catchError((error) {
    print('Error adding review: $error');
  });
}
