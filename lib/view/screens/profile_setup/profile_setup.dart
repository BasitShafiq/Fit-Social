import 'package:flutter/material.dart';

class ProfileSetupPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Profile Setup'),
        ),
        body: ProfileSetupForm(),
      ),
    );
  }
}

class ProfileSetupForm extends StatefulWidget {
  @override
  _ProfileSetupFormState createState() => _ProfileSetupFormState();
}

class _ProfileSetupFormState extends State<ProfileSetupForm> {
  TextEditingController _interestController = TextEditingController();
  String _selectedProfilePic =
      'assets/default_profile_pic.png'; // Default profile picture

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage(_selectedProfilePic),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Code to select profile picture
              // You can implement image picker here
              setState(() {
                // For demo purpose, just changing the profile picture asset
                _selectedProfilePic = 'assets/selected_profile_pic.png';
              });
            },
            child: Text('Select Profile Picture'),
          ),
          SizedBox(height: 20),
          TextField(
            controller: _interestController,
            decoration: InputDecoration(
              labelText: 'Interests',
              hintText: 'Enter your interests (comma separated)',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Code to save profile data
              String interests = _interestController.text;
              // You can handle saving profile data to database or any storage here
              // For demo, printing interests to console
              print('Interests: $interests');
              // You can navigate to next screen/page here
            },
            child: Text('Save Profile'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _interestController.dispose();
    super.dispose();
  }
}
