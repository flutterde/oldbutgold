import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/controllers/comments/comments_controller.dart';
import 'last_comment_widget.dart';

class CommentsScreen extends GetWidget {
  const CommentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: CommentsController(),
        builder: (ctr) {
          var createCtr = ctr.createCommentController;
          return Scaffold(
            appBar: AppBar(
              title: const Text('Comments'),
            ),
            body: Stack(
              children: [
                Obx(
                  () => ctr.isLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : (ctr.comments.isEmpty && !ctr.isLoading.value)
                          ? const Center(
                              child: Text('No Comments to display'),
                            )
                          : ListView.builder(
                              itemCount: ctr.comments.length,
                              itemBuilder: (context, index) {
                                var comment = ctr.comments[index];

                                if (index == (ctr.comments.length - 1)) {
                                  return lastCommentWidget(comment, ctr);
                                }
                                return ListTile(
                                  title: Text(comment.content!),
                                  subtitle: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 10,
                                        backgroundImage: NetworkImage(
                                          comment.user!.profilePic!,
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        comment.user!.name!,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600]),
                                      ),
                                    ],
                                  ),
                                  trailing: ((comment.user!.id ==
                                              ctr.currentUserId) ||
                                          (comment.post!.user!.id ==
                                              ctr.currentUserId))
                                      ? IconButton(
                                          onPressed: () {
                                            ctr.deleteComment(
                                                comment.id!, comment.post!.id!);
                                          },
                                          icon: const Icon(
                                            Icons.delete_outline_rounded,
                                          ),
                                        )
                                      : const SizedBox(),
                                );
                              },
                            ),
                ),
                Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      color: Colors.white,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: createCtr.commentCtr,
                              maxLength: 90,
                              decoration: const InputDecoration(
                                hintText: 'Write a comment',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              createCtr.createcomment(
                                  Get.arguments['postId'],
                                  createCtr.commentCtr.text,
                                  Get.arguments['postOwner']);
                            },
                            icon: Obx(() => createCtr.isLoading.value
                                ? const Icon(Icons.trending_up)
                                : const Icon(Icons.send)),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          );
        });
  }
}
