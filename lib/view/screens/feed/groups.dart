import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitsocial/controller/functionsController/dialogsAndLoadingController.dart';
import 'package:fitsocial/controller/userController/userController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  late File _image;
  late TextEditingController _textEditingController;
  final UserInformationController userInformationController =
      Get.put(UserInformationController());

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
    DialogsAndLoadingController dialogsAndLoadingController =
        Get.put(DialogsAndLoadingController());
    dialogsAndLoadingController.showLoading();
    User? user = FirebaseAuth.instance.currentUser;

    String userId = user!.uid;
    String message = _textEditingController.text;

    String? imageUrl;
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

    await FirebaseFirestore.instance.collection('events').add({
      'userId': userId,
      'message': message,
      'imageUrl': imageUrl,
      'timestamp': Timestamp.now(),
      'endingTime': '${_selectedTime.hour}:${_selectedTime.minute}'
    });
    Get.back();
    Get.back();

    _textEditingController.clear();
    setState(() {
      _image = File('');
    });
  }

  TimeOfDay _selectedTime = TimeOfDay.now();

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double halfScreenWidth = MediaQuery.of(context).size.width * 0.5;

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
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _submitButton,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(15)),
                  child: TextField(
                    controller: _textEditingController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'Compose your message...',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 7,
                  ),
                ),
              ),
            ),
            _image.path.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 800,
                      height: 320,
                      child: Image.file(_image),
                    ),
                  )
                : Container(),
            Row(
              children: [
                Flexible(
                  child: ComposeBottomIconWidget(
                    textEditingController: _textEditingController,
                    onImageIconSelected: _onImageIconSelected,
                  ),
                ),
                Flexible(
                  child: InkWell(
                    onTap: () => _selectTime(context),
                    child: Container(
                      height: 50,
                      width: 130,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(13),
                          color: Colors.white),
                      child: Center(
                        child: Text(_selectedTime.toString()),
                      ),
                    ),
                  ),
                ),
              ],
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
      decoration: const BoxDecoration(
        //border: Border(top: BorderSide(color: Theme.of(context).primaryColor)),
        color: Colors.transparent,
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 15,
          ),
          InkWell(
            onTap: () => _setImage(ImageSource.gallery),
            child: Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13), color: Colors.white),
              child: const Center(
                child: Icon(Icons.image),
              ),
            ),
          ),
          const SizedBox(
            width: 15,
          ),
          InkWell(
            onTap: () => _setImage(ImageSource.camera),
            child: Container(
              height: 70,
              width: 70,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(13), color: Colors.white),
              child: const Center(
                child: Icon(Icons.camera_alt),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
