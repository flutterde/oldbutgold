import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oldbutgold/core/models/post/post_model.dart';

class SinglePostController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  RxBool isLoading = false.obs;
  RxBool isPostsEmpty = false.obs;

  PostModel post = PostModel();

  @override
  void onInit() {
    // TODO: implement onInit
    loadPost(Get.parameters['postId'] ?? '');
    super.onInit();
  }

  Future<void> loadPost(String id) async {
    try {
      //   //
      isLoading.value = true;
      var data = await _firestore.collection('posts').doc(id).get();
      if (data.exists) {
        isPostsEmpty.value = false;
        post = await PostModel().fromDocSnapshot(doc: data);
      } else {
        isPostsEmpty.value = true;
        Get.snackbar('error'.tr, 'post_not_found'.tr);
      }

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      if (kDebugMode) {
        print('=====================');
        print('Error in updateUserData: $e');
        print('=====================');
      }

      Get.snackbar('error'.tr, 'error_while_loading_post'.tr);
    }
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
}
