// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitsocial/controller/functionsController.dart';
import 'package:fitsocial/view/widgets/general_widgets/button.dart';
import 'package:fitsocial/view/widgets/general_widgets/text%20field.dart';

import '../../helpers/string_methods.dart';
import '../functionsController/dialogsAndLoadingController.dart';
import '../userController/userController.dart';

class UserProfileOptionsController extends GetxController {
  FunctionsController controller = Get.put(FunctionsController());
  UserInformationController userInformationController = Get.put(
    UserInformationController(),
  );
  DialogsAndLoadingController dialogsAndLoadingController =
      Get.put(DialogsAndLoadingController());
  TextEditingController newUserNameController = TextEditingController();
  TextEditingController newEmailController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController goalController = TextEditingController();
  TextEditingController activityController = TextEditingController();
  late List userProfileOptionsList = [
    {
      "optionTitle": "change username",
      "optionIcon": Icons.person,
      "optionFunction": () {
        Get.bottomSheet(
          Container(
            width: double.infinity,
            height: 200,
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomTextField(
                    label: capitalize("new username"),
                    controller: newUserNameController,
                    keyboardType: TextInputType.text),
                SizedBox(
                  height: 50,
                  child: CustomButton(
                      text: capitalize("update"),
                      isOutlined: false,
                      onPressed: () {
                        Get.back();
                        userInformationController
                            .updateUsername(newUserNameController.text.trim());
                      }),
                ),
              ],
            ),
          ),
          backgroundColor: Color(0xff131429),
        );
      }
    },
    {
      "optionTitle": "change profile photo",
      "optionIcon": Icons.image,
      "optionFunction": () {
        Get.bottomSheet(
            Container(
              height: 200,
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    capitalize("Select an image"),
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await userInformationController.updateProfile(
                              await userInformationController
                                  .getImgFromDevice());
                        },
                        child: Icon(
                          Icons.perm_media,
                          size: 55,
                          color: Color(0xff40D876),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await userInformationController.updateProfile(
                              await userInformationController
                                  .getImgFromCamera());
                        },
                        child: Icon(
                          Icons.camera_alt,
                          size: 55,
                          color: Color(0xff40D876),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            backgroundColor: Color(0xff131429));
      },
    },
    {
      "optionTitle": "set a new email adress",
      "optionIcon": Icons.mail,
      "optionFunction": () {
        Get.bottomSheet(
            Container(
              width: double.infinity,
              height: 200,
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomTextField(
                      label: capitalize("new email"),
                      controller: newEmailController,
                      keyboardType: TextInputType.text),
                  SizedBox(
                    height: 50,
                    child: CustomButton(
                        text: capitalize("update"),
                        isOutlined: false,
                        onPressed: () async {
                          Get.back();

                          await userInformationController
                              .updateEmail(newEmailController.text.trim());
                        }),
                  )
                ],
              ),
            ),
            backgroundColor: Color(0xff131429));
      }
    },
    {
      "optionTitle": "set a new password",
      "optionIcon": Icons.lock,
      "optionFunction": () {
        Get.bottomSheet(
            Container(
              width: double.infinity,
              height: 200,
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomTextField(
                      obscureText: true,
                      label: capitalize("new password"),
                      controller: newPasswordController,
                      keyboardType: TextInputType.visiblePassword),
                  SizedBox(
                    height: 50,
                    child: CustomButton(
                        text: capitalize("update"),
                        isOutlined: false,
                        onPressed: () async {
                          Get.back();
                          await userInformationController.updatePassword(
                              newPasswordController.text.trim());
                        }),
                  )
                ],
              ),
            ),
            backgroundColor: Color(0xff131429));
      }
    },
    {
      "optionTitle": "Set Goal",
      "optionIcon": Icons.flag,
      "optionFunction": () {
        Get.bottomSheet(
          Container(
            width: double.infinity,
            height: 200,
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomTextField(
                  label: capitalize("Enter your goal"),
                  controller: goalController,
                  keyboardType: TextInputType.text,
                ),
                SizedBox(
                  height: 50,
                  child: CustomButton(
                    text: capitalize("Set Goal"),
                    isOutlined: false,
                    onPressed: () {
                      Get.back();
                      userInformationController
                          .setGoal(goalController.text.trim());
                    },
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: Color(0xff131429),
        );
      }
    },
    {
      "optionTitle": "Add Activity",
      "optionIcon": Icons.add_circle,
      "optionFunction": () {
        Get.bottomSheet(
          Container(
            width: double.infinity,
            height: 200,
            margin: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomTextField(
                  label: capitalize("Enter activity"),
                  controller: activityController,
                  keyboardType: TextInputType.text,
                ),
                SizedBox(
                  height: 50,
                  child: CustomButton(
                    text: capitalize("Add Activity"),
                    isOutlined: false,
                    onPressed: () {
                      Get.back();
                      userInformationController
                          .addFitnessActivity(activityController.text.trim());
                    },
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: Color(0xff131429),
        );
      }
    },
    {
      "optionTitle": "Delete user",
      "optionIcon": Icons.delete,
      "optionFunction": () {
        dialogsAndLoadingController.showConfirmWithActions(
          capitalize("are you sure you want to delete your account ?"),
          capitalize("delete"),
          () {
            Get.back();
            userInformationController.deleteUser();
          },
        );
      }
    },
  ];
}
