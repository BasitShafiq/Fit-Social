import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitsocial/config/Colors.dart';
import 'package:fitsocial/config/images%20sources.dart';
import 'package:fitsocial/config/text.dart';
import 'package:fitsocial/view/widgets/general_widgets/titleWithDescription.dart';
import 'package:fitsocial/view/screens/toggle%20laungage/chooseLaungagePage.dart';
import '../../../controller/functionsController.dart';
import '../../../config/show_delay_mixin.dart';
import '../../../helpers/string_methods.dart';
import '../../widgets/general_widgets/button.dart';
import '../../widgets/general_widgets/mainScreenTitle.dart';
import '../../widgets/general_widgets/screen_background_image.dart';

class WelcomePage extends GetView<FunctionsController> with DelayHelperMixin {
  WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          BackgroundImage(
            backgroundImage: ImgSrc().randomFromAssetsList(),
          ),
          Container(
            color: AppColors.darkBlue.withOpacity(0.69), // Nice
            width: double.infinity,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  // Hard Element MainScreenTitle
                  DelayedDisplay(
                    delay: getDelayDuration(),
                    child: MainScreenTitle(
                      mainWord: AppTexts.firstMainWord,
                      secondaryWord: AppTexts.secondaryMainWord,
                    ),
                  ),

                  const Spacer(
                    flex: 2,
                  ),
                  // Screen TitleWithDescription
                  DelayedDisplay(
                    delay: getDelayDuration(),
                    child: TitleWithDescription(
                      title: capitalize(AppTexts.welcome),
                      description: AppTexts.welcomeDescription,
                    ),
                  ),
                  const Spacer(
                    flex: 2,
                  ),

                  // Buttons, change Language text
                  Column(
                    children: [
                      // Get Started button
                      DelayedDisplay(
                        delay: getDelayDuration(),
                        child: CustomButton(
                          onPressed: () {
                            Get.toNamed("/getStarted");
                          },
                          text: capitalize(AppTexts.getStarted),
                          isOutlined: false,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      // Login Button
                      DelayedDisplay(
                        delay: getDelayDuration(),
                        child: CustomButton(
                          onPressed: () {
                            Get.toNamed("/login");
                          },
                          text: capitalize(AppTexts.login),
                          isOutlined: true,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      // Change Language txt
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
