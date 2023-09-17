import 'package:flutter/material.dart';
import 'package:oldbutgold/core/models/comment/comment_model.dart';

import '../../../core/controllers/comments/comments_controller.dart';

Widget lastCommentWidget(CommentModel comment, CommentsController ctr) =>
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
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
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
          trailing: ((comment.user!.id == ctr.currentUserId) ||
                  (comment.post!.user!.id == ctr.currentUserId))
              ? IconButton(
                  onPressed: () {
                    ctr.deleteComment(comment.id!, comment.post!.id!);
                  },
                  icon: const Icon(Icons.delete_outline_rounded),
                )
              : const SizedBox(),
        ),
        const SizedBox(height: 100),
      ],
    );
