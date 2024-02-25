import 'package:delayed_display/delayed_display.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitsocial/view/screens/user%20profile/people_profile.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  String _searchQuery = '';

  Future<void> followUser(String userId) async {
    try {
      final currentUserUid = FirebaseAuth.instance.currentUser!.uid;

      // Add the current user to the target user's followers list
      await FirebaseFirestore.instance
          .collection('aboutUsers')
          .doc(userId)
          .update({
        "followers": FieldValue.arrayUnion([currentUserUid]),
      });

      // Add the target user to the current user's following list
      await FirebaseFirestore.instance
          .collection('aboutUsers')
          .doc(currentUserUid)
          .update({
        "following": FieldValue.arrayUnion([userId]),
      });

      setState(() {
        isFollowing = true;
      });

      // Show success message or perform any other action if needed
    } catch (e) {
      print("Error following user: $e");
      // Handle the error as needed
    }
  }

  bool isFollowing = false; // Initially set to false

  Map<String, bool> followStatus =
      {}; // Map to store follow status for each user

// Function to toggle follow/unfollow
  Future<void> toggleFollow(String userId) async {
    if (followStatus.containsKey(userId) && followStatus[userId] == true) {
      await unfollowUser(userId);
    } else {
      await followUser(userId);
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<String>> getFollowings() async {
    try {
      final currentUserUid = _auth.currentUser!.uid;
      final DocumentSnapshot userSnapshot =
          await _firestore.collection('aboutUsers').doc(currentUserUid).get();

      if (userSnapshot.exists) {
        final userData = userSnapshot.data() as Map<String, dynamic>;
        final List<dynamic>? following = userData['following'];
        if (following != null) {
          return List<String>.from(following);
        }
      }
      return []; // Return an empty list if the user has no followings or the document doesn't exist
    } catch (e) {
      print("Error getting followings: $e");
      return []; // Return an empty list in case of error
    }
  }

  List<String> follwing = [];

  void setff() async {
    follwing = await getFollowings();
    setState(() {});
  }

  Future<void> unfollowUser(String userId) async {
    try {
      final currentUserUid = FirebaseAuth.instance.currentUser!.uid;

      // Remove the current user from the target user's followers list
      await FirebaseFirestore.instance
          .collection('aboutUsers')
          .doc(userId)
          .update({
        "followers": FieldValue.arrayRemove([currentUserUid]),
      });

      // Remove the target user from the current user's following list
      await FirebaseFirestore.instance
          .collection('aboutUsers')
          .doc(currentUserUid)
          .update({
        "following": FieldValue.arrayRemove([userId]),
      });

      // Update isFollowing to false
      setState(() {
        isFollowing = false;
      });

      // Show success message or perform any other action if needed
    } catch (e) {
      print("Error unfollowing user: $e");
      // Handle the error as needed
    }
  }

  @override
  void initState() {
    setff();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff131429),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'User List',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: DelayedDisplay(
        delay: const Duration(milliseconds: 100),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                textAlign: TextAlign.left,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                  suffixIcon: Icon(
                    Icons.search,
                    color: Colors.white.withOpacity(0.5),
                    size: 20,
                  ),
                  isDense: true,
                  hintText: "Search Users",
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: const Color(0xff232441),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('aboutUsers')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }
                  final users = snapshot.data!.docs.where((doc) {
                    final userData = doc.data() as Map<String, dynamic>;
                    final username = userData['username'] ?? '';
                    return username
                        .toLowerCase()
                        .contains(_searchQuery.toLowerCase());
                  }).toList();
                  final List<String> userIds =
                      snapshot.data!.docs.map((doc) => doc.id).toList();
                  userIds.forEach((userId) {
                    if (!followStatus.containsKey(userId)) {
                      followStatus[userId] =
                          false; // Initialize follow status for each user
                    }
                  });
                  return DelayedDisplay(
                    delay: const Duration(milliseconds: 100),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                              final userData =
                                  users[index].data() as Map<String, dynamic>;
                              final List<dynamic> activitiesDynamic =
                                  userData['fitnessActivities'] ?? [];
                              final List<String> fitnessActivities =
                                  activitiesDynamic
                                      .map((activity) => activity.toString())
                                      .toList();

                              return ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PeopleProfile(
                                        username: userData['username'],
                                        userProfileImg:
                                            userData['profileImgPath'],
                                        goal: userData['goal'] ?? "No Goal Set",
                                        fitnessActivities:
                                            fitnessActivities ?? [],
                                        id: userData['uid'],
                                      ),
                                    ),
                                  );
                                },
                                leading: CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(userData['profileImgPath']),
                                ),
                                title: Text(
                                  userData['username'],
                                  style: const TextStyle(color: Colors.white),
                                ),
                                subtitle: Text(
                                  userData['type'] == '0'
                                      ? "Enthusiasts"
                                      : "Professional",
                                  style: const TextStyle(color: Colors.white),
                                ),
                                trailing: SizedBox(
                                  width: 90,
                                  height: 40,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (follwing.contains(FirebaseAuth
                                          .instance.currentUser!.uid)) {
                                        unfollowUser(FirebaseAuth
                                            .instance.currentUser!.uid);
                                      } else {
                                        toggleFollow(userData['uid']);
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Text(
                                        isFollowing ? 'Following' : 'Follow'),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
