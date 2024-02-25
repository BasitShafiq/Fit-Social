import 'package:delayed_display/delayed_display.dart';
import 'package:fitsocial/controller/functionsController/dialogsAndLoadingController.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ChatPage extends StatefulWidget {
  final String userId;
  final String otherUserId;
  final String url;
  final String name;

  ChatPage(
      {required this.userId,
      required this.otherUserId,
      required this.name,
      required this.url});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();

  String _generateChatId(String userId1, String userId2) {
    List<String> sortedIds = [userId1, userId2]..sort();
    return sortedIds.join('_');
  }

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

  late Map<String, dynamic> userData;
  void getData() async {
    userData = await getUserData(widget.userId);
    DialogsAndLoadingController dialogsAndLoadingController =
        Get.put(DialogsAndLoadingController());
    dialogsAndLoadingController.showLoading();
    setState(() {});
    Get.back();
  }

  late Stream<QuerySnapshot> _messagesStream;

  String get _chatId => _generateChatId(widget.userId, widget.otherUserId);

  void _setupMessagesStream() {
    String chatId = _generateChatId(widget.userId, widget.otherUserId);
    _messagesStream = FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  void _sendMessage(String message) {
    String chatId = _generateChatId(widget.userId, widget.otherUserId);

    FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add({
      'text': message,
      'senderId': widget.userId,
      'receiverId': widget.otherUserId,
      'rImage': widget.url,
      'participants': [widget.userId, widget.otherUserId],
      'rName': widget.name,
      'senderName': userData['username'],
      'timestamp': Timestamp.now(),
    });
  }

  @override
  void initState() {
    _setupMessagesStream();
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff131429),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                widget.url,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              widget.name,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _messagesStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  DialogsAndLoadingController dialogsAndLoadingController =
                      Get.put(DialogsAndLoadingController());
                  dialogsAndLoadingController.showLoading();
                }
                final messages = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message =
                        messages[index].data() as Map<String, dynamic>;
                    final isCurrentUser = message['senderId'] == widget.userId;
                    return DelayedDisplay(
                      delay: const Duration(milliseconds: 100),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: isCurrentUser
                                ? Colors.white
                                : Colors.transparent,
                          ),
                          margin: const EdgeInsets.all(4),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(userData[
                                      'profileImgPath'] ??
                                  "data:image/jpeg;base64,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"),
                            ),
                            title: Text(
                              userData['username'],
                              style: TextStyle(
                                color:
                                    isCurrentUser ? Colors.black : Colors.white,
                              ),
                            ),
                            subtitle: Text(
                              message['text'],
                              style: TextStyle(
                                color:
                                    isCurrentUser ? Colors.black : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: DelayedDisplay(
                      delay: const Duration(milliseconds: 100),
                      child: TextField(
                        controller: _messageController,
                        textAlign: TextAlign.left,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 13),
                          isDense: true,
                          hintText: "Type Your Message....",
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
                  ),
                ),
                const SizedBox(width: 8.0),
                IconButton(
                  onPressed: () {
                    if (_messageController.text.isNotEmpty) {
                      _sendMessage(_messageController.text);

                      _messageController.clear();
                    }
                  },
                  icon: const Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
