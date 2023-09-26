import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/controllers/profile/other_users_profile_controller.dart';
import '../../../core/models/user/user_model.dart';
import 'followers_following_widget.dart';

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
                  ? const Center(
                      child: Text('User not Exist'),
                    )
                  : Scaffold(
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
                              otherUserProfileCard(ctr.user!, ctr),
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

Widget otherUserProfileCard(UserModel user, OtherUsersProfileController ctr) {
  final fCtr = ctr.followCtr;
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
            Obx(() => (!fCtr.isLoading.value)
                ? followesFollowingWidget(
                    followersCount: user.followersCount!,
                    followingCount: user.followingCount!,
                  )
                : const CircularProgressIndicator()),
          ],
        ),
        const SizedBox(
          height: 10,
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
        Text(
          user.bio!,
          style: const TextStyle(
            fontSize: 14,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        ElevatedButton(
            onPressed: () {
              (!fCtr.isLoading.value)
                  ? fCtr.handleFollowUser(
                      user: user,
                      isFollow: user.isFollowing!,
                    )
                  : null;
            },
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.deepPurple),
            ),
            child: SizedBox(
                width: double.infinity,
                child: Obx(
                  () => Text(
                    (fCtr.isLoading.value)
                        ? 'Wait...'
                        : (user.isFollowing! && !fCtr.isLoading.value)
                            ? 'Unfollow'
                            : 'Follow',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white),
                  ),
                ))),
      ],
    ),
  );
}
