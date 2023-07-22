import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  int? commentsCount;
  int? likesCount;
  bool? isLiked;

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
    this.commentsCount,
    this.likesCount,
    this.isLiked,
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
      commentsCount: await getPostCommentsCount(postId: doc.id),
      likesCount: await getPostLikesCount(postId: doc.id),
      isLiked: await getIsPostLiked(postId: doc.id),
    );
  }

  Future<int> getPostCommentsCount({required String postId}) async {
    print('================== Start Counts ===================');
    AggregateQuerySnapshot query = await FirebaseFirestore.instance
        .collection('comments')
        .doc(postId)
        .collection('list')
        .count()
        .get();
    print('================== Counts ===================');
    print(query.count);
    print('================== Counts ===================');
    return query.count;
  }


  Future<int> getPostLikesCount({required String postId}) async {
    print('================== Start Counts ===================');
    AggregateQuerySnapshot query = await FirebaseFirestore.instance
        .collection('likes')
        .where('post_id', isEqualTo: postId)
        .count()
        .get();
    print('================== Counts ===================');
    print(query.count);
    print('================== Counts ===================');
    return query.count;
  }


  Future<bool> getIsPostLiked({required String postId}) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    bool isLiked = false;
    print('================== Start isPost Likes ===================');
    final query = await FirebaseFirestore.instance
        .collection('likes')
        .where('user_id', isEqualTo: _auth.currentUser!.uid)
        .where('post_id', isEqualTo: postId)
        .get();

        query.size > 0 ? isLiked = true : isLiked = false;
      
    print('================== isPost Likes ===================');
    print(isLiked);
    print('================== isPost Likes ===================');
    return isLiked;
  }
}
