import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/models/user/user_model.dart';

Widget profileCard(UserModel user) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(user.profilePic!),
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        ElevatedButton(onPressed: () {
          Get.toNamed('/edit-profile', arguments: {'user': user});
        }, child: Text('Edit Profile'.tr)),
      ],
    ),
  );
}
