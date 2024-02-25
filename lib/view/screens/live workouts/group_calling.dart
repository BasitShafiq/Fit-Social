import 'package:fitsocial/config/Colors.dart';
import 'package:flutter/material.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import 'dart:math' as math;

final String userId = math.Random().nextInt(10000).toString();

class GroupCallScreen extends StatelessWidget {
  GroupCallScreen({Key? key}) : super(key: key);

  final callingId = TextEditingController(text: 'group_call_id');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          ),
        ],
        elevation: 0,
        toolbarHeight: 80,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: AppColors.darkBlue,
        title: Text(
          'Join Group Call',
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: Color(0xff131429),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Row(
            children: [
              Expanded(
                  child: TextFormField(
                controller: callingId,
                decoration: InputDecoration(labelText: 'Join group call by id'),
              )),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return CallPage(callingId: callingId.text.toString());
                    }));
                  },
                  child: Text('Join'))
            ],
          ),
        ),
      ),
    );
  }
}

class CallPage extends StatelessWidget {
  final String callingId;
  const CallPage({Key? key, required this.callingId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: ZegoUIKitPrebuiltCall(
      appID: 730853720,
      appSign:
          '6dc91f78108dd9c7214dd7fc23e719080521958187e84fb3506471501ce334b3',
      userID: userId,
      userName: 'username_$userId',
      callID: callingId,
      config: ZegoUIKitPrebuiltCallConfig.groupVideoCall(),
    ));
  }
}
