import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delayed_display/delayed_display.dart';
import 'package:fitsocial/controller/userController/userController.dart';
import 'package:fitsocial/helpers/string_methods.dart';
import 'package:fitsocial/view/screens/feed/groups.dart';
import 'package:fitsocial/view/screens/homepage/componenets/usernameAndProfile.dart';
import 'package:fitsocial/view/screens/user%20profile/userProfil.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../../../config/show_delay_mixin.dart';

class EventFeedPage extends StatelessWidget with DelayHelperMixin {
  final UserInformationController userInformationController =
      Get.put(UserInformationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff131429),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        title: const Text(
          'Create Your Event',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          InkWell(
            onTap: () {
              Get.to(const EventScreen());
            },
            child: Container(
              margin: const EdgeInsets.all(8),
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(50)),
              child: const Center(
                child: Icon(
                  Icons.add,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: const Color(0xff131429)),
        margin: const EdgeInsets.all(4),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('events').snapshots(),
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
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text('No posts found'),
              );
            }
            return DelayedDisplay(
              delay: getDelayDuration(),
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final postDoc = snapshot.data!.docs[index];
                  final post = Post(
                    userId: postDoc['userId'],
                    imageUrl: postDoc['imageUrl'],
                    message: postDoc['message'],
                    time: postDoc['timestamp'].toDate(),
                  );

                  return FutureBuilder<DocumentSnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('aboutUsers')
                        .doc(post.userId)
                        .get(),
                    builder: (context, userSnapshot) {
                      if (userSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const ListTile(
                          title: Text('Loading...'),
                        );
                      }
                      if (userSnapshot.hasError) {
                        return const ListTile(
                          title: Text('Error loading user data'),
                        );
                      }
                      final userData = userSnapshot.data!;
                      final userName = userData['username'];
                      final userImageUrl = userData['profileImgPath'];
                      post.userName = userName;
                      post.userImageUrl = userImageUrl;
                      final formattedDateTime =
                          DateFormat('dd MMM, yyyy').format(post.time);

                      return DelayedDisplay(
                        delay: getDelayDuration(),
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          padding: const EdgeInsets.all(8.0),
                          color: const Color(0xff131429),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(post.userImageUrl!),
                                  ),
                                  const SizedBox(width: 8.0),
                                  Text(
                                    post.userName ?? 'Unknown',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  const SizedBox(width: 8.0),
                                  Container(),
                                  Container(),
                                  Container(),
                                  Container(),
                                  Container(),
                                  Container(),
                                  Container(),
                                  Container(),
                                  Container(),
                                  Container(),
                                  Container(),
                                  Container(),
                                  Container(),
                                  Container(),
                                  Container(),
                                  Container(),
                                  Text(
                                    formattedDateTime,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                post.message,
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              if (post.imageUrl != null &&
                                  post.imageUrl!.isNotEmpty)
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(12.0),
                                    child: AspectRatio(
                                      aspectRatio: 16 / 9,
                                      child: CachedNetworkImage(
                                        imageUrl: post.imageUrl!,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            Shimmer.fromColors(
                                          baseColor: Colors.grey[
                                              300]!, // Change the base color as needed
                                          highlightColor: Colors.grey[
                                              100]!, // Change the highlight color as needed
                                          child: Container(
                                            color: Colors
                                                .white, // Optional: Set the background color of the shimmer effect
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                                    )),
                              const SizedBox(
                                width: double.infinity,
                                child: Divider(
                                  color: Colors.white, // Adjust color as needed
                                  thickness: 0.3, // Adjust thickness as needed
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class Post {
  final String userId;
  final String? imageUrl;
  String? userName;
  String? userImageUrl;
  final String message;
  final DateTime time;

  Post({
    required this.userId,
    required this.imageUrl,
    required this.message,
    required this.time,
  });
}
