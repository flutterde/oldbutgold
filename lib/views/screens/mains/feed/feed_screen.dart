import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/controllers/main_pages/feed/feed_controller.dart';
import '../../../../tests/controllers/t.dart';

class FeedScreen extends GetWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(Tctr());

    return GetBuilder(
      init: FeedController(),
      builder: (ctr) => Scaffold(
        appBar: AppBar(
          title: const Text('Feed'),
          actions: [
            IconButton(
              onPressed: () {
                c.f();
              },
              icon: const Icon(Icons.logout),
            )
          ],
        ),
        body: Obx(
          () => ctr.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: ctr.posts.length,
                  itemBuilder: (context, index) {
                    var post = ctr.posts[index];
                    return ListTile(
                      title: Text(post.description!),
                      subtitle: Text(post.user!.name!),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
