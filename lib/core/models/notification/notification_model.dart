import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oldbutgold/core/models/post/post_model.dart';
import 'package:oldbutgold/core/models/user/user_model.dart';
import 'package:flutter/foundation.dart';

enum NotificationType {
  like,
  comment,
  follow,
  other,
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
      comment: doc['comment'].toString().substring(0, 20),
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
      return NotificationType.other;
  }
}




/*





{
  post: DocumentReference<Map<String, 
  dynamic>>(posts/rOSMlpO2MpSWPaEjG1VhH7xR4MxP1t), 
post_owner: DocumentReference<Map<String, 
dynamic>>(users/UTaH76jqKue4s7aPywtB4vxUt4y1), 
post_owner_id: UTaH76jqKue4s7aPywtB4vxUt4y1, 
post_id: rOSMlpO2MpSWPaEjG1VhH7xR4MxP1t, 
comment: انها ليست امبراطوريه عربية بل خلافة إسلامية , 
created_at: Timestamp(seconds=1694906342, nanoseconds=926000000), 
commentId: FAUArCf5sCsdO3JGKrFu, 
type: comment, 
user: DocumentReference<Map<String, 
dynamic>>(users/9pqZSSoN9Qfj8w9wOHnbPjLGxni1),
 user_id: 9pqZSSoN9Qfj8w9wOHnbPjLGxni1, 
 is_read: false
}










*/
