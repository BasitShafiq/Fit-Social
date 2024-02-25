import 'package:flutter/material.dart';

import '../../../../config/Colors.dart';

class NotificationListingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notification Listing',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NotificationListingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class NotificationListingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff131429),
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
          'Notifications',
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: 10, // Number of notifications
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Icon(Icons.notifications, color: Colors.white),
            ),
            title: Text(
              'Notification Title $index',
              style: TextStyle(color: Colors.white), // Set text color to white
            ),
            subtitle: Text(
              'Notification message goes here.',
              style: TextStyle(color: Colors.white), // Set text color to white
            ),
            trailing: Icon(Icons.arrow_forward_ios,
                color: Colors.white), // Set icon color to white

            onTap: () {
              // Handle tap on notification
              print('Notification $index tapped');
            },
          );
        },
      ),
    );
  }
}
