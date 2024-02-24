import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Post {
  final String userId; // Add userId
  String userName;
  String userImageUrl;
  String imageUrl;
  final String message;
  final DateTime time;

  Post({
    required this.userId,
    required this.userName,
    required this.userImageUrl,
    required this.message,
    required this.imageUrl,
    required this.time,
  });
}

// Widget representing the page where posts from Firebase are displayed
class FeedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feed'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Color(0xff131429),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('posts').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text('No posts found'),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final postDoc = snapshot.data!.docs[index];
                final post = Post(
                  userId: postDoc['userId'],
                  imageUrl: postDoc['imageUrl'],
                  userName: '', // Initialize with empty string
                  userImageUrl: '', // Initialize with empty string
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
                      return ListTile(
                        title: Text('Loading...'),
                      );
                    }
                    if (userSnapshot.hasError) {
                      return ListTile(
                        title: Text('Error loading user data'),
                      );
                    }
                    final userData = userSnapshot.data!;
                    final userName = userData['username'];
                    final userImageUrl = userData['profileImgPath'];
                    post.userName = userName;
                    post.userImageUrl = userImageUrl;
                    final formattedDateTime =
                        DateFormat('yyyy-MM-dd HH:mm:ss').format(post.time);
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(post.userImageUrl),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                post.userName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                              ),
                              SizedBox(width: 8.0),
                              Text(
                                formattedDateTime,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14.0,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4.0),
                          SizedBox(height: 8.0),
                          // Display post image
                          post.imageUrl != null
                              ? Image.network(
                                  post.imageUrl,
                                  width:
                                      double.infinity, // Adjust width as needed
                                  fit: BoxFit.cover, // Adjust fit as needed
                                )
                              : SizedBox.shrink(),
                          Text(
                            post.message,
                            style: TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),
                      onTap: () {
                        // Handle tapping on post to view details
                      },
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
