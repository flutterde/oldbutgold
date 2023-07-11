import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../comment/comment_model.dart';
import '../user/user_model.dart';

class PostModel {
 // String backetCdnUrl = dotenv.get('CLOUDFLARE_R2_URL');
  String? id;
  UserModel? user;
  String? description;
  String? categoryId;
  String? videoUrl;
  String? thumbnailGifUrl;
  double? duration;
  List<dynamic>? tags;
  Timestamp? createdAt;

  PostModel({
    this.id,
    this.user,
    this.description,
    this.categoryId,
    this.videoUrl,
    this.thumbnailGifUrl,
    this.duration,
    this.tags,
    this.createdAt,
  });

  PostModel.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot}) {
    id = documentSnapshot.id;
    // user = getUser(documentSnapshot['user_id']);
    // comments = getComments(documentSnapshot.id);
    description = documentSnapshot['description'];
   // videoUrl = '$backetCdnUrl/${documentSnapshot['video_url']}';
   // thumbnailGifUrl = '$backetCdnUrl/${documentSnapshot['thumbnail_gif_url']}';
    createdAt = documentSnapshot['created_at'].toDate();
  }

  /*

  * Post with User

  */

  Future<PostModel> fromDocSnapshot({required DocumentSnapshot doc}) async {
              if (kDebugMode) {
        print('=====================');
        print('in Post Model.......');
        print('======================');
      }
    final postUser = doc['user'] as DocumentReference;
    return PostModel(
      id: doc.id,
      user: UserModel.fromDocumentSnapshot(
        documentSnapshot: await postUser.get(),
      ),
      description: doc['videoDescription'],
      categoryId: doc['categoryID'],
      videoUrl: doc['videoUrl'],
      // thumbnailGifUrl: doc['thumbnailGifUrl'],
      duration: doc['meta_data']['duration'],
      tags: doc['tags'],
      createdAt: doc['createdAt'],
    );
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
