import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fitsocial/controller/functionsController.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart' as firebasecore;
import '../../helpers/string_methods.dart';
import '../functionsController/dialogsAndLoadingController.dart';

class UserInformationController extends GetxController {
  // Dependency injection
  FunctionsController controller = Get.put(FunctionsController());
  DialogsAndLoadingController dialogsAndLoadingController =
      Get.put(DialogsAndLoadingController());

  // Variables
  // Username if some problem happened getting the username from user himself
  late RxString username = "Anonym user".obs;

  // Default img url
  RxString userProfileImg =
      "https://www.pngall.com/wp-content/uploads/12/Avatar-Profile.png".obs;

  // Profile img path getted from firestore
  String? newGettedPath;

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Firebase auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Storage instance
  final storage = FirebaseStorage.instance;

  // ImgPicker instance
  ImagePicker picker = ImagePicker();

  // User's goal
  late RxString goal;

  // Activities related to fitness
  late RxList<String> fitnessActivities;

  late RxList followers = <String>[].obs;
  late RxList following = <String>[].obs;
  @override
  void onInit() {
    setUsername();
    setProfileImgPath();
    fetchGoalAndHandleError();
    fetchFitnessActivities();
    fetchFollowers();
    fetchFollowing();
    super.onInit();
  }

  // Set username from firestore ( accept string )
  setUsername() async {
    // Assign getted username from firestore to username variable
    username.value = await _firestore
        .collection("aboutUsers")
        .doc(_auth.currentUser!.uid)
        .get()
        .then(
          (value) => value["username"],
        );
  }

  Future<void> fetchFollowers() async {
    try {
      List<String> follos = await getfollowers();
      followers = follos.obs;
    } catch (e) {
      print("Error fetching fitness activities: $e");
      fitnessActivities = <String>[].obs;
    }
  }

  Future<void> fetchFollowing() async {
    try {
      List<String> follos = await getfollowing();
      following = follos.obs;
    } catch (e) {
      print("Error fetching fitness activities: $e");
      fitnessActivities = <String>[].obs;
    }
  }

  Future<List<String>> getfollowers() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("aboutUsers")
          .doc(_auth.currentUser!.uid)
          .get();

