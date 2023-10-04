import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/controllers/profile/profile_controller.dart';
import 'profile_card.dart';
import 'package:timeago/timeago.dart' as timeago;

class ProfileScreen extends GetWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: Get.put(ProfileConntroller(), permanent: false),
        builder: (ctr) {
          return Scaffold(
            appBar: AppBar(
              title: Text('profile'.tr),
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () {
                    Get.toNamed('/profile/actions');
                  },
                  icon: const Icon(Icons.grid_3x3_sharp),
                ),
              ],
            ),
            body: Obx(() => ctr.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () async {
                      await Future.delayed(const Duration(seconds: 1));
                      ctr.userData();
                      ctr.fetchUserPosts();
                    },
                    backgroundColor: Colors.deepPurple,
                    color: Colors.white,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            profileCard(ctr.user!),
                            const SizedBox(height: 10),
                            const Divider(),
                            const SizedBox(height: 10),
                            Text(
                              'posts'.tr,
                              style: const TextStyle(fontSize: 20),
                              textAlign: TextAlign.start,
                            ),
                            const SizedBox(height: 10),
                            Obx(() => ctr.isPostsLoading.value
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : (ctr.posts.isEmpty &&
                                        !ctr.isPostsLoading.value)
                                    ? Center(
                                        child: Text('no_post_to_display'.tr),
                                      )
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: ctr.posts.length,
                                        itemBuilder: (context, index) {
                                          if (index == ctr.posts.length - 3) {
                                            ctr.getMoreUserPosts();
                                          }
                                          var post = ctr.posts[index];
                                          return GestureDetector(
                                            onTap: () {
                                              Get.toNamed(
                                                  '/p/${post.id}');
                                            },
                                            child: ListTile(
                                              title: Text(post.description!),
                                              subtitle: Row(
                                                children: [
                                                  Text(
                                                    timeago.format(
                                                      post.createdAt!.toDate(),
                                                      locale: Get
                                                          .locale!.languageCode,
                                                    ),
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey[600],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              trailing: IconButton(
                                                onPressed: () {
                                                  ctr.deleteThePost(post);
                                                },
                                                icon: const Icon(
                                                    Icons.delete_outline_rounded),
                                              ),
                                            ),
                                          );
                                        },
                                      )),
                          ],
                        ),
                      ),
                    ),
                  )),
          );
        });
  }
}
