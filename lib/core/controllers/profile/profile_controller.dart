import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oldbutgold/core/models/user/user_model.dart';

import '../../models/post/post_model.dart';

class ProfileConntroller extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel? user;
  List<PostModel> posts = [];
  RxBool isPostsLoading = false.obs;
  RxBool isLoading = false.obs;

  final int _perPage = 10;
  RxBool isLoadingMore = false.obs;
  DocumentSnapshot? _lastDocument;

  @override
  void onInit() {
    userData();
    fetchUserPosts();
    super.onInit();
  }

  Future<void> userData() async {
    try {
      isLoading.value = true;
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get()
          .then((value) {
        user = UserModel.fromDocumentSnapshot(documentSnapshot: value);
      });
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      if (kDebugMode) {
        print('==================== ERROR  ====================');
        print(e);
        print('==================== END ERROR  ====================');
      }
    }
  }

  Future<void> fetchUserPosts() async {
    try{
      isPostsLoading.value = true;
      final postsDocs = await _firestore
          .collection('posts')
          .where('is_ready', isEqualTo: true)
          .where('user_id', isEqualTo: _auth.currentUser!.uid)
          .orderBy('createdAt', descending: true)
          .limit(_perPage)
          .get();
      posts.clear();
      for (var post in postsDocs.docs) {
        posts.add(await PostModel().fromDocSnapshot(doc: post));
      }
      _lastDocument = postsDocs.docs.last;
      isPostsLoading.value = false;
    } catch (e) {
      isPostsLoading.value = false;
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
      );
      if (kDebugMode) {
        print('==================== ERROR  ====================');
        print(e);
        print('==================== END ERROR  ====================');
      }
    }
  }

    Future<void> getMoreUserPosts() async {
    try {
      isLoadingMore.value = true;
      final data = await _firestore
          .collection('posts')
          .where('is_ready', isEqualTo: true)
          .where('user_id', isEqualTo: _auth.currentUser!.uid)
          .orderBy('createdAt', descending: true)
          .startAfter([_lastDocument?['createdAt']])
          .limit(_perPage)
          .get();
      for (var item in data.docs) {
        posts.add(await PostModel().fromDocSnapshot(doc: item));
        _lastDocument = data.docs.last;
        update();
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
}
