import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitsocial/controller/functionsController.dart';
import 'package:fitsocial/config/Colors.dart';
import 'package:fitsocial/config/text.dart';
import 'package:fitsocial/view/screens/homepage/componenets/avatar.dart';
import '../../../controller/userController/userController.dart';
import '../../../config/workouts lists/workouts Lists.dart';
import '../../../helpers/string_methods.dart';
import '../homepage/componenets/tabBarViewSections.dart';
import '../user profile/userProfil.dart';
import 'components/mainWorkoutCard.dart';
import 'package:http/http.dart' as http;

class AllWorkoutsPage extends StatefulWidget {
  AllWorkoutsPage({Key? key, this.dataList}) : super(key: key);
  List? dataList;

  @override
  State<AllWorkoutsPage> createState() => _AllWorkoutsPageState();
}

class _AllWorkoutsPageState extends State<AllWorkoutsPage> {
  final FunctionsController controller = Get.put(FunctionsController());

  final userInformationController = Get.put(UserInformationController());

  @override
  void initState() {
    super.initState();
    fetchWorkouts();
  }

  Future<void> fetchWorkouts() async {
    try {
      var response = await http.get(
        Uri.parse('https://work-out-api1.p.rapidapi.com/search?Muscles=biceps'),
        headers: {
          'X-RapidAPI-Key':
              '0a0b5f1998msh051b82421519beap1edbcbjsn4ee6765b5c1c',
          'X-RapidAPI-Host': 'work-out-api1.p.rapidapi.com',
        },
      );
      if (response.statusCode == 200) {
        setState(() {
          print(response.body);
          // workouts = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to fetch workouts: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
      throw Exception('Failed to fetch workouts: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: DelayedDisplay(
          slidingBeginOffset: const Offset(0.0, 0.1),
          delay: Duration(milliseconds: delay),
          child: AppBar(
            actions: [
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Avatar(
                    onProfileImgTap: () {
                      Get.to(() => const UserProfile());
                    },
                    networkImage:
                        userInformationController.userProfileImg.value,
                  ),
                ),
              ),
            ],
            elevation: 0,
            toolbarHeight: 80,
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
            backgroundColor: AppColors.darkBlue,
            title: Text(
              Get.arguments[0].toString(),
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
          child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            DelayedDisplay(
              delay: Duration(milliseconds: delay + 100),
              slidingBeginOffset: const Offset(0.0, 0.1),
              child: MainWorkoutCard(
                isFavortite: false,
                sectionTitle: AppTexts.workoutOfDay,
                description: AppTexts.basedOnReviews,
                imagePath: controller.filterWorkoutWith(
                    Get.arguments[1], "isWorkoutOfDay", "true")["imagePath"],
                cardTitle: controller.filterWorkoutWith(
                    Get.arguments[1], "isWorkoutOfDay", "true")["workOutTitle"],
                filledStars: controller.filterWorkoutWith(
                    Get.arguments[1], "isWorkoutOfDay", "true")["rating"],
                timeLeft: controller.filterWorkoutWith(Get.arguments[1],
                    "isWorkoutOfDay", "true")["timeLeftInHour"],
                comments: controller.filterWorkoutWith(
                    Get.arguments[1], "isWorkoutOfDay", "true")["comments"],
                durationInMinutes: controller.filterWorkoutWith(
                    Get.arguments[1],
                    "isWorkoutOfDay",
                    "true")["durationInMinutes"],
                hasFreeTrial: controller.filterWorkoutWith(
                    Get.arguments[1], "isWorkoutOfDay", "true")["hasFreeTrial"],
                movesNumber: controller.filterWorkoutWith(
                    Get.arguments[1], "isWorkoutOfDay", "true")["movesNumber"],
                priceInDollars: controller.filterWorkoutWith(Get.arguments[1],
                    "isWorkoutOfDay", "true")["priceInDollars"],
                setsNumber: controller.filterWorkoutWith(
                    Get.arguments[1], "isWorkoutOfDay", "true")["setsNumber"],
                reviews: controller.filterWorkoutWith(
                    Get.arguments[1], "isWorkoutOfDay", "true")["reviews"],
                intensity: controller.filterWorkoutWith(
                    Get.arguments[1], "isWorkoutOfDay", "true")["intensity"],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            DelayedDisplay(
              slidingBeginOffset: const Offset(0.0, 0.1),
              delay: Duration(milliseconds: delay + 300),
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: WorkoutsList().fetchWorkouts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final dataList = snapshot.data ?? [];
                    return TabBarViewSection(
                      itemsToShow: dataList.length,
                      title: capitalize(AppTexts.allWorkouts),
                      dataList: dataList,
                      hasSeeAllButton: false,
                    );
                  }
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      )),
    );
  }
}
