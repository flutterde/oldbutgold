import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oldbutgold/core/models/post/post_model.dart';
import 'package:oldbutgold/core/models/user/user_model.dart';

class NotificationModel {
  String? id;
  String? type;
  String? comment;
  String? commentId;
  String? postId;
  PostModel? post;
  String? userId;
  UserModel? user;
  String? postOwnerId;
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
    this.postOwner,
    this.createdAt,
  });


}