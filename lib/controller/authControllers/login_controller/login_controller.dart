import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:fitsocial/controller/authControllers/login_controller/extensions/text.dart';

import '../../functionsController/dialogsAndLoadingController.dart';

class LoginController extends GetxController {
  late TextEditingController loginEmailController;
  late TextEditingController loginPasswordController;

  DialogsAndLoadingController dialogsAndLoadingController = Get.find();

  @override
  void onInit() {
    initializeTextEditingControllers();
    super.onInit();
  }

  @override
  void onClose() {
    disposeTextEditingControllers();
    super.onClose();
  }
}
