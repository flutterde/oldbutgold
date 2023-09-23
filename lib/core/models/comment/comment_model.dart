import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:oldbutgold/core/models/post/post_model.dart';
import '../user/user_model.dart';

class CommentModel {
  String? id;
  UserModel? user;
  String? content;
  Timestamp? createdAt;
  bool? canDelete;
  PostModel? post;

  CommentModel({
    this.id,
    this.user,
    this.content,
    this.createdAt,
    this.canDelete,
    this.post,
  });

  Future<CommentModel> fromDocSnapshot({required DocumentSnapshot doc}) async {
    final postDoc = doc['post'] as DocumentReference;

    final postUser = doc['user'] as DocumentReference;
    return CommentModel(
      id: doc.id,
      user: await UserModel().fromDocumentSnapshot(
        documentSnapshot: await postUser.get(),
      ),
      content: doc['comment'],
      createdAt: doc['createdAt'],
      canDelete: false, // not handled yet
      post: await PostModel().fromDocSnapshot(doc: await postDoc.get()),
    );
  }

}


bool _canDelete(String authorId, String currenUserId, String postAuthorId) {
  if (authorId == currenUserId || currenUserId == postAuthorId) {
    return true;
  } else {
    return false;
  }
}