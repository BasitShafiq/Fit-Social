import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitsocial/charts_screen.dart';
import 'package:fitsocial/steps_count.dart';
import 'package:fitsocial/view/screens/user%20profile/certificate.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:fitsocial/controller/functionsController.dart';
import 'package:fitsocial/config/Colors.dart';
import 'package:fitsocial/config/text.dart';
import 'package:fitsocial/view/widgets/general_widgets/button.dart';
import '../../../controller/authControllers/signOutController.dart';
import '../../../controller/userController/userController.dart';
import '../../../helpers/string_methods.dart';
import 'components/appBar.dart';
import 'components/stat.dart';
import 'customizeProfilePage.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({Key? key}) : super(key: key);

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final FunctionsController controller = Get.put(FunctionsController());
  final UserInformationController userInformationController = Get.find();
  final SignOutController signOutController = Get.put(SignOutController());
  Color? scfldColor = AppColors.darkBlue;
  Color? overlayedColor = const Color.fromARGB(255, 22, 23, 43);
  Future<Map<String, dynamic>> getUserData(String userId) async {
    try {
      // Get the document snapshot corresponding to the user ID
      final DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('aboutUsers') // Replace 'users' with your collection name
          .doc(userId)
          .get();

      // Check if the document exists
      if (userSnapshot.exists) {
        // Extract user data from the snapshot
        final userData = userSnapshot.data() as Map<String, dynamic>;
        print(userData);
        return userData;
      } else {
        // Document does not exist
        print('User document does not exist');
        return {}; // Return an empty map
      }
    } catch (error) {
      // Handle errors
      print('Error fetching user data: $error');
      return {}; // Return an empty map
    }
  }

  Map<String, dynamic> data = {};

  void setdata() async {
    data = await getUserData(FirebaseAuth.instance.currentUser!.uid);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    setdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scfldColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: DelayedDisplay(
          delay: Duration(milliseconds: delay),
          child: ProfileAppBar(),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 1),
            Column(
              children: [
                DelayedDisplay(
                  delay: Duration(milliseconds: delay + 100),
                  child: SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: Obx(
                        (() => Image(
                              image: NetworkImage(userInformationController
                                  .userProfileImg.value),
                              fit: BoxFit.cover,
                              frameBuilder: (_, image, loadingBuilder, __) {
                                if (loadingBuilder == null) {
                                  return const SizedBox(
                                    height: 300,
                                    child: Center(
                                      child: SpinKitSpinningLines(
                                        color: Color(0xff40D876),
                                        duration: Duration(seconds: 1),
                                        size: 60,
                                      ),
                                    ),
                                  );
                                }
                                return image;
                              },
                            )),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                DelayedDisplay(
                  delay: Duration(milliseconds: delay + 400),
                  child: Obx(
                    () => DelayedDisplay(
                      child: Text(
                        capitalize(
                          userInformationController.username.value,
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                DelayedDisplay(
                    delay: Duration(milliseconds: delay + 400),
                    child: Obx(() {
                      final followers = Get.find<UserInformationController>()
                          .followers
                          .value
                          .length;

                      final following = Get.find<UserInformationController>()
                          .following
                          .value
                          .length;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Stat(
                            statValue: capitalize("Followers"),
                            statTitle: capitalize(
                              followers.toString(),
                            ),
                          ),
                          Stat(
                            statValue: capitalize("Following"),
                            statTitle: capitalize(
                              following.toString(),
                            ),
                          ),
                        ],
                      );
                    })),
                const SizedBox(
                  height: 40,
                ),
                // Display user's goal
                Obx(() {
                  final userGoal =
                      Get.find<UserInformationController>().goal.value;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      const Center(
                        child: Text(
                          'Goal:',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 5),
                      if (userGoal == "" || userGoal == " ")
                        const Center(
                          child: Text(
                            'No Goal Set',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      if (userGoal != "" || userGoal != " ")
                        Center(
                            child: Chip(
                          label: Text(
                            userGoal,
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor:
                              const Color.fromARGB(255, 33, 163, 37),
                        )),
                    ],
                  );
                }),

                // Display user's activities
                Obx(() {
                  final activities =
                      Get.find<UserInformationController>().fitnessActivities;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      const Center(
                        child: Text(
                          'Activities:',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      if (activities.isEmpty)
                        const Center(
                          child: Text(
                            'No activities added',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      if (activities.isNotEmpty)
                        Center(
                          child: Wrap(
                            spacing: 8,
                            children: activities.map((activity) {
                              return Chip(
                                label: Text(
                                  activity,
                                  style: const TextStyle(color: Colors.white),
                                ),
                                backgroundColor:
                                    const Color.fromARGB(255, 33, 163, 37),
                              );
                            }).toList(),
                          ),
                        ),
                    ],
                  );
                }),

                Container(
                  height: 10,
                ),
              ],
            ),
            const Spacer(
              flex: 2,
            ),
            DelayedDisplay(
              delay: Duration(microseconds: 100),
              child: CustomButton(
                onPressed: () {
                  Get.to(FitnessProgressChart());
                },
                text: capitalize("Analytics"),
                isOutlined: false,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            DelayedDisplay(
              delay: Duration(microseconds: 100),
              child: CustomButton(
                onPressed: () {
                  Get.to(CountSteps());
                },
                text: capitalize("Activity Tracking"),
                isOutlined: false,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            if (data['type'] == "1")
              DelayedDisplay(
                delay: Duration(milliseconds: delay + 500),
                child: CustomButton(
                    text: capitalize(AppTexts.configureSettings),
                    isOutlined: true,
                    onPressed: () {
                      Get.to(() => const CertificatePage(), arguments: [
                        scfldColor,
                        overlayedColor,
                      ]);
                    }),
              ),
            const SizedBox(
              height: 10,
            ),
            DelayedDisplay(
              delay: Duration(milliseconds: delay + 500),
              child: CustomButton(
                  text: capitalize(AppTexts.configureSettings),
                  isOutlined: true,
                  onPressed: () {
                    Get.to(() => CustomProfileSettings(), arguments: [
                      scfldColor,
                      overlayedColor,
                    ]);
                  }),
            ),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}
