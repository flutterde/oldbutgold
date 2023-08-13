import 'package:oldbutgold/core/models/post/post_model.dart';
import 'package:oldbutgold/core/models/user/user_model.dart';

class LikeModel {
  String? id;
  UserModel? user;
  PostModel? post;
  DateTime? createdAt;

  LikeModel({
    this.id,
    this.user,
    this.post,
    this.createdAt,
  });

  

}