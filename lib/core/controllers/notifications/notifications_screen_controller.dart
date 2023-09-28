import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../models/notification/notification_model.dart';

class NotificationsScreenController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String get currentUserUId => _auth.currentUser!.uid;
  List<NotificationModel> notifications = [];
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      final querySnapshot = await _firestore
          .collectionGroup('notifications')
          .where('post_owner_id', isEqualTo: _auth.currentUser!.uid)
          .orderBy('created_at', descending: true)
          .limit(10)
          .get();
      for (var item in querySnapshot.docs) {
        if (kDebugMode) {
          print('========= Notification Data ==============');
          print(item.data());
          print('========= End Get Data ==========');
        }
        notifications.add(await NotificationModel().fromDocSnapshot(doc: item));
      }
      isLoading.value = false;
      update();
    } catch (e) {
      isLoading.value = false;
      update();
      if (kDebugMode) {
        print('========= Notification Ctr Error ==============');
        print(e);
        print('========= End Error ==========');
      }
    }
  }

  Future<void> updateNotificationStatus(
      {required NotificationModel notification}) async {
    try {
      await _firestore
          .collection('posts')
          .doc(notification.postId)
          .collection('comments')
          .doc(notification.commentId)
          .collection('notifications')
          .doc(notification.id)
          .update({'is_read': true});
      notification.isRead = true;
      update();
    } catch (e) {
      if (kDebugMode) {
        print('========= Notification Ctr Error ==============');
        print(e);
        print('========= End Error ==========');
      }
    }
  }

  Future<void> updateFollowNotificationStatus(
      {required NotificationModel notification}) async {
        try {
          await _firestore
              .collection('notifications')
              .doc(notification.id)
              .update({'is_read': true});
          notification.isRead = true;
          update();
        } catch (e) {
          if (kDebugMode) {
            print('========= Notification Ctr Error ==============');
            print(e);
            print('========= End Error ==========');
          }
        }
      }
}
