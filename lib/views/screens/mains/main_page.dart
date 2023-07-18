import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/controllers/main_pages/main_page_controller.dart';

class MainPage extends GetWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: MainPageController(),
        builder: ((controller) => Directionality(
              textDirection: Get.locale == const Locale('ar')
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: SafeArea(
                child: Scaffold(
                  // Body
                  body: controller.mainScreens[controller.index],
                  // Navigation Bar
                  bottomNavigationBar: NavigationBarTheme(
                    data: const NavigationBarThemeData(),
                    child: NavigationBar(
                        labelBehavior:
                            NavigationDestinationLabelBehavior.onlyShowSelected,
                        animationDuration: const Duration(milliseconds: 800),
                        selectedIndex: controller.index,
                        onDestinationSelected: (value) =>
                            controller.selectedPage(value),
                        height: 60,
                        destinations: [
                          NavigationDestination(
                              icon: const Icon(Icons.play_circle_outline),
                              selectedIcon:
                                  const Icon(Icons.slow_motion_video_rounded),
                              label: 'feed'.tr),
                          NavigationDestination(
                              icon: const Icon(Icons.search),
                              selectedIcon: const Icon(Icons.search_outlined),
                              label: 'search'.tr),
                          NavigationDestination(
                              icon: const Icon(Icons.add_circle_outline),
                              selectedIcon: const Icon(Icons.add_circle),
                              label: 'create'.tr),
                        ]),
                  ),
                ),
              ),
            )));
  }
}
