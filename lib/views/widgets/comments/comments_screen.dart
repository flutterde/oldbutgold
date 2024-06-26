import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/controllers/comments/comments_controller.dart';
import 'last_comment_widget.dart';
import 'package:timeago/timeago.dart' as timeago;

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
              title: Text('comments'.tr),
              centerTitle: true,
            ),
            body: Stack(
              children: [
                Obx(
                  () => ctr.isLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : (ctr.comments.isEmpty && !ctr.isLoading.value)
                          ? Center(
                              child: Text('no_comments_to_display'.tr),
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
                                  subtitle: GestureDetector(
                                    onTap: () {
                                      (comment.user!.id == ctr.currentUserId)
                                          ? Get.toNamed('/profile')
                                          : Get.toNamed(
                                              '/users/profile',
                                              arguments: {
                                                'user': comment.user,
                                                'carrentUser': ctr.currentUserId
                                              },
                                            );
                                    },
                                    child: Row(
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
                                        const Spacer(),
                                        Text(
                                          timeago.format(
                                            comment.createdAt!.toDate(),
                                            locale: Get.locale!.languageCode,
                                          ),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
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
                      color: Colors.grey[800],
                      child: Row(
                        children: [
                          Expanded(
                            child: Form(
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: createCtr.commentCtr,
                                    maxLength: 90,
                                    decoration: InputDecoration(
                                      hintText: 'add_comment'.tr,
                                      border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty ||
                                          value.trim().isEmpty) {
                                        return 'please_enter_your_comment'.tr;
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Obx(() => createCtr.isLoading.value
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : IconButton(
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    createCtr.createcomment(
                                        Get.arguments['postId'],
                                        createCtr.commentCtr.text,
                                        Get.arguments['postOwner']);
                                  },
                                  icon: const Icon(Icons.send),
                                )),
                        ],
                      ),
                    )),
              ],
            ),
          );
        });
  }
}
