import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnnouncementsScreen extends StatelessWidget {
  const AnnouncementsScreen({super.key});


  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('NotificationAnnouncementPage ============================');
      print(Get.arguments);
      print('NotificationAnnouncementPage ============================');
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Announcement'.tr),
      ),
      body: Center(
        child: Text(Get.arguments['body'] ?? 'No Announcement'),
      ),
    );
  }
}