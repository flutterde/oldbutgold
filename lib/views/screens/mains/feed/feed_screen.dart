import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/controllers/main_pages/feed/feed_controller.dart';
import '../../../widgets/posts/more_post_widget.dart';
import '../../../widgets/video_player_widget.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class FeedScreen extends GetWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: Get.put(FeedController(), permanent: false),
        builder: (ctr) {
          ctr.pageController =
              PageController(initialPage: ctr.currentIndex.value);
          return Scaffold(
            appBar: AppBar(
              title: Text('feed'.tr),
              centerTitle: true,
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                await Future.delayed(const Duration(seconds: 1));
                ctr.fetchAllPosts();
              },
              backgroundColor: Colors.deepPurple,
              color: Colors.white,
              child: Obx(
                () => ctr.isLoading.value
                    ? Center(
                        child: LoadingAnimationWidget.dotsTriangle(
                        color: Colors.white,
                        size: 50,
                      ))
                    : ctr.isPostsEmpty.value
                        ? Center(
                            child: Text('no_post_to_display'.tr),
                          )
                        : PageView.builder(
                            scrollDirection: Axis.vertical,
                            controller: ctr.pageController,
                            itemCount: ctr.posts.length,
                            onPageChanged: (value) {
                              ctr.currentIndex.value = value;
                            },
                            itemBuilder: (context, index) {
                              if (index == ctr.posts.length - 3) {
                                ctr.getMorePosts();
                              }
                              var post = ctr.posts[index];
                              return Stack(
                                children: [
                                  // video

                                  VideoPlayerWidget(
                                    videoUrl: post.videoUrl!,
                                    postId: post.id!,
                                  ),

                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                        ? Get.toNamed(
                                                            '/profile')
                                                        : Get.toNamed(
                                                            '/users/profile',
                                                            arguments: {
                                                              'user': post.user,
                                                              'carrentUser': ctr
                                                                  .currentUserId
                                                            },
                                                          );
                                                  },
                                                  child: CircleAvatar(
                                                    radius: 25,
                                                    backgroundImage:
                                                        NetworkImage(
                                                      post.user!.profilePic!,
                                                    ),
                                                    backgroundColor:
                                                        Colors.grey,
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
                                                        'postOwner':
                                                            post.user!.id,
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
                                                    fontWeight:
                                                        FontWeight.normal,
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
            ),
          );
        });
  }
}
