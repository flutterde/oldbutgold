import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/models/user/user_model.dart';
import 'followers_following_widget.dart';

Widget profileCard(UserModel user) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(user.profilePic!),
            ),
            const SizedBox(
              width: 10,
            ),
            followesFollowingWidget(
              followersCount: user.followersCount!,
              followingCount: user.followingCount!,
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Column(
          children: [
            Text(
              user.name!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              textAlign: TextAlign.start,
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Center(
          child: ElevatedButton(
              onPressed: () {
                Get.toNamed('/edit-profile', arguments: {'user': user});
              },
              child: Text('edit_profile'.tr)),
        ),
      ],
    ),
  );
}
