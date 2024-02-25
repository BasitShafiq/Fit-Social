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
      final DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('aboutUsers')
          .doc(userId)
          .get();

      if (userSnapshot.exists) {
        final userData = userSnapshot.data() as Map<String, dynamic>;
        print(userData);
        return userData;
      } else {
        print('User document does not exist');
        return {};
      }
    } catch (error) {
      print('Error fetching user data: $error');
      return {};
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
                            leading: isCurrentUser
                                ? null
                                : CircleAvatar(
                                    backgroundImage: NetworkImage(widget.url),
                                  ),
                            title: Text(
                              isCurrentUser ? 'You' : message['senderName'],
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
                            trailing: isCurrentUser
                                ? CircleAvatar(
                                    backgroundImage: NetworkImage(widget.url),
                                  )
                                : null,
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
