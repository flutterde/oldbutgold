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

  // ignore: prefer_final_fields
  int _perPage = 10;
  RxBool isLoadingMore = false.obs;
  DocumentSnapshot? _lastDocument;

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
          .where('audience', isEqualTo: 'public')
          .orderBy('createdAt', descending: true)
          .limit(_perPage)
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
      _lastDocument = postsDocs.docs.last;
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

  Future<void> getMorePosts() async {
    try {
      isLoadingMore.value = true;
      if (kDebugMode) {
        print('=====================');
        print('Start Loading more posts .......');
        print('======================');
      }
      //
      final data = await _firestore
          .collection('pt')
          .where('is_ready', isEqualTo: true)
          .where('audience', isEqualTo: 'public')
          .orderBy('createdAt', descending: true)
          .startAfter([_lastDocument?['createdAt']])
          .limit(_perPage)
          .get();

      for (var item in data.docs) {
        if (kDebugMode) {
          print('=====================');
          print('Start passing  posts to model .......');
          print('======================');
        }
        posts.add(await PostModel().fromDocSnapshot(doc: item));
        _lastDocument = data.docs.last;
        update();
        if (kDebugMode) {
          print('======== Lenght =============');
          print(posts.length);
          print('======================');
        }
      }
      
    } catch (e) {
      if (kDebugMode) {
        print('=====================');
        print(e);
        print('======================');
      }
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      );
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
        await _firestore
            .collection('pt')
            .doc(post.id)
            .collection('likes')
            .doc(_auth.currentUser!.uid)
            .delete();

        post.likesCount = post.likesCount! - 1;
        post.isLiked = false;
        update();
      } else {
        await _firestore
            .collection('pt')
            .doc(post.id)
            .collection('likes')
            .doc(_auth.currentUser!.uid)
            .set({
          'user_id': _auth.currentUser!.uid,
          'user': _firestore.collection('users').doc(_auth.currentUser!.uid),
          'post_id': post.id,
          'post': _firestore.collection('pt').doc(post.id),
          'createdAt': FieldValue.serverTimestamp(),
          'type': 'like',
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

  @override
  void onInit() {
    fetchAllPosts();
    super.onInit();
  }
}
