// ignore_for_file: unnecessary_overrides

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class RegisterAuthController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  //
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final dbUserssRef = FirebaseDatabase.instance.ref().child('users');

  //
  String getLocationApiUrl = 'https://freeipapi.com/api/json';
  String? countryName;
  String? countryCode;
  String? city;
  String? regionName;
  String? userIpAddress;

  String userDeviceToken = '';
  RxString? gender = 'male'.obs;


  RxBool isLoading = false.obs;
  RxBool isPasswordVisible = false.obs;

  @override
  void onClose() {
    super.onClose();
  }

  @override
  void onInit() async {
    await FirebaseAuth.instance
        .setLanguageCode(Get.locale?.languageCode ?? 'en');
    _getUserDevToken();
    getUserLocation();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  Future<void> registerNewUser() async {
    try {
      isLoading.value = true;
      await _auth
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((value) async {
        await storeUserData(nameController.text, '', emailController.text,
            value, value.user!.uid, gender!.value);
        await value.user!.sendEmailVerification().then((value) async {
          Get.snackbar(
            'success'.tr,
            'please_check_your_email_to_verify_your_account'.tr,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 6),
          );
          await _auth.signOut();
          Get.toNamed('/auth/login');
        });
      });
      isLoading.value = false;
      emailController.clear();
      passwordController.clear();
      nameController.clear();
    } catch (err) {
      isLoading.value = false;
      if (kDebugMode) {
        print('=========ERROR=========');
        print(err);
        print('=========ERROR=========');
      }
      Get.snackbar(
        'Error',
        err.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
    );
  }
}

  Future<void> registerWithGoogle() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      isLoading.value = true;
      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await auth.signInWithCredential(credential).then((value) async {
        var id = value.user!.uid;
        await storeUserData(
            value.user!.displayName!, '', value.user!.email!, value, id, '');
      });
      isLoading.value = false;
      Get.offAllNamed('/mains');
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

  Future<void> storeUserData(String name, String? username, String email,
      UserCredential _user, String _userUid, String userGender) async {
    await _firestore.collection('users').doc(_user.user!.uid).set({
      'name': name.toLowerCase(),
      'username': username?.toLowerCase(),
      'email': email.toLowerCase(),
      'userDeviceToken': userDeviceToken,
      'userRole': 'user',
      'user_account_status': 'active',
      'created_at': FieldValue.serverTimestamp(),
      'user_gender': userGender.toLowerCase(),
      'user_data': {
        'countryName': countryName,
        'countryCode': countryCode,
        'city': city,
        'regionName': regionName,
        'userIpAddress': userIpAddress,
        'userProviderId': _user.user!.providerData[0].providerId,
        'userUid': _user.user!.uid,
        'userPhoneNumber': _user.user!.phoneNumber,
        'userPhotoUrl': _user.user!.photoURL,
        'userCreationTime': _user.user!.metadata.creationTime,
        'userLastSignInTime': _user.user!.metadata.lastSignInTime,
      },
      'profile_photo_url': 'data/images/defaults/avatar.png',
      'profile': {
        'is_profile_verified': false,
        'profile_bio': '',
      },
      'user_social_links': {
        'facebook': '',
        'twitter': '',
        'instagram': '',
        'youtube': '',
        'linkedin': '',
        'website': '',
        'github': '',
        'email': '',
      },
      'wallet': {
        'diamond': 5,
        'obg_coin': 20,
      },
    }).then((value) async {
      await storeUserMetadata(_userUid);
    });
  }

  Future<void> storeUserMetadata(String userUid) async {
    try {
      await dbUserssRef.child(userUid).set({
        'is_online': 0,
        'is_typing': 0,
        'last_seen': ServerValue.timestamp,
        'is_recording': 0,
        'conversation_id': 'null',
      });
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        if (kDebugMode) {
          print('==========================================================');
          print('User does not have permission to create this post.');
          print('==========================================================');
        }
      } else {
        if (kDebugMode) {
          print('==========================================================');
          print(e);
          print('==========================================================');
        }
      }
    }
  }

  Future<void> getUserLocation() async {
    try {
      Dio dio = Dio();
      await dio.get(getLocationApiUrl).then((value) async {
        if (value.data['country'] == null) {
          await dio.get('http://ip-api.com/json').then((value) {
            countryName = value.data['country'] ?? 'null';
            countryCode = value.data['countryCode'] ?? 'null';
            city = value.data['city'] ?? 'null';
            regionName = value.data['regionName'] ?? 'null';
            userIpAddress = value.data['query'] ?? 'null';
            update();
          });
        } else {
          countryName = value.data['countryName'] ?? 'null';
          countryCode = value.data['countryCode'] ?? 'null';
          city = value.data['cityName'] ?? 'null';
          regionName = value.data['regionName'] ?? 'null';
          userIpAddress = value.data['ipAddress'] ?? 'null';
          update();
        }
      });
    } catch (err) {
      if (kDebugMode) {
        print('=========ERROR=========');
        print(err);
        print('=========ERROR=========');
      }
    }
  }

  Future<void> policyAgree() async {
    var policyUrl =
        Uri.parse('https://old-butgold.web.app/p/privacy-policy.html');
    await launchUrl(policyUrl);
  }

  _getUserDevToken() async {
    await _firebaseMessaging.getToken().then((token) {
      userDeviceToken = token.toString();
    });
  }
}
