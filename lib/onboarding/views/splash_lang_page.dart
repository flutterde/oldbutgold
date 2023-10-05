import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../views/widgets/language_widget.dart';
import '../controllers/splash_page_controller.dart';

class SplashLangPage extends GetWidget {
  const SplashLangPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: SplashPageController(),
        builder: ((controller) => Directionality(
              textDirection: Get.locale == const Locale('ar')
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: Scaffold(
                body: SafeArea(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'choose_lange'.tr,
                          style: const TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        Image.asset(
                          'assets/images/onboarding/choose_lang.png',
                          height: 100,
                        ),
                        const LanguageWidget(),
                        ElevatedButton.icon(
                          onPressed: controller.showOnBoardingPage,
                          label: Text('save_and_next'.tr),
                          icon: const Icon(Icons.navigate_next),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )));
  }
}
