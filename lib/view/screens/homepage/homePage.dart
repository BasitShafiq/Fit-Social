import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitsocial/view/screens/feed/composeTweet.dart';
import 'package:fitsocial/view/screens/feed/event_feed.dart';
import 'package:fitsocial/view/screens/feed/groups.dart';
import 'package:fitsocial/view/screens/feed/homeFeeds.dart';
import 'package:fitsocial/view/screens/feed/latest_chat.dart';
import 'package:fitsocial/view/screens/feed/search.dart';
import 'package:fitsocial/view/screens/homepage/nav_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/functionsController.dart';
import '../../../controller/tabs controllers/workOutTabController.dart';
import '../../../config/images sources.dart';

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
          FeedPage(),
          SearchScreen(),
          EventFeedPage(),
          LatestChatsPage(
            userId: FirebaseAuth.instance.currentUser!.uid,
          ),
        ],
      ),
    );
  }
}
