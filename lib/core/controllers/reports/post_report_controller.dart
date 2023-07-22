import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class PostReportController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;


  Future<void> reportPost(String postId) async {
    try{
      //
      var user = _auth.currentUser;
      var userId = user!.uid;
      await _firestore.collection('reports').add({
        'userId': userId,
        'post': _firestore.collection('posts').doc(postId),
        'user': _firestore.collection('users').doc(userId),
        'postId': postId,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseException catch(e){
      //
      if(kDebugMode){
        print('========= Error ==========');
        print(e);
        print('========= End Report Error ==========');
      }
    }
  }
}
