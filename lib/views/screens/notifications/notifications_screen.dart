import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/controllers/notifications/notifications_screen_controller.dart';

class NotificationsScreen extends GetWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: NotificationsScreenController(),
        builder: (ctr) => Scaffold(
              appBar: AppBar(
                title: Text('notifications'.tr),
              ),
              body: SingleChildScrollView(
                  child: ctr.isLoading
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ctr.notifications.isNotEmpty
                          ? Center(
                              child: Text('no_notifications'.tr),
                            )
                          : Column(
                              children: [
                                Container(
                                  height: 50,
                                  width: double.infinity,
                                  color: Colors.purple,
                                  child: const Center(
                                    child: Text(
                                      'Mark all as read',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: 34 /*ctr.notifications.length*/,
                                  itemBuilder: (context, index) {
                                    // final notification = ctr.notifications[index];
                                    return ListTile(
                                      leading: const CircleAvatar(
                                          // backgroundImage: NetworkImage(
                                          //   /*notification.user!.profilePic! */,
                                          // ),
                                          ),
                                      title: Text(
                                          'User name ${index + 1}' /*notification.user!.username! */),
                                      subtitle: const Text(
                                          'hfd hdgh dgh sd' /*notification.comment! */),
                                      trailing: index % 2 ==
                                              0 /*notification.isRead! */
                                          ? const SizedBox.shrink()
                                          : Container(
                                              height: 10,
                                              width: 10,
                                              decoration: const BoxDecoration(
                                                color: Colors.red,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      const Divider(),
                                ),
                              ],
                            )),
            ));
  }
}
