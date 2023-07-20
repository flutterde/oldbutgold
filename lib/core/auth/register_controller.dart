// ignore_for_file: unnecessary_overrides

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' hide Category;
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

  //
  RxBool isLoading = false.obs;

  @override
  void onClose() {
    super.onClose();
  }

  @override
  void onInit() {
    print('============== Time =======================');
    print('t');
    print('=====================================');

    _getUserDevToken();
    getUserLocation();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  // register user
  Future<void> registerNewUser() async {
    // time
    try {
      isLoading.value = true;
      await _auth
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .then((value) async {
        await _firestore.collection('users').doc(value.user!.uid).set({
          'name': nameController.text.toLowerCase(),
          'email': emailController.text.toLowerCase(),
          'userDeviceToken': userDeviceToken,
          'userRole': 'user',
          'user_account_status': 'active',
          'created_at': FieldValue.serverTimestamp(),
          'user_data': {
            'countryName': countryName,
            'countryCode': countryCode,
            'city': city,
            'regionName': regionName,
            'userIpAddress': userIpAddress,
            'userProviderId': value.user!.providerData[0].providerId,
            'userUid': value.user!.uid,
            // 'userEmailVerified': value.user!.emailVerified,
            'userPhoneNumber': value.user!.phoneNumber,
            'userPhotoUrl': value.user!.photoURL,
            'userCreationTime': value.user!.metadata.creationTime,
            'userLastSignInTime': value.user!.metadata.lastSignInTime,
          },
          'profile': {
            'is_profile_verified': false,
            'profile_bio': '',
            'profile_photo_url': 'data/images/defaults/avatar.png',
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
        });
        await storeUserMetadata(value.user!.uid);
        await value.user!.sendEmailVerification().then((value) async {
          Get.snackbar(
            'Success',
            'Please check your email to verify your account',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 4),
          );
          await _auth.signOut();
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

  // get country name and country code from api using dio package
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
          //
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
        Uri.parse('https://plf-app.blogspot.com/p/privecy-policy.html');
    // open webview using url launcher
    await launchUrl(policyUrl);
  }

  // Get the token, of the current user
  _getUserDevToken() async {
    await _firebaseMessaging.getToken().then((token) {
      userDeviceToken = token.toString();
    });
  }
}
