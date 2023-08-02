import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oldbutgold/core/models/post/post_model.dart';

import '../../reports/post_report_controller.dart';

class FeedController extends GetxController {
  final PostReportController postReportCtr = Get.put(PostReportController());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  RxBool isLoading = false.obs;
  RxBool isPostsEmpty = false.obs;
  List<PostModel> posts = [];

  // Page content..
  final pageController = PageController();

  Future<void> fetchAllPosts() async {
    if (kDebugMode) {
      print('=====================');
      print('fetching posts.......');
      print('======================');
    }

    try {
      isLoading.value = true;
      final postsDocs = await _firestore
          .collection('pt')
          .where('is_ready', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .limit(10)
          .get();
      if (kDebugMode) {
        print('=====================');
        print('Posts that fetched .......');
        print(postsDocs.docs.length);
        print('======================');
      }
      posts.clear();
      for (var post in postsDocs.docs) {
        posts.add(await PostModel().fromDocSnapshot(doc: post));
        if (kDebugMode) {
          print('======== Lenght =============');
          print(posts.length);
          print('======================');
        }
      }
      posts.isEmpty ? isPostsEmpty.value = true : isPostsEmpty.value = false;

      isLoading.value = false;
    } on FirebaseException catch (e) {
      isLoading.toggle();
      Get.snackbar(
        'Error',
        e.message!,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      );
      if (kDebugMode) {
        print('=====================');
        print(e);
        print('======================');
      }
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

// Todo: Add like post functionality 'test version'

  Future<void> likePost(PostModel post) async {
    try {
      //
      if (post.isLiked! == true) {
        post.likesCount = post.likesCount! - 1;
        post.isLiked = false;
        update();
        await _firestore
            .collection('likes')
            .where('user_id', isEqualTo: _auth.currentUser!.uid)
            .where('post_id', isEqualTo: post.id)
            .get()
            .then((value) => value.docs.first.reference.delete());
      } else {
        post.likesCount = post.likesCount! + 1;
        post.isLiked = true;
        update();

        await _firestore.collection('likes').add({
          'user_id': _auth.currentUser!.uid,
          'user': _firestore.collection('users').doc(_auth.currentUser!.uid),
          'post_id': post.id,
          'post': _firestore.collection('pt').doc(post.id),
          'createdAt': FieldValue.serverTimestamp(),
        });
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

  @override
  void onInit() {
    fetchAllPosts();
    super.onInit();
  }
}
