import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class SinglePostWdController extends GetxController {
  @override
  void onInit() {
    var pageId = Get.parameters['id'];
    printf('Page id is : $pageId');
    super.onInit();
  }

  void printf(String? text) {
    if (kDebugMode) {
      print('=====================');
      print(text);
      print('=====================');
    }
  }
}
