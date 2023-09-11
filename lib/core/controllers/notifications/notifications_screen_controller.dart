import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../models/notification/notification_model.dart';

class NotificationsScreenController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<NotificationModel> notifications = [];

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      final querySnapshot = await _firestore
          .collectionGroup('notifications')
          .where('post_owner', isEqualTo: _auth.currentUser!.uid)
          .orderBy('created_at', descending: true)
          .get();
      for (var item in querySnapshot.docs) {
        notifications.add(await NotificationModel().fromDocSnapshot(doc: item));
      }
      update();
    } catch (e) {
      if (kDebugMode)
      {
        print('========= Error ==============');
        print(e);
        print('========= End Error ==========');
      }
    }
  }
}