      // Check if the document exists and contains the 'fitnessActivities' field
      if (snapshot.exists && snapshot.data() != null) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        if (data.containsKey('followers')) {
          List<dynamic>? activities = data['followers'];
          if (activities != null) {
            return activities.map((activity) => activity.toString()).toList();
          } else {
            // If 'fitnessActivities' field exists but is null, return an empty list
            return [];
          }
        }
      }
      // If the document or 'fitnessActivities' field doesn't exist, return an empty list
      return [];
    } catch (e) {
      print("Error fetching fitness activities: $e");
      // Handle error as needed
      return []; // Return empty list in case of error
    }
  }

  Future<List<String>> getfollowing() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("aboutUsers")
          .doc(_auth.currentUser!.uid)
          .get();

      // Check if the document exists and contains the 'fitnessActivities' field
      if (snapshot.exists && snapshot.data() != null) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        if (data.containsKey('following')) {
          List<dynamic>? activities = data['following'];
          if (activities != null) {
            return activities.map((activity) => activity.toString()).toList();
          } else {
            // If 'fitnessActivities' field exists but is null, return an empty list
            return [];
          }
        }
      }
      // If the document or 'fitnessActivities' field doesn't exist, return an empty list
      return [];
    } catch (e) {
      print("Error fetching fitness activities: $e");
      // Handle error as needed
      return []; // Return empty list in case of error
    }
  }

  // Set profile image path from Firestore
  setProfileImgPath() async {
    // Set the getted profile img path from firestore to newGettedPath variable
    newGettedPath = await getProfileImgPathFromFirestore();

    // Checks if the there is difference between the newGettedPath and the userProfileImg from firestore
    bool isNewGettedPathDifferentThanUserProfileImg =
        (newGettedPath != userProfileImg.value);

    // Set it to userProfileImg variable if there is difference
    if (isNewGettedPathDifferentThanUserProfileImg && newGettedPath != "") {
      userProfileImg.value = newGettedPath!;
    }
  }

  Future<void> fetchGoalAndHandleError() async {
    try {
      String fetchedGoal = await getGoal();
      goal = fetchedGoal.obs;
    } catch (e) {
      print("Error fetching goal: $e");
      // Set default goal in settings
      goal = "Set Your Goal in Setting".obs;
    }
  }

  // Get profile image path from FirestoreRR
  Future<String> getProfileImgPathFromFirestore() async {
    return await _firestore
        .collection("aboutUsers")
        .doc(_auth.currentUser!.uid)
        .get()
        .then(
          (value) => value["profileImgPath"],
        ) as String;
  }

  Future<String> getGoal() async {
    return await _firestore
        .collection("aboutUsers")
        .doc(_auth.currentUser!.uid)
        .get()
        .then(
          (value) => value["goal"],
        ) as String;
  }

  // Get image from camera
  Future<XFile?> getImgFromCamera() async {
    // Get img from camera
    XFile? image = await picker.pickImage(source: ImageSource.camera);

    // Check if there is img
    bool isImgPicked = image != null;

    // return it if there is img
    if (isImgPicked) {
      return image;
    }

    // Show error if there is no img
    dialogsAndLoadingController.showError(
      capitalize(
        "operation canceled",
      ),
    );
    return null;
  }

  // Get image from device
  Future<XFile?> getImgFromDevice() async {
    // Get img from device
    XFile? image = await picker.pickImage(source: ImageSource.gallery);

    // Check if there is img
    bool isImgPicked = image != null;

    // return it if there is img
    if (isImgPicked) {
      return image;
    }

    // Show error if there is no img
    dialogsAndLoadingController.showError(
      capitalize(
        "operation canceled",
      ),
    );
    return null;
  }

  // Update profile image path to firestore
  updateProfile(XFile? image) async {
    // Check if there is img
    bool isImgPickedFromDeviceOrCamera = image != null;

    // FB storage reference
    final Reference userProfileImgReference =
        storage.ref("usersProfileImgs/${_auth.currentUser!.uid}");

    late String imageDownloadURL;

    if (isImgPickedFromDeviceOrCamera) {
      // set the file with image path
      File imgFile = File(image!.path);

      try {
        // Show loading
        dialogsAndLoadingController.showLoading();

        // Upload img to firebase storage
        await userProfileImgReference.putFile(imgFile);

        // Get the download url of the img
        imageDownloadURL = await userProfileImgReference.getDownloadURL();

        // Update it in firestore
        await _firestore
            .collection("aboutUsers")
            .doc(_auth.currentUser!.uid)
            .update({
          "profileImgPath": imageDownloadURL,
        });

        // update it in app
        userProfileImg.value = imageDownloadURL;

        // pop loading
        Get.back();

        // show success msg to user
        dialogsAndLoadingController.showSuccess(
          capitalize(
            "profile image updated successfully",
          ),
        );
      } on firebasecore.FirebaseException catch (e) {
        // On Error, pop first loading
        Get.back();

        // Then show it to user (you can here set case for each error type, (in case you want to help, set some if checks here))
        dialogsAndLoadingController.showError("$e");
      }
    } else {
      // Show error if there is no img (not necessary to show it to user)
      print("canceled");
    }
  }

  // Update username in firestore and set new one in the view (lifecycle)
  updateUsername(String newUsername) async {
    // Show loading
    dialogsAndLoadingController.showLoading();

    try {
      // Update username in firestore
      await _firestore
          .collection("aboutUsers")
          .doc(_auth.currentUser!.uid)
          .update({
        "username": newUsername,
      });

      // Pop loading
      Get.back();

      // Username is observable (.obs) changing it's value change it also in the UI
      username.value = newUsername;

      // Show success msg to user
      dialogsAndLoadingController
          .showSuccess(capitalize("username updates successfully"));
    } on FirebaseException catch (e) {
      // Need more checks
      // Show error to user
      dialogsAndLoadingController.showError("${e.message}");
    }
  }

  // Update login email with FirebaseAuth
  updateEmail(String newEmail) async {
    // Show loading
    dialogsAndLoadingController.showLoading();

    try {
      // Update email in firebase auth
      await _auth.currentUser!.updateEmail(newEmail);

      // updating data in firestore
      // ! after next opening of the app it'll demand to verify new email
      await _firestore
          .collection("aboutUsers")
          .doc(_auth.currentUser!.uid)
          .update({
        "email": newEmail,
        "verified": _auth.currentUser!.emailVerified,
      });
      // pop loading
      Get.back();

      // Show success msg to user
      dialogsAndLoadingController.showSuccess(
        capitalize(
          "email updates successfully",
        ),
      );
    } on FirebaseAuthException catch (e) {
      // pop loading
      Get.back();

      // Firebase rules: if you want to update it, you should re-login to verify that your the owner, you can do it programitically, re-autenticate and u^date it without letting user to know, but since it make since to ask a to re-auth
      if (e.code == 'requires-recent-login') {
        dialogsAndLoadingController.showConfirmWithActions(
            "due to safety reasons, you need a recent re-login to your account in order to get permission to change email",
            capitalize("re-login"), () {
          _auth.signOut();
        });
      } else {
        // Show other error to user if happened
        dialogsAndLoadingController.showError(e.toString());
      }
    }
  }

  // Update password with FirebaseAuth and update it in firestore
  updatePassword(String newPassword) async {
    // Show loading
    dialogsAndLoadingController.showLoading();
    try {
      // Update password in firebase auth
      await _auth.currentUser!.updatePassword(newPassword);

      // Update it in firestore
      await _firestore
          .collection("aboutUsers")
          .doc(_auth.currentUser!.uid)
          .update({
        "password": newPassword,
      });

      // Pop loading
      Get.back();

      // Show success msg to user
      dialogsAndLoadingController.showSuccess(
        capitalize(
          "password updates successfully",
        ),
      );
    } on FirebaseAuthException catch (e) {
      // Pop loading
      Get.back();

      // Same as above updateEmail method
      if (e.code == 'requires-recent-login') {
        dialogsAndLoadingController.showConfirmWithActions(
            "due to safety reasons, you need a recent re-login to your account in order to get permission to change password",
            capitalize("re-login"), () {
          _auth.signOut();
        });
      }
      // other checks
      else if (e.code == 'weak-password') {
        dialogsAndLoadingController.showError(capitalize("weak password"));
      } else {
        dialogsAndLoadingController.showError(e.toString());
      }
    }
  }

  // Delete user
  deleteUser() async {
    // Show loading
    dialogsAndLoadingController.showLoading();
    try {
      // Delete user from firebase auth
      await _auth.currentUser?.delete();

      // user will be sign out (returned to home screen), then be deleted from firebase auth

      /// Delete user from firestore (to-do)

      // show success msg to user
      dialogsAndLoadingController.showSuccess(capitalize("user deleted"));
    } on FirebaseException catch (e) {
      // pop loading
      Get.back();

      // Same as above updateEmail method
      // if (e.code == 'requires-recent-login') {
      //   dialogsAndLoadingController.showConfirmWithActions(
      //       "We are moving you to Main Page", capitalize("re-login"), () {
      //     _auth.signOut();
      //   });
      // }
      // // Other checks
      // else if (e.code == 'weak-password') {
      //   dialogsAndLoadingController.showError(capitalize("weak password"));
      // } else {
      //   dialogsAndLoadingController.showError(e.toString());
      // }
    }
  }

  // Set user's goal
  setGoal(String userGoal) async {
    goal.value = userGoal;
    try {
      // Update firestore collection 'aboutUsers'
      await FirebaseFirestore.instance
          .collection("aboutUsers")
          .doc(_auth.currentUser!.uid)
          .update({
        "goal": goal.value,
      });
    } catch (e) {
      print("Error adding activity to Firestore: $e");
      // Handle error as needed
    }
  }

  void addFitnessActivity(String activity) async {
    fitnessActivities.add(activity);

    try {
      // Update firestore collection 'aboutUsers'
      await FirebaseFirestore.instance
          .collection("aboutUsers")
          .doc(_auth.currentUser!.uid)
          .update({
        "fitnessActivities": FieldValue.arrayUnion([activity]),
      });
    } catch (e) {
      print("Error adding activity to Firestore: $e");
      // Handle error as needed
    }
  }

  Future<void> fetchFitnessActivities() async {
    try {
      List<String> fetchedActivities = await getFitnessActivities();
      fitnessActivities = fetchedActivities.obs;
    } catch (e) {
      print("Error fetching fitness activities: $e");
      fitnessActivities = <String>[].obs;
    }
  }

  Future<List<String>> getFitnessActivities() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("aboutUsers")
          .doc(_auth.currentUser!.uid)
          .get();

      // Check if the document exists and contains the 'fitnessActivities' field
      if (snapshot.exists && snapshot.data() != null) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        if (data.containsKey('fitnessActivities')) {
          List<dynamic>? activities = data['fitnessActivities'];
          if (activities != null) {
            return activities.map((activity) => activity.toString()).toList();
          } else {
            // If 'fitnessActivities' field exists but is null, return an empty list
            return [];
          }
        }
      }
      // If the document or 'fitnessActivities' field doesn't exist, return an empty list
      return [];
    } catch (e) {
      print("Error fetching fitness activities: $e");
      // Handle error as needed
      return []; // Return empty list in case of error
    }
  }
}
