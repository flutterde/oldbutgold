import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../user/user_model.dart';

class CommentModel {
  String? id;
  UserModel? user;
  String? content;
  DateTime? createdAt;

  CommentModel({
    this.id,
    this.user,
    this.content,
    this.createdAt,
  });

  Future<CommentModel> fromDocSnapshot({required DocumentSnapshot doc}) async {
    if (kDebugMode) {
      print('=====================');
      print('in Post Model.......');
      print('======================');
    }
    final postUser = doc['user'] as DocumentReference;
    return CommentModel(
      id: doc.id,
      user: UserModel.fromDocumentSnapshot(
        documentSnapshot: await postUser.get(),
      ),
      content: doc['content'],
      createdAt: doc['createdAt'],
    );
  }
}
