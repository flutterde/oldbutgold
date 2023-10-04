import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oldbutgold/core/models/post/post_model.dart';

import '../reports/post_report_controller.dart';

class SinglePostWdController extends GetxController {
  final PostReportController postReportCtr = Get.put(PostReportController());
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String get currentUserId => _auth.currentUser!.uid;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  PostModel? post;
  RxBool isLoading = false.obs;
  RxBool noPostFound = false.obs;

  @override
  void onInit() {
    var pageId = Get.parameters['id'];
    printf(pageId, 'ID');
    fetchPost(pageId!);
    super.onInit();
  }

  Future<void> fetchPost(String uid) async {
    _firestore.settings = const Settings(persistenceEnabled: false);
    try {
      isLoading.value = true;
      final postDoc = await _firestore.collection('posts').doc(uid).get();
      if (postDoc.exists) {
        printf(postDoc.id, 'post id');
        post = await PostModel().fromDocSnapshot(doc: postDoc);
      } else {
        noPostFound.value = true;
      }
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      noPostFound.value = true;
      printf(e.toString(), 'fetch Error');
    }
  }

  Future<void> reportPost(String postId) async {
    await postReportCtr
        .reportPost(postId)
        .then((value) => Get.snackbar(
              'report'.tr,
              'post_has_been_reported'.tr,
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
            ))
        .catchError(
          (e) => Get.snackbar(
            'error'.tr,
            e.toString(),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
          ),
        );
  }

  Future<void> likePost(PostModel post) async {
    try {
      if (post.isLiked! == true) {
        await _firestore
            .collection('posts')
            .doc(post.id)
            .collection('likes')
            .doc(_auth.currentUser!.uid)
            .delete();

        post.likesCount = post.likesCount! - 1;
        post.isLiked = false;
        update();
      } else {
        await _firestore
            .collection('posts')
            .doc(post.id)
            .collection('likes')
            .doc(_auth.currentUser!.uid)
            .set({
          'user_id': _auth.currentUser!.uid,
          'user': _firestore.collection('users').doc(_auth.currentUser!.uid),
          'post_id': post.id,
          'post': _firestore.collection('posts').doc(post.id),
          'createdAt': FieldValue.serverTimestamp(),
          'type': 'post',
        });
        post.likesCount = post.likesCount! + 1;
        post.isLiked = true;
        update();
      }
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
      );
    }
  }

  void printf(String? text, String? title) {
    if (kDebugMode) {
      print('========= $title ============');
      print(text);
      print('=====================');
    }
  }
}
