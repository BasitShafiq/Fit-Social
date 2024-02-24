import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitsocial/config/Colors.dart';
import 'package:fitsocial/config/text.dart';
import 'package:fitsocial/view/widgets/general_widgets/screen_background_image.dart';
import '../../../config/getStarted/getStartedData.dart';
import '../../../config/show_delay_mixin.dart';
import '../../../controller/get_started_controller/get_started_controller.dart';
import '../../../helpers/string_methods.dart';
import '../../widgets/general_widgets/mainScreenTitle.dart';
import '../../widgets/general_widgets/titleWithDescription.dart';
import 'componenets/get_started_cards_scroll_view.dart';

class GetStartedPage extends GetView<GetStartedController>
    with DelayHelperMixin {
  GetStartedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const BackgroundImage(),
          Container(
            color: const Color(0xff0B183C).withOpacity(0.69),
            width: double.infinity,
            child: Container(
              margin: const EdgeInsets.symmetric(
                vertical: 15,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Spacer(),
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
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: DelayedDisplay(
                      delay: getDelayDuration(),
                      child: TitleWithDescription(
                        title: capitalize(AppTexts.aboutYou),
                        description: AppTexts.getStartedDescription,
                      ),
                    ),
                  ),
                  const Spacer(
                    flex: 2,
                  ),
                  Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: Theme.of(context).colorScheme.copyWith(
                            primary: Colors.transparent,
                            secondary: Colors.transparent,
                          ),
                    ),
                    child: GetStartedCardsScrollView(
                      delay: getDelayDuration(),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    child: DelayedDisplay(
                      delay: getDelayDuration(),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            child: Text(
                              capitalize(AppTexts.skipIntro),
                              style: TextStyle(
                                color:
                                    const Color(0xffffffff).withOpacity(0.42),
                              ),
                            ),
                          ),
                          IntrinsicHeight(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Align(
                                    alignment: Alignment.center,
                                    child: GetBuilder<GetStartedController>(
                                      id: controller.rebuildId,
                                      builder: (controller) {
                                        return Text(
                                          "${controller.checkedCardsIds.length} / ${handledCardsList.length}",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.green,
                                            fontSize: 12,
                                          ),
                                        );
                                      },
                                    )),
                                const SizedBox(width: 15),
                                GetBuilder<GetStartedController>(
                                  id: controller.rebuildId,
                                  builder: (controller) {
                                    return ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                        ),
                                        foregroundColor:
                                            Theme.of(context).primaryColor,
                                      ),
                                      onPressed: controller
                                              .hasUserChooserAtLeastOneChoice
                                          ? () {
                                              Get.toNamed("/signUp");
                                            }
                                          : null,
                                      child: Text(
                                        capitalize(AppTexts.next),
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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
