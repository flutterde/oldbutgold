import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oldbutgold/core/models/post/post_model.dart';
import 'package:oldbutgold/core/models/user/user_model.dart';

enum NotificationType {
  like,
  comment,
  follow,
  platform,
}

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
    final postDoc = doc['post'] as DocumentReference?;
    final post = postDoc != null
        ? await PostModel().fromDocSnapshot(doc: await postDoc.get())
        : null;
    final userDoc = doc['user'] as DocumentReference;
    return NotificationModel(
      id: doc.id,
      post: post,
      user: await UserModel().fromDocumentSnapshot(
        documentSnapshot: await userDoc.get(),
      ),
      postOwnerId: doc['post_owner_id'],
      comment: doc['comment'].toString(),
      commentId: doc['commentId'],
      postId: doc['post_id'],
      type: getNotificationType(doc['type']),
      isRead: doc['is_read'],
    );
  }
}

NotificationType getNotificationType(String type) {
  switch (type) {
    case 'like':
      return NotificationType.like;
    case 'comment':
      return NotificationType.comment;
    case 'follow':
      return NotificationType.follow;
    default:
      return NotificationType.platform;
  }
}
