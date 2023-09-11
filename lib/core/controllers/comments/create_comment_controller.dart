import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateCommentController extends GetxController{
  RxBool isLoading = false.obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;


  final TextEditingController commentCtr = TextEditingController();
  final formKey = GlobalKey<FormState>();



  Future<void> createcomment(String postId, String comment, String postOwner) async {
   try{
    isLoading.toggle();
      //
      var comm = await _firestore.collection('pt').doc(postId).collection('comments').add({
        'comment': comment,
        'createdAt': FieldValue.serverTimestamp(),
        'user': _firestore.collection('users').doc(_auth.currentUser!.uid),
        'userId': _auth.currentUser!.uid,
        'postId': postId,
        'post': _firestore.collection('posts').doc(postId),
      });
      await createNotification(postId, comm.id, comment, _auth.currentUser!.uid, postOwner);
      commentCtr.clear();
      isLoading.toggle();
      Get.back();
      Get.snackbar(
        'Success',
        'Comment created successfully',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
      );
    }  on FirebaseException catch(e){
      if(kDebugMode){
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
 

 Future<void> createNotification(String postId, String commentId, String comment, String userId, String postOwnerId)
 async {
    try{
     await _firestore.collection('pt').doc(postId).collection('comments')
      .doc(commentId).collection('notifications').add({
        'createdAt': FieldValue.serverTimestamp(),
        'type': 'comment',
        'comment': comment,
        'commentId': commentId,
        'postId': postId,
        'post': _firestore.collection('pt').doc(postId),
        'user': _firestore.collection('users').doc(userId),
        'userId': userId,
        'postOwnerId': postOwnerId,
        'postOwner': _firestore.collection('users').doc(postOwnerId),
      });
    } on FirebaseException catch(e){
      if(kDebugMode){
        print('========= Error ==========');
        print(e);
        print('========= End Notification Error ==========');
      }
    }
 }
  

}