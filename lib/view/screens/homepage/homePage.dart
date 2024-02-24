import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:fitsocial/view/screens/feed/chats.dart';
import 'package:fitsocial/view/screens/feed/composeTweet.dart';
import 'package:fitsocial/view/screens/feed/groups.dart';
import 'package:fitsocial/view/screens/feed/homeFeeds.dart';
import 'package:fitsocial/view/screens/feed/search.dart';
import 'package:fitsocial/view/screens/homepage/nav_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitsocial/config/Colors.dart';
import 'package:fitsocial/config/text.dart';
import 'package:fitsocial/config/workouts%20lists/workouts%20Lists.dart';
import 'package:fitsocial/view/screens/user%20profile/userProfil.dart';
import '../../../controller/functionsController.dart';
import '../../../controller/tabs controllers/workOutTabController.dart';
import '../../../controller/userController/userController.dart';
import '../../../config/images sources.dart';
import '../../../helpers/string_methods.dart';
import '../../widgets/general_widgets/screen_background_image.dart';
import '../../widgets/reviews_widgets.dart';
import '../live workouts/group_calling.dart';
import 'componenets/HomePageSearchBar.dart';
import 'componenets/ItemsSwitchTiles.dart';
import 'componenets/find_your_workout.dart';
import 'componenets/playButton.dart';
import 'componenets/tabBarViewSections.dart';
import 'componenets/usernameAndProfile.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key? key,
  }) : super(key: key);

  final String bgImg = ImgSrc().randomFromAssetsList();
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FunctionsController controller = Get.put(FunctionsController());

  final UserInformationController userInformationController =
      Get.put(UserInformationController());

  final CustomTabBarController _tabx = Get.put(CustomTabBarController());

  int _bottomNavIndex = 0;

  List<IconData> iconList = [
    Icons.home,
    Icons.search,
    Icons.people,
    Icons.chat
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        shape: const CircleBorder(),
        child: IconButton(
          onPressed: () {
            Get.to(ComposeMessagePage());
          },
          icon: const Icon(Icons.add),
        ), // Make the FloatingActionButton circular
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: iconList,
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.softEdge,
        onTap: (index) => setState(() => _bottomNavIndex = index),
      ),
      body: IndexedStack(
        index: _bottomNavIndex,
        children: [
          NavScreen(),
          SearchScreen(),
          GroupScreens(),
          ChatScreen(),
        ],
      ),
    );
  }
}
