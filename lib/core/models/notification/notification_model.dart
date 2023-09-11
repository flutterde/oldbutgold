import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oldbutgold/core/models/post/post_model.dart';
import 'package:oldbutgold/core/models/user/user_model.dart';
import 'package:flutter/foundation.dart';


class NotificationModel {
  String? id;
  NotificationType? type;
  String? comment;
  String? commentId;
  String? postId;
  PostModel? post;
  String? userId;
  UserModel? user;
  String? postOwnerId;
  bool? isRead;
  UserModel? postOwner;
  Timestamp? createdAt;

  NotificationModel({
    this.id,
    this.type,
    this.comment,
    this.commentId,
    this.postId,
    this.post,
    this.userId,
    this.user,
    this.postOwnerId,
    this.isRead,
    this.postOwner,
    this.createdAt,
  });

  Future<NotificationModel> fromDocSnapshot(
      {required DocumentSnapshot doc}) async {
    if (kDebugMode) {
      print('=====================');
      print('in Notification Model.......');
      print('======================');
    }
    final postDoc = doc['post'] as DocumentReference;
    final userDoc = doc['user'] as DocumentReference;
    return NotificationModel(
      id: doc.id,
      post: await PostModel().fromDocSnapshot(doc: await postDoc.get()),
      user: UserModel.fromDocumentSnapshot(
        documentSnapshot: await userDoc.get(),
      ),
      postOwnerId: doc['post_owner_id'],
      comment: doc['comment'].toString().substring(0, 15),
      postId: doc['post_id'],
      type: NotificationType.values.firstWhere(
        (element) => element.toString() == doc['type'],
      ),
      isRead: doc['is_read'],
    );
  }
}

enum NotificationType {
  like,
  comment,
  follow,
}
