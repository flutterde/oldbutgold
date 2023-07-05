import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../comment/comment_model.dart';
import '../user/user_model.dart';

class PostModel {
  String backetCdnUrl = dotenv.get('CLOUDFLARE_R2_URL');
  late String id;
  late Future<UserModel> user;
  Future<List<CommentModel>?>? comments;
  String? description;
  late String videoUrl;
  String? thumbnailGifUrl;
  DateTime? createdAt;

  PostModel({
    required this.id,
    required this.user,
    this.comments,
    this.description,
    required this.videoUrl,
    this.thumbnailGifUrl,
    this.createdAt,
  });

  PostModel.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot}) {
    id = documentSnapshot.id;
    user = getUser(documentSnapshot['user_id']);
    comments = getComments(documentSnapshot.id);
    description = documentSnapshot['description'];
    videoUrl = '$backetCdnUrl/${documentSnapshot['video_url']}';
    thumbnailGifUrl = '$backetCdnUrl/${documentSnapshot['thumbnail_gif_url']}';
    createdAt = documentSnapshot['created_at'].toDate();
  }

  // return the user for post model
  Future<UserModel> getUser(String id) async {
    DocumentSnapshot documentSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(id).get();
    return UserModel.fromDocumentSnapshot(documentSnapshot: documentSnapshot);
  }

  // return the comments for post model
  Future<List<CommentModel>> getComments(String id) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('comments')
        .where('post_id', isEqualTo: id)
        .get();
    return querySnapshot.docs
        .map((documentSnapshot) => CommentModel.fromDocumentSnapshot(
            documentSnapshot: documentSnapshot))
        .toList();
  }
}
