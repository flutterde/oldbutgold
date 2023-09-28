import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/controllers/notifications/notifications_screen_controller.dart';
import '../../../core/models/notification/notification_model.dart';

class NotificationsScreen extends GetWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: NotificationsScreenController(),
        builder: (ctr) => Scaffold(
              appBar: AppBar(
                title: Text('notifications'.tr),
                centerTitle: true,
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
                                    final notification =
                                        ctr.notifications[index];
                                    return GestureDetector(
                                      onTap: () {
                                        if (notification.type ==
                                            NotificationType.comment) {
                                          Get.toNamed('/main/comments',
                                              arguments: {
                                                'postId': notification.postId!,
                                                'postOwner':
                                                    notification.postOwnerId!,
                                              });
                                          ctr.updateNotificationStatus(
                                              notification: notification);
                                        } else if (notification.type ==
                                            NotificationType.follow) {
                                          if (kDebugMode) {
                                            print(
                                                '========= Notification ==========');
                                            print('Type follow');
                                            print(
                                                '========= End Notification Type ==========');
                                          }
                                          {
                                            Get.toNamed(
                                              '/users/profile',
                                              arguments: {
                                                'user': notification.user,
                                                'carrentUser':
                                                    ctr.currentUserUId,
                                              },
                                            );
                                            ctr.updateFollowNotificationStatus(
                                                notification: notification);
                                          }
                                        }
                                      },
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                            notification.user!.profilePic!,
                                          ),
                                        ),
                                        title: Text(handleNotificationText(
                                            notification,
                                            notification.type!,
                                            true)),
                                        subtitle: Text(handleNotificationText(
                                            notification,
                                            notification.type!,
                                            false)),
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

String handleNotificationText(
    NotificationModel notification, NotificationType type, bool isTitle) {
  if (type == NotificationType.comment) {
    if (isTitle) {
      return '${notification.user!.name!} ${'commented_on_your_post'.tr}:';
    } else {
      return "''${notification.comment!.substring(0, notification.comment!.length < 20 ? notification.comment!.length : 20)}...''";
    }
  } else if (type == NotificationType.follow) {
    if (isTitle) {
      return '${notification.user!.name!} ${'started_following_you'.tr}';
    } else {
      return 'check_profile'.tr;
    }
  } else {
    return '';
  }
}
