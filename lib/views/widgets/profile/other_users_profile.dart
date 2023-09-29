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
                  ? Center(
                      child: Text('user_not_found'.tr),
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
                              Text(
                                'posts'.tr,
                                style: const TextStyle(fontSize: 20),
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
        Obx(
          () => ElevatedButton(
              onPressed: () {
                (!fCtr.isLoading.value)
                    ? fCtr.handleFollowUser(
                        user: user,
                        isFollow: user.isFollowing!,
                      )
                    : null;
              },
              style: ButtonStyle(
                backgroundColor: (!user.isFollowing! &&
                        (!fCtr.isLoading.value || fCtr.isLoading.value))
                    ? MaterialStateProperty.all<Color>(Colors.deepPurple)
                    : MaterialStateProperty.all<Color>(Colors.red),
              ),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  (fCtr.isLoading.value)
                      ? 'wait'.tr
                      : (user.isFollowing! && !fCtr.isLoading.value)
                          ? 'unfollow'.tr
                          : 'follow'.tr,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),
                ),
              )),
        ),
      ],
    ),
  );
}
