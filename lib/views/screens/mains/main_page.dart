import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../core/controllers/main_pages/main_page_controller.dart';
import 'package:badges/badges.dart' as badges;

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
                child: AnnotatedRegion<SystemUiOverlayStyle>(
                  value: const SystemUiOverlayStyle(
                    statusBarColor: Colors.black12,
                  ),
                  child: Scaffold(
                    // Body
                    body: controller.mainScreens[controller.index],
                    // Floating Action Button
                    floatingActionButton: FloatingActionButton(
                      onPressed: () {
                        Get.toNamed('/post/create');
                      },
                      backgroundColor: Colors.deepPurple[300],
                      child: const Icon(Icons.add),
                    ),
                    floatingActionButtonLocation:
                        FloatingActionButtonLocation.centerDocked,
                    // Navigation Bar
                    bottomNavigationBar: NavigationBarTheme(
                      data: const NavigationBarThemeData(
                        indicatorColor: Colors.deepPurple,
                      ),
                      child: NavigationBar(
                          labelBehavior: NavigationDestinationLabelBehavior
                              .onlyShowSelected,
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
                                icon: badges.Badge(
                                    onTap: () {
                                      controller.nCount = 0;
                                      controller.update();
                                    },
                                    showBadge: (controller.nCount == 0) ? false : true,
                                    badgeContent:
                                        Text(controller.nCount.toString()),
                                    child:
                                        const Icon(Icons.notifications_none)),
                                selectedIcon: const Icon(Icons.notifications),
                                label: ('notifications'.tr).substring(0, 9)),
                            NavigationDestination(
                                icon: const Icon(Icons.person_outline_sharp),
                                selectedIcon: const Icon(Icons.person_pin),
                                label: 'profile'.tr),
                          ]),
                    ),
                  ),
                ),
              ),
            )));
  }
}
