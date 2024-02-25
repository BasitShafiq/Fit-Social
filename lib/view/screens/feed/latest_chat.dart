import 'package:fitsocial/view/screens/feed/chats.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LatestChatsPage extends StatefulWidget {
  final String userId;

  LatestChatsPage({required this.userId});

  @override
  _LatestChatsPageState createState() => _LatestChatsPageState();
}

class _LatestChatsPageState extends State<LatestChatsPage> {
  late Stream<QuerySnapshot> _latestChatsStream;

  @override
  void initState() {
    super.initState();
    //_setupLatestChatsStream();
  }

  void _setupLatestChatsStream() {
    _latestChatsStream = FirebaseFirestore.instance
        .collection('chats')
        .where('participants', arrayContains: widget.userId)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Latest Chats'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .where('participants', arrayContains: widget.userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          final latestChats = snapshot.data!.docs;
          if (latestChats.isEmpty) {
            return Center(
              child: Text('No chats available.'),
            );
          }

          return ListView.builder(
            itemCount: latestChats.length,
            itemBuilder: (context, index) {
              //final chat = latestChats[index].data() as Map<String, dynamic>;
              // print("++++++++++++++" + chat.toString());
              return ListTile(
                title: Text('Chat with '),
                // onTap: () {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => ChatPage(
                //         userId: widget.userId,
                //         otherUserId: chat['receiverId'] ?? "",
                //         url: chat['rImage'] ?? "",
                //         name: chat['rName'] ?? "",
                //       ),
                //     ),
                //   );
                // },r
              );
            },
          );
        },
      ),
    );
  }
}
