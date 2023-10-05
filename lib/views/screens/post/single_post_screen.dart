import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/controllers/posts/single_post_controller.dart';

class SinglePostScreen extends GetWidget<SinglePostController> {
  const SinglePostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: SinglePostController(),
        builder: (ctr) {
          var post = ctr.post;
          return Scaffold(
            body: Obx(
              () => (ctr.isLoading.value)
                  ? const CircularProgressIndicator()
                  : (ctr.isPostsEmpty.value)
                      ? Center(
                          child: Text('no_post_to_display'.tr),
                        )
                      : Stack(
                          children: [
                         
                           Text(post.description!),
                            
                          ],
                        ),
            ),
          );
        });
  }
}
