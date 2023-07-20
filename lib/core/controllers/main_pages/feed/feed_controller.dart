import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oldbutgold/core/models/post/post_model.dart';

class FeedController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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
          .collection('posts')
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

  @override
  void onInit() {
    fetchAllPosts();
    super.onInit();
  }
}
