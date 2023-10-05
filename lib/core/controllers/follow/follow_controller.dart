import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:oldbutgold/core/models/user/user_model.dart';

class FollowController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String get currentUserId => _auth.currentUser!.uid;
  RxBool isLoading = false.obs;

  Future<void> handleFollowUser(
      {required UserModel user, required bool isFollow}) async {
    try {
      isLoading.value = true;
      if (!isFollow) {
        await _following(user.id!);
        await _follower(user.id!);
        await createNotification(currentUserId, user.id!);
        user.followersCount = user.followersCount! + 1;
        user.isFollowing = true;
      } else {
        await _deleteFollowing(user.id!);
        await _deleteFollower(user.id!);
        user.followersCount = user.followersCount! - 1;
        user.isFollowing = false;
      }
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      print('==================== ERR ========================');
      print(e);
      print('========================ER   ====================');
    }
  }

  Future<void> _following(String other) async {
    await _firestore
        .collection('following')
        .doc(currentUserId)
        .collection('following_list')
        .doc(other)
        .set({
      'userId': other,
      'created_at': FieldValue.serverTimestamp(),
      'user': _firestore.collection('users').doc(other),
    });
  }

  Future<void> _follower(String other) async {
    await _firestore
        .collection('followers')
        .doc(other)
        .collection('following_list')
        .doc(currentUserId)
        .set({
      'userId': currentUserId,
      'created_at': FieldValue.serverTimestamp(),
      'user': _firestore.collection('users').doc(currentUserId),
    });
  }

  Future<void> _deleteFollowing(String other) async {
    await _firestore
        .collection('following')
        .doc(currentUserId)
        .collection('following_list')
        .doc(other)
        .delete();
  }

  Future<void> _deleteFollower(String other) async {
    await _firestore
        .collection('followers')
        .doc(other)
        .collection('following_list')
        .doc(currentUserId)
        .delete();
  }

  Future<void> createNotification(
    String followerId, // the one who follow (me / current user)
    String followingId, // the one who is followed (other user)
    ) async {
    try {
      await _firestore.collection('notifications').add({
        'created_at': FieldValue.serverTimestamp(),
        'type': 'follow',
        'comment': null,
        'commentId': null,
        'is_read': false,
        'post_id': null,
        'post': null,
        'user': _firestore.collection('users').doc(followerId),
        'user_id': followerId,
        'post_owner_id': followingId,
        'post_owner': _firestore.collection('users').doc(followingId),
      });
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print('========= Error ==========');
        print(e);
        print('========= End Notification Error ==========');
      }
    }
  }
}
