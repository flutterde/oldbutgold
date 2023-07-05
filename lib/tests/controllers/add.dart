import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddCtrTest extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    var user = _auth.currentUser;
    print('===============');
    print(user!.uid);
    print('===============');
  }

  Future<void> login() async {
    try {
      await _auth.signInAnonymously().then((value) {
        print(value.user!.uid);
        Get.snackbar(
          'Login',
          'Success',
          backgroundColor: Colors.green,
          snackPosition: SnackPosition.BOTTOM,
        );
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> addTest() async {
    var user = _auth.currentUser;
    try {
      for (int i = 0; i <= 44; i++) {
        await _firestore.collection('tests').add({
          'user': _firestore.collection('users').doc(user!.uid),
          'content': 'Test Post Content Number  $i',
        });
        print('object $i Done');
      }
      Get.snackbar(
        'Add Test',
        'Success',
        backgroundColor: Colors.green,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print(e);
    }
  }


}
