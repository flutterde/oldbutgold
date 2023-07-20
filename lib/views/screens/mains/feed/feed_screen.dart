import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

import '../../../../core/controllers/main_pages/feed/feed_controller.dart';
import '../../../widgets/video_player_widget.dart';

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
                            return SafeArea(
                              child: Stack(
                                children: [
                                  // video
                                  VideoPlayerWidget(
                                    videoUrl: post.videoUrl!,
                                    postId: post.id!,
                                  ),
                                  Column(
                                    children: [
                                      const Spacer(),
                                      Text(post.description!),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }),
            ),
          );
        });
  }
}
