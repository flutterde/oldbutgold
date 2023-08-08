

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/controllers/notifications/notifications_screen_controller.dart';

class NotificationsScreen extends GetWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: NotificationsScreenController(),
      builder: (ctr)=> Scaffold(
        appBar: AppBar(
          title: Text('notifications'.tr),
        ),
      ));
  }
}