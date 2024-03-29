import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:fitsocial/steps_count.dart';
import 'package:fitsocial/view/screens/feed/chats.dart';
import 'package:fitsocial/view/screens/feed/composeTweet.dart';
import 'package:fitsocial/view/screens/feed/groups.dart';
import 'package:fitsocial/view/screens/feed/homeFeeds.dart';
import 'package:fitsocial/view/screens/feed/search.dart';
import 'package:fitsocial/view/screens/live%20workouts/group_calling.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitsocial/config/Colors.dart';
import 'package:fitsocial/config/text.dart';
import 'package:fitsocial/config/workouts%20lists/workouts%20Lists.dart';
import 'package:fitsocial/view/screens/user%20profile/userProfil.dart';
import '../../../charts_screen.dart';
import '../../../controller/functionsController.dart';
import '../../../controller/tabs controllers/workOutTabController.dart';
import '../../../controller/userController/userController.dart';
import '../../../config/images sources.dart';
import '../../../helpers/string_methods.dart';
import '../../widgets/general_widgets/screen_background_image.dart';
import '../../widgets/reviews_widgets.dart';
import 'componenets/HomePageSearchBar.dart';
import 'componenets/ItemsSwitchTiles.dart';
import 'componenets/find_your_workout.dart';
import 'componenets/playButton.dart';
import 'componenets/tabBarViewSections.dart';
import 'componenets/usernameAndProfile.dart';

class NavScreen extends StatefulWidget {
  NavScreen({
    Key? key,
  }) : super(key: key);

  final String bgImg = ImgSrc().randomFromAssetsList();
  @override
  State<NavScreen> createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  final FunctionsController controller = Get.put(FunctionsController());

  final UserInformationController userInformationController =
      Get.put(UserInformationController());

  final CustomTabBarController _tabx = Get.put(CustomTabBarController());

  int _bottomNavIndex = 0;
  List<IconData> iconList = [
    Icons.home,
    Icons.search,
    Icons.groups,
    Icons.message,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        BackgroundImage(
          backgroundImage: widget.bgImg,
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              stops: const [0.45, 1],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                AppColors.darkBlue,
                AppColors.darkBlue.withOpacity(0.05),
              ],
            ),
          ),
          width: double.infinity,
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height,
                maxWidth: MediaQuery.of(context).size.width,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Obx(
                      () => ProfileAndUsername(
                        onProfileImgTap: () {
                          Get.to(() => const UserProfile());
                        },
                        username: capitalize(
                          userInformationController.username.value,
                        ),
                        profileImg:
                            userInformationController.userProfileImg.value,
                      ),
                    ),
                    const SizedBox(
                      height: 55,
                    ),
                    DelayedDisplay(
                      delay: Duration(milliseconds: delay + 100),
                      child: PlayButton(),
                    ),
                    const SizedBox(
                      height: 55,
                    ),
                    DelayedDisplay(
                      delay: Duration(milliseconds: delay + 200),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                // Navigate to the tweet composition page
                                Get.to(GroupCallScreen());
                              },
                              child: const Text('Group call'),
                            ),
                          ),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                // Navigate to the tweet composition page
                                Get.to(CountSteps());
                              },
                              child: const Text('Count'),
                            ),
                          ),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                // Navigate to the tweet composition page
                                Get.to((FeedPage()));
                              },
                              child: const Text('Feeds'),
                            ),
                          ),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                Get.to((FitnessProgressChart()));
                              },
                              child: const Text('Charts'),
                            ),
                          ),
                          Center(
                            child: ElevatedButton(
                              onPressed: () {
                                // Navigate to the tweet composition page
                                showModal(context);
                              },
                              child: const Text('Ratings'),
                            ),
                          ),
                          const FindYourWorkout(),
                          GestureDetector(
                            onTap: (() {
                              controller.showFilterDialog(context);
                            }),
                            child: const Icon(
                              Icons.filter_alt_outlined,
                              color: Colors.white,
                              size: 26,
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      height: 45,
                      child: DelayedDisplay(
                        delay: Duration(milliseconds: delay + 300),
                        child: const HomePageSearchBar(),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      height: 40,
                      child: DelayedDisplay(
                        delay: Duration(
                          milliseconds: delay + 400,
                        ),
                        child: TabBar(
                          labelColor: Colors.white,
                          isScrollable: true,
                          indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Theme.of(context).primaryColor,
                              width: 2,
                            ),
                          ),
                          controller: _tabx.workOutTabController,
                          tabs: _tabx.workOutTabs,
                        ),
                      ),
                    ),
                    Expanded(
                      child: DelayedDisplay(
                        delay: Duration(milliseconds: delay + 600),
                        child: TabBarView(
                          controller: _tabx.workOutTabController,
                          children: [
                            Center(
                              child: TabBarViewSection(
                                title: capitalize(
                                  'All workouts',
                                ),
                                dataList: WorkoutsList.allWorkoutsList,
                              ),
                            ),
                            Center(
                              child: TabBarViewSection(
                                title: capitalize(
                                  'Popular',
                                ),
                                dataList: WorkoutsList.popularWorkoutsList,
                              ),
                            ),
                            Center(
                              child: TabBarViewSection(
                                  title: capitalize(
                                    'hard',
                                  ),
                                  dataList: WorkoutsList.hardWorkoutsList),
                            ),
                            Center(
                              child: TabBarViewSection(
                                  title: capitalize(
                                    'Full body',
                                  ),
                                  dataList: WorkoutsList.fullBodyWorkoutsList),
                            ),
                            Center(
                              child: TabBarViewSection(
                                  title: capitalize(
                                    'Crossfit',
                                  ),
                                  dataList: WorkoutsList.crossFit),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
