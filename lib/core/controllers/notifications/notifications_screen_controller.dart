import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../models/notification/notification_model.dart';

class NotificationsScreenController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<NotificationModel> notifications = [];
  bool isLoading = false;

  @override
  void onInit() {
    super.onInit();
   // fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    try {
      isLoading = true;
      final querySnapshot = await _firestore
          .collectionGroup('notifications')
          //.where('user_id', isEqualTo: _auth.currentUser!.uid)
          .orderBy('created_at', descending: true).limit(1)
          .get();
      for (var item in querySnapshot.docs) {
              if (kDebugMode)
      {
        print('========= Notification Data ==============');
        print(item.data());
        print('========= End Get Data ==========');
      }
        notifications.add(await NotificationModel().fromDocSnapshot(doc: item));
      }
      isLoading = false;
      update();
    } catch (e) {
      isLoading = false;
      update();
      if (kDebugMode)
      {
        print('========= Notification Ctr Error ==============');
        print(e);
        print('========= End Error ==========');
      }
    }
  }
}
