import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/post/post_model.dart';
import '../../models/user/user_model.dart';
import '../follow/follow_controller.dart';

class OtherUsersProfileController extends GetxController {
  final FollowController followCtr = Get.put(FollowController());
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String get currentUserId => _auth.currentUser!.uid;
  RxBool isLoading = false.obs;
  UserModel? user;
  String? userUid;

  final int _perPage = 10;
  RxBool isLoadingPosts = false.obs;
  List<PostModel> posts = [];

  RxBool isLoadingMore = false.obs;
  DocumentSnapshot? _lastDocument;
  @override
  void onInit() {
    handle();
    user = Get.arguments['user'];
    fetchPosts(user!.id!);
    super.onInit();
  }

  void handle() {
    if (Get.parameters['id'] != null) {
      userUid = Get.parameters['id'];
      fetchUserData(userUid!);
    } else {
      print('===============================================');
      print('===============   NO USER ID =====================');
      print('===============================================');
    }
  }

  Future<void> fetchUserData(String uid) async {
    try {
      isLoading.value = true;
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();
      user = await UserModel().fromDocumentSnapshot(documentSnapshot: doc);
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      print('===============================================');
      print('===============   ERROR =====================');
      print(e);
      print('===============================================');
      Get.snackbar(
        'error'.tr,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      );
    }
  }

  Future<void> fetchPosts(String uId) async {
    if (kDebugMode) {
      print('=====================');
      print('fetching posts.......');
      print('======================');
    }
    try {
      isLoadingPosts.value = true;
      final postsDocs = await _firestore
          .collection('posts')
          .where('is_ready', isEqualTo: true)
          .where('audience', isEqualTo: 'public')
          .where('user_id', isEqualTo: uId)
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
      }
      _lastDocument = postsDocs.docs.last;
      isLoadingPosts.value = false;
    } on FirebaseException catch (e) {
      isLoadingPosts.toggle();
      Get.snackbar(
        'error'.tr,
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

  Future<void> getMorePosts(String uId) async {
    try {
      isLoadingMore.value = true;
      if (kDebugMode) {
        print('=====================');
        print('Start Loading more posts .......');
        print('======================');
      }
      //
      final data = await _firestore
          .collection('posts')
          .where('is_ready', isEqualTo: true)
          .where('audience', isEqualTo: 'public')
          .where('user_id', isEqualTo: uId)
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
      isLoadingMore.value = false;
    } catch (e) {
      isLoadingMore.value = false;
      if (kDebugMode) {
        print('=====================');
        print(e);
        print('======================');
      }
      Get.snackbar(
        'error'.tr,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      );
    }
  }
}
