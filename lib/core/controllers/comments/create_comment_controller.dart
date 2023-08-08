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



  Future<void> createcomment(String postId, String comment) async {
   try{
    isLoading.toggle();
      //
      await _firestore.collection('pt').doc(postId).collection('comments').add({
        'comment': comment,
        'createdAt': FieldValue.serverTimestamp(),
        'user': _firestore.collection('users').doc(_auth.currentUser!.uid),
        'userId': _auth.currentUser!.uid,
        'postId': postId,
        'post': _firestore.collection('posts').doc(postId),
      });

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
      //
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
 
  

}