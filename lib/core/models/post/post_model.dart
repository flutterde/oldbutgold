import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

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




}
