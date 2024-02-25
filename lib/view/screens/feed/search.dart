import 'package:delayed_display/delayed_display.dart';
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
                                  userData['goal'] ?? "Enthusiasts",
                                  style: const TextStyle(color: Colors.white),
                                ),
                                trailing: SizedBox(
                                  width: 90,
                                  height: 40,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Implement follow functionality here
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text('Follow'),
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
