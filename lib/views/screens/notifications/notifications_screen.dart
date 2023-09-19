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
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Obx(() => ctr.isLoading.value
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : (ctr.notifications.isEmpty && !ctr.isLoading.value)
                          ? Center(
                              child: Text('no_notifications'.tr),
                            )
                          : Column(
                              children: [
                                // Container(
                                //   height: 50,
                                //   width: double.infinity,
                                //   color: Colors.purple,
                                //   child: const Center(
                                //     child: Text(
                                //       'Mark all as read',
                                //       style: TextStyle(
                                //         color: Colors.white,
                                //         fontWeight: FontWeight.bold,
                                //       ),
                                //     ),
                                //   ),
                                // ),
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: ctr.notifications.length,
                                  itemBuilder: (context, index) {
                                    final notification = ctr.notifications[index];
                                    return ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          notification.user!.profilePic!,
                                        ),
                                      ),
                                      title: Text(
                                          '${notification.user!.name!} ${'commented_on_your_post'.tr}:'),
                                      subtitle:
                                          Text("''${notification.comment}...''"),
                                      trailing: notification.isRead!
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
                ),
              ),
            ));
  }
}
