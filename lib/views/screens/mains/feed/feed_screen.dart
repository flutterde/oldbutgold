import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/controllers/main_pages/feed/feed_controller.dart';

class FeedScreen extends GetWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: FeedController(),
        builder: (ctr) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Feed'),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.logout),
                )
              ],
            ),
            body: Obx(
              () => ctr.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : ctr.isPostsEmpty.value
                      ? const Center(
                          child: Text('No Post to display'),
                        )
                      : PageView.builder(
                          scrollDirection: Axis.vertical,
                          controller: ctr.pageController,
                          itemCount: ctr.posts.length,
                          itemBuilder: (context, index) {
                            var post = ctr.posts[index];
                            return Stack(
                              children: [
                                // video
                                /*
                                VideoPlayerWidget(
                                  videoUrl: post.videoUrl!,
                                  postId: post.id!,
                                ),
                                    
                                */
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Spacer(),
                                        Padding(
                                          padding: EdgeInsets.only(
                                            top: Get.height * 0.2,
                                          ),
                                          child: Column(
                                            children: [
                                              CircleAvatar(
                                                radius: 25,
                                                backgroundImage: NetworkImage(
                                                  post.user!.profilePic!,
                                                ),
                                                backgroundColor: Colors.grey,
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  ctr.likePost(post);
                                                },
                                                icon:  Icon(
                                                  Icons.favorite,
                                                  size: 38,
                                                  color: post.isLiked! ? Colors.red : Colors.grey,
                                                ),
                                              ),
                                              Text(
                                                post.likesCount.toString(),
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(
                                                height: Get.height * 0.02,
                                              ),
                                              IconButton(
                                                onPressed: () => Get.toNamed(
                                                    '/main/comments',
                                                    arguments: {
                                                      'postId': post.id
                                                    }),
                                                icon: const Icon(
                                                  Icons.message,
                                                  size: 38,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              Text(
                                                post.commentsCount.toString(),
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(
                                                height: Get.height * 0.005,
                                              ),
                                              IconButton(
                                                onPressed: () {},
                                                icon: const Icon(
                                                  Icons.more_horiz,
                                                  size: 38,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Text(post.description!),
                                  ],
                                ),
                              ],
                            );
                          }),
            ),
          );
        });
  }
}
