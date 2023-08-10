// ignore_for_file: unnecessary_overrides

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'register_controller.dart';

class LoginController extends GetxController {
  final registerController = Get.put(RegisterAuthController());
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  //
  RxBool isLoading = false.obs;


  
  // user Device token
  String deviceToken = '';

  // login user
  Future<void> loginUser() async {
    try {
      isLoading.value = true;
      await _auth
          .signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      )
          .then((value) async {
        emailController.clear();
        passwordController.clear();
        if (value.user!.emailVerified) {
          isLoading.value = false;
          Get.offAllNamed('/');
          Get.snackbar(
            'Success',
            'Login successful',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        } else {
          await value.user!.sendEmailVerification();
          await _auth.signOut();
          isLoading.value = false;
          Get.snackbar(
            'verify_email'.tr,
            'please_check_your_email_to_verify_your_account'.tr,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange,
            colorText: Colors.white,
            duration: const Duration(seconds: 6),
          );
        }
      });
    } on FirebaseAuthException catch (e) {
      isLoading.value = false;
      if (e.code == 'user-not-found') {
        Get.snackbar(
          'error'.tr,
          'no_user_found_for_that_email'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else if (e.code == 'wrong-password') {
        Get.snackbar(
          'error'.tr,
          'wrong_password_provided_for_that_user'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }
  }

  Future<void> loginWithGoogle() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      //
      isLoading.value = true;
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await auth.signInWithCredential(credential).then((value) async {
        String userEmail = value.user!.email!;
        var check = await checkEmailExisten(userEmail);
        if (kDebugMode) {
          print('=============== CHECK ========================');
          print(check);
          print('=======================================');
        }
        if (check == 1) {
          await updateUserDeviceToken();
          isLoading.value = false;
          Get.offAllNamed('/');
        } else {
          await registerController.storeUserData(
            value.user!.displayName!,
            '',
            value.user!.email!,
            value,
            value.user!.uid,
          );
          isLoading.value = false;
          Get.offAllNamed('/auth/redeem');
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print('=========ERROR=========');
        print(e);
        print('=========ERROR=========');
      }
      Get.snackbar(
        'error'.tr,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 6),
      );
      isLoading.value = false;
    }
  }

  Future<int> checkEmailExisten(String userMail) async {
    int exist = 0;

    try {
      await _firestore
          .collection('users')
          .where('email', isEqualTo: userMail)
          .count()
          .get()
          .then((value) {
        if (value.count == 1) {
          if (kDebugMode) {
            print('=============== COUNT ========================');
            print(value.count);
            print('=======================================');
          }
          exist = 1;
          update();
        } else {
          exist = 0;
          update();
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print('=======================================');
        print(e);
        print('=======================================');
      }
    }
    return exist;
  }

  Future<void> updateUserDeviceToken() async {
    try {
      await _firebaseMessaging.getToken().then((value) {
        deviceToken = value!;
        _firestore.collection('users').doc(_auth.currentUser!.uid).update({
          'userDeviceToken': deviceToken,
        });
      });
    } catch (err) {
      if (kDebugMode) {
        print('=======================================');
        print(err);
        print('=======================================');
      }
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }
}
