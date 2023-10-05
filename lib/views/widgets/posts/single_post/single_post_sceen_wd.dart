import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../../core/controllers/posts/single_post_wd_controller.dart';
import '../../video_player_widget.dart';
import '../more_post_widget.dart';

class SinglePostScreenWidget extends GetWidget {
  const SinglePostScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: SinglePostWdController(),
        builder: (ctr) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Single Post Screen'.tr),
              centerTitle: true,
            ),
            body: Center(
              child: Obx(() {
                var post = ctr.post;
                return
                (ctr.isLoading.value)
                    ? LoadingAnimationWidget.dotsTriangle(
                        color: Colors.white,
                        size: 50,
                      )
                    : (ctr.noPostFound.value && !ctr.isLoading.value)
                        ? Text('No Post Found X'.tr)
                        : Stack(
                            children: [
                              VideoPlayerWidget(
                                videoUrl: post!.videoUrl!,
                                postId: post.id!,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Spacer(),
                                  Text(
                                    ' @${post.user!.name!}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      post.description!,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
                                            GestureDetector(
                                              onTap: () {
                                                (post.user!.id ==
                                                        ctr.currentUserId)
                                                    ? Get.toNamed('/profile')
                                                    : Get.toNamed(
                                                        '/users/profile',
                                                        arguments: {
                                                          'user': post.user,
                                                          'carrentUser':
                                                              ctr.currentUserId
                                                        },
                                                      );
                                              },
                                              child: CircleAvatar(
                                                radius: 25,
                                                backgroundImage: NetworkImage(
                                                  post.user!.profilePic!,
                                                ),
                                                backgroundColor: Colors.grey,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                ctr.likePost(post);
                                              },
                                              icon: Icon(
                                                Icons.favorite,
                                                size: 38,
                                                color: post.isLiked!
                                                    ? Colors.red
                                                    : Colors.white,
                                              ),
                                            ),
                                            Text(
                                              post.likesCount.toString(),
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(
                                              height: Get.height * 0.02,
                                            ),
                                            IconButton(
                                              onPressed: () => Get.toNamed(
                                                  '/main/comments',
                                                  arguments: {
                                                    'postId': post.id,
                                                    'postOwner': post.user!.id,
                                                  }),
                                              icon: const Icon(
                                                Icons.message,
                                                size: 38,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Text(
                                              post.commentsCount.toString(),
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(
                                              height: Get.height * 0.005,
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                morePostWidget(
                                                  post,
                                                );
                                              },
                                              icon: const Icon(
                                                Icons.more_horiz,
                                                size: 38,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const Icon(
                                              Icons.visibility,
                                              size: 15,
                                              color: Colors.grey,
                                            ),
                                            Text(
                                              post.viewsCount.toString(),
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
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
