import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  

  RxBool isLoading = false.obs;


  Future<void>   resetPass(String email) async {
    try{
      isLoading.value = true;
      //
      await _auth.sendPasswordResetEmail(email: email).then((value) {
        emailController.clear();
        isLoading.value = false;
        Get.back();
        Get.snackbar(

          'success'.tr,
          'please_check_your_email_to_reset_your_password'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
      
      });
    } catch(e){
      if(kDebugMode){
        print('============================================');
        print(e);
        print('============================================');
      }
      Get.snackbar(
        'error'.tr,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
