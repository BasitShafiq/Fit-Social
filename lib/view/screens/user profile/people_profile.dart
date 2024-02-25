import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitsocial/view/screens/feed/chats.dart';
import 'package:fitsocial/view/widgets/reviews_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fitsocial/config/Colors.dart';
import 'package:fitsocial/config/text.dart';

import 'package:fitsocial/helpers/string_methods.dart';

class PeopleProfile extends StatelessWidget {
  final String username;
  final String userProfileImg;
  final String id;
  final String goal;
  final List<String> fitnessActivities;

  const PeopleProfile({
    Key? key,
    required this.username,
    required this.userProfileImg,
    required this.goal,
    required this.id,
    required this.fitnessActivities,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: DelayedDisplay(
          delay: const Duration(milliseconds: 100),
          child: AppBar(
            title: Text(
              capitalize(AppTexts.profile),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),
            ),
            toolbarHeight: 80,
            iconTheme: const IconThemeData(color: Colors.white),
            actions: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    foregroundColor: AppColors.darkBlue, elevation: 0),
                label: Text(
                  capitalize("Message"),
                  style:
                      const TextStyle(color: Color.fromARGB(255, 33, 105, 36)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatPage(
                        userId: FirebaseAuth.instance.currentUser!.uid,
                        name: username,
                        url: userProfileImg,
                        otherUserId: id,
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.chat_rounded,
                  color: Color.fromARGB(255, 33, 105, 36),
                ),
              )
            ],
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
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
                  delay: const Duration(milliseconds: 1 + 100),
                  child: SizedBox(
                    width: 120,
                    height: 120,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: Image(
                        image: NetworkImage(userProfileImg),
                        fit: BoxFit.cover,
                        frameBuilder: (_, image, loadingBuilder, __) {
                          if (loadingBuilder == null) {
                            return const SizedBox(
                              height: 300,
                              child: Center(
                                child: SpinKitSpinningLines(
                                  color: const Color(0xff40D876),
                                  duration: Duration(seconds: 1),
                                  size: 60,
                                ),
                              ),
                            );
                          }
                          return image;
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                DelayedDisplay(
                  delay: const Duration(milliseconds: 1 + 400),
                  child: Text(
                    capitalize(username),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                DelayedDisplay(
                  delay: const Duration(milliseconds: 1 + 300),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      "this take the place of description, it's not implemented yet like the row below, it's desactivated for now",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white.withOpacity(.8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Column(
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
                    if (goal.isEmpty || goal == " ")
                      const Center(
                        child: Text(
                          'No Goal Set',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    if (goal.isNotEmpty)
                      Center(
                          child: Chip(
                        label: Text(
                          goal,
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: const Color.fromARGB(255, 33, 163, 37),
                      )),
                  ],
                ),
                Column(
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
                    const SizedBox(height: 5),
                    if (fitnessActivities.isEmpty)
                      const Center(
                        child: Text(
                          'No activities added',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    if (fitnessActivities.isNotEmpty)
                      Center(
                        child: Wrap(
                          spacing: 8,
                          children: fitnessActivities.map((activity) {
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
                ),
              ],
            ),
            const Spacer(
              flex: 2,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to the tweet composition page
                  showModal(context);
                },
                child: const Text('Leave a review'),
              ),
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
