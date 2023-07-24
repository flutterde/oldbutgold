import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oldbutgold/core/models/comment/comment_model.dart';

import 'create_comment_controller.dart';

class CommentsController extends GetxController {
  final CreateCommentController createCommentController =
      Get.put(CreateCommentController());
  final RxBool isLoading = false.obs;
  final RxBool isCommentsEmpty = false.obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<CommentModel> comments = [];
  @override
  void onInit() {
    // TODO: implement onInit
    loadComments(Get.arguments['postId']);
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  Future<void> loadComments(String postId) async {
    try {
      isLoading.toggle();
      final commentsDocs = await _firestore
          .collection('comments')
          .doc(postId)
          .collection('list')
          .orderBy('createdAt', descending: true)
          .get();
      for (var comment in commentsDocs.docs) {
        comments.add(await CommentModel().fromDocSnapshot(doc: comment));
      }

      comments.isEmpty
          ? isCommentsEmpty.value = true
          : isCommentsEmpty.value = false;
      isLoading.toggle();
    } on FirebaseException catch (e) {
      //
      if (kDebugMode) {
        isLoading.toggle();
        Get.snackbar(
          'Error',
          e.message!,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
        );
        print('========= Error ==========');
        print(e);
        print('========= End Report Error ==========');
      }
    }
  }




}