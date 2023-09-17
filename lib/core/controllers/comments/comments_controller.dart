// ignore_for_file: unnecessary_overrides

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

  String get currentUserId => _auth.currentUser!.uid;
  RxBool isDeleting = false.obs;

  List<CommentModel> comments = [];
  @override
  void onInit() {
    loadComments(Get.arguments['postId']);
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> loadComments(String postId) async {
    try {
      isLoading.toggle();
      final commentsDocs = await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
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

  void deleteComment(String commentId, String postId) {
    Get.defaultDialog(
      title: 'Delete Comment',
      middleText: 'Are you sure you want to delete this comment?',
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            try {
              isDeleting.toggle();
              await _firestore
                  .collection('posts')
                  .doc(postId)
                  .collection('comments')
                  .doc(commentId)
                  .delete()
                  .then((value) {
                Get.back();
                isDeleting.toggle();
                Get.snackbar(
                  'success'.tr,
                  'Comment deleted successfully',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green,
                );
                comments.removeWhere((element) => element.id == commentId);
                update();
              });
            } on FirebaseException catch (e) {
              Get.back();
              Get.snackbar(
                'Error',
                e.message!,
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red,
              );
            }
          },
          child: Obx(() => isDeleting.value
              ? const Text('Deleting...')
              : const Text('Delete')),
        ),
      ],
      radius: 10,
    );
  }
}
