import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/controllers/profile/other_users_profile_controller.dart';
import '../../../core/models/user/user_model.dart';

class OtherUsersProfile extends GetWidget {
  const OtherUsersProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: OtherUsersProfileController(),
        builder: (ctr) {
          var user = ctr.user;
          return Obx(() => ctr.isLoading.value 
          ? const CircularProgressIndicator() 
          : (!ctr.isLoading.value && user == null) 
          ? const Center(child: Text('User not Exist'),) : Scaffold(
            appBar: AppBar(
              title: Text(user!.name!),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    otherUserProfileCard(ctr.user!),
                    const SizedBox(height: 10),
                    const Divider(),
                    const SizedBox(height: 10),
                    const Text(
                      'Posts:',
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.start,
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ));
        });
  }
}

Widget otherUserProfileCard(UserModel user) {
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
        Text(
          user.bio!,
          style: const TextStyle(
            fontSize: 15,
          ),
        ),
      ],
    ),
  );
}
