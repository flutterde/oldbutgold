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
          'error'.tr,
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
      title: 'delete_comment'.tr,
      middleText: 'delete_comment_dialog'.tr,
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: Text('cancel'.tr),
        ),
        TextButton(
          onPressed: () async {
            try {
              isDeleting.toggle();
              // Create a batch
              WriteBatch batch = FirebaseFirestore.instance.batch();
              // Reference to the parent comment document
              DocumentReference commentDocRef = FirebaseFirestore.instance
                  .collection('posts')
                  .doc(postId)
                  .collection('comments')
                  .doc(commentId);
                  /* // has been changed to be deleted by cloud function
              // Reference to the subcollection
              CollectionReference subcollectionRef =
                  commentDocRef.collection('notifications');
              // Delete all documents in the subcollection
              QuerySnapshot subcollectionSnapshot =
                  await subcollectionRef.get();
              // ignore: avoid_function_literals_in_foreach_calls
              subcollectionSnapshot.docs.forEach((doc) {
                batch.delete(subcollectionRef.doc(doc.id));
              });
              */
              batch.delete(commentDocRef);
              await batch.commit();
              Get.back();
              isDeleting.toggle();
              Get.snackbar(
                'success'.tr,
                'comment_deleted_successfully'.tr,
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
              );
              comments.removeWhere((element) => element.id == commentId);
              update();
            } on FirebaseException catch (e) {
              Get.back();
              Get.snackbar(
                'error'.tr,
                e.message!,
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red,
              );
            }
          },
          child: Obx(() => isDeleting.value
              ? Text('deleting'.tr)
              : Text('delete'.tr)),
        ),
      ],
      radius: 10,
    );
  }
}
