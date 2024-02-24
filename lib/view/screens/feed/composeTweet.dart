import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';

class ComposeMessagePage extends StatefulWidget {
  @override
  _ComposeMessagePageState createState() => _ComposeMessagePageState();
}

class _ComposeMessagePageState extends State<ComposeMessagePage> {
  late File _image;
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _image = File('');
    _textEditingController = TextEditingController();
  }

  void _onImageIconSelected(File file) {
    setState(() {
      _image = file;
    });
  }

  void _onCrossIconPressed() {
    setState(() {
      _image = File('');
    });
  }

  void _submitButton() async {
    User? user = FirebaseAuth.instance.currentUser;

    String userId = user!.uid;
    String message = _textEditingController.text;

    String imageUrl = '';
    if (_image.path.isNotEmpty) {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('feeds/$fileName');
      firebase_storage.UploadTask uploadTask = ref.putFile(_image);

      await uploadTask.whenComplete(() async {
        imageUrl = await ref.getDownloadURL();
      });
    }

    await FirebaseFirestore.instance.collection('posts').add({
      'userId': userId,
      'message': message,
      'imageUrl': imageUrl,
      'timestamp': Timestamp.now(),
    });

    _textEditingController.clear();
    setState(() {
      _image = File('');
    });
  }

  @override
  Widget build(BuildContext context) {
    double halfScreenWidth = MediaQuery.of(context).size.width * 0.5;

    return Scaffold(
      appBar: AppBar(
        title: Text('Compose Message'),
        actions: [
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _submitButton,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _textEditingController,
                decoration: InputDecoration(
                  hintText: 'Compose your message...',
                  border: OutlineInputBorder(),
                ),
                maxLines: null,
              ),
            ),
            _image.path.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: halfScreenWidth,
                      child: Image.file(_image),
                    ),
                  )
                : Container(),
            ComposeBottomIconWidget(
              textEditingController: _textEditingController,
              onImageIconSelected: _onImageIconSelected,
            ),
          ],
        ),
      ),
    );
  }
}

class ComposeBottomIconWidget extends StatelessWidget {
  final TextEditingController textEditingController;
  final Function(File) onImageIconSelected;

  const ComposeBottomIconWidget({
    Key? key,
    required this.textEditingController,
    required this.onImageIconSelected,
  }) : super(key: key);

  void _setImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      onImageIconSelected(File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Theme.of(context).primaryColor)),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: () => _setImage(ImageSource.gallery),
            color: Theme.of(context).primaryColor,
            icon: Icon(Icons.photo_library),
          ),
          IconButton(
            onPressed: () => _setImage(ImageSource.camera),
            color: Theme.of(context).primaryColor,
            icon: Icon(Icons.camera_alt),
          ),
        ],
      ),
    );
  }
}
