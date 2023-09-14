import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/onboarding_page_controller.dart';

class OnboardingPage extends StatelessWidget {
  OnboardingPage({super.key});
  final _controller = OnBoradingController();

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          PageView.builder(
              controller: _controller.pageController,
              onPageChanged: _controller.selectedPageIndex,
              itemCount: _controller.onBoardingPages.length,
              itemBuilder: (context, index) {
                var item = _controller.onBoardingPages[index];
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.asset(
                        item.imageUrl,
                        // width: mediaQuery.size.width * 0.8,
                        height: mediaQuery.size.height * 0.6,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(item.description,
                    textAlign: TextAlign.center,
                    ),
                  ],
                );
              }),
          Positioned(
            bottom: 25,
            left: Get.locale == const Locale('ar') ? null : 20,
            right: Get.locale == const Locale('ar') ? 20 : null,
            child: Row(
              children: List.generate(
                  _controller.onBoardingPages.length,
                  (index) => Obx(() {
                        return Container(
                          margin: const EdgeInsets.all(4),
                          height: 12,
                          width: 12,
                          decoration: BoxDecoration(
                            color: _controller.selectedPageIndex.value == index
                                ? Colors.red
                                : Colors.grey,
                            shape: BoxShape.circle,
                          ),
                        );
                      })),
            ),
          ),
          Positioned(
            bottom: 15,
            right: Get.locale == const Locale('ar') ? null : 20,
            left: Get.locale == const Locale('ar') ? 20 : null,
            child: TextButton(
                // onPressed: _controller.isLastPage ? _controller.printOk : _controller.forwardAction,
                onPressed: _controller.forwardAction,
                child: Obx(
                  () {
                    return Text(
                        _controller.isLastPage ? 'start'.tr : 'next'.tr);
                  },
                )),
          )
        ],
      )),
    );
  }
}
