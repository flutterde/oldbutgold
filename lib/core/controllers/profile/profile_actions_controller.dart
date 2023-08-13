import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileActionsController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signOut() async {
    Get.defaultDialog(
      title: 'sign_out'.tr,
      middleText: 'are_you_sure_you_want_to_sign_out'.tr,
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child:  Text('cancel'.tr),
        ),
        const SizedBox(
          width: 10,
        ),
        TextButton(
          onPressed: () async {
            await _auth.signOut();
            Get.offAllNamed('/auth/login');
          },
          child:  Text('sign_out'.tr),
        ),
      ],
      radius: 5,
    );
  }
}
