import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/onboarding_info_model.dart';

class OnBoradingController extends GetxController {
  var selectedPageIndex = 0.obs;
  bool get isLastPage => selectedPageIndex.value == onBoardingPages.length - 1;
  var pageController = PageController();

  forwardAction() {
    if (isLastPage) {
      saveOnboardingAction();
      Get.offAllNamed(
          '/auth/register'); // this is has been changed from '/' to '/auth/register' in order to redirect to login page after onboarding
    } else {
      pageController.nextPage(duration: 500.milliseconds, curve: Curves.ease);
    }
  }

  saveOnboardingAction() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingshowed', true);
    update();
  }

  List onBoardingPages = [
    OnBoardingInfo('assets/images/onboarding/welcome.png', 'welcome'.tr,
        'onboarding_1_description'.tr),
    OnBoardingInfo('assets/images/onboarding/explorer_.png', 'onbo_title2'.tr,
        'onboarding_2_description'.tr),
    OnBoardingInfo('assets/images/onboarding/connect_.png', 'onbo_title3'.tr,
        'onboarding_3_description'.tr),
    OnBoardingInfo('assets/images/onboarding/save_.png', 'onbo_title4'.tr,
        'onboarding_4_description'.tr),
  ];
}
