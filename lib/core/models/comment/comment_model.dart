import 'package:cloud_firestore/cloud_firestore.dart';
import '../user/user_model.dart';

class CommentModel {
  late String id;
  late Future<UserModel> user;
  String? content;
  DateTime? createdAt;

  CommentModel({
    required this.id,
    this.content,
    this.createdAt,
  });

  CommentModel.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot}) {
    id = documentSnapshot.id;
    user = getUser(documentSnapshot['user_id']);
    content = documentSnapshot['content'];
    createdAt = documentSnapshot['created_at'].toDate();
  }

  // return the user for comment model
  Future<UserModel> getUser(String id) async {
    DocumentSnapshot documentSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(id).get();
    return UserModel.fromDocumentSnapshot(documentSnapshot: documentSnapshot);
  }
}
