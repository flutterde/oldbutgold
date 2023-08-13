import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostReportController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  RxBool isLoading = false.obs;

  Future<void> reportPost(String postId) async {
    try {
      isLoading.value = true;
      //
      var user = _auth.currentUser;
      var userId = user!.uid;
      await _firestore.collection('pt').doc(postId).collection('reports').doc(userId).set({
        'userId': userId,
        'post': _firestore.collection('pt').doc(postId),
        'user': _firestore.collection('users').doc(userId),
        'postId': postId,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'status': 'pending',
        'is_reviewed': false,
      });
      isLoading.value = false;
      Get.back();
      Get.snackbar(
        'success'.tr,
        'post_reported_successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
      );
    } on FirebaseException catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'error'.tr,
        'something_went_wrong_try_again_later',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
      );
      //
      if (kDebugMode) {
        print('========= Error ==========');
        print(e);
        print('========= End Report Error ==========');
      }
    }
  }
}
