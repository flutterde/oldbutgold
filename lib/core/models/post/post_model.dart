import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../user/user_model.dart';

class PostModel {
  String backetCdnUrl = dotenv.get('CF_R_DOMAIN');
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
  int? viewsCount;
  String? videoExtension;

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
    this.viewsCount,
    this.videoExtension,
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
      user: await UserModel().fromDocumentSnapshot(
        documentSnapshot: await postUser.get(),
      ),
      description: doc['videoDescription'],
      categoryId: doc['categoryID'],
      videoUrl: "$backetCdnUrl${doc['videoUrl']}",
      // thumbnailGifUrl: doc['thumbnailGifUrl'],
      duration: doc['meta_data']['duration'],
      tags: doc['tags'],
      createdAt: doc['createdAt'],
      commentsCount: await getPostCommentsCount(postId: doc.id),
      likesCount: await getPostLikesCount(postId: doc.id),
      isLiked: await getIsPostLiked(postId: doc.id),
      viewsCount: await getPostViewsCount(postId: doc.id),
      videoExtension: doc['meta_data']['video_extension'] ?? 'mp4',
    );
  }

  Future<int> getPostCommentsCount({required String postId}) async {
    AggregateQuerySnapshot query = await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .count()
        .get();
    return query.count;
  }

  Future<int> getPostLikesCount({required String postId}) async {
    AggregateQuerySnapshot query = await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .count()
        .get();
    return query.count;
  }

  Future<bool> getIsPostLiked({required String postId}) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    bool isLiked = false;
    final query = await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(auth.currentUser!.uid)
        .get();
    query.exists ? isLiked = true : isLiked = false;
    return isLiked;
  }

  // todo: get post views count from realtime database
  Future<int?> getPostViewsCount({required String postId}) async {
    final dbPostsRef = FirebaseDatabase.instance.ref().child('posts');
    int? viewsCount = 0;
    try {
      await dbPostsRef.child(postId).once().then((DatabaseEvent snapshot) {
        viewsCount =
            (snapshot.snapshot.value as Map<dynamic, dynamic>)['views'] as int?;
      });
    } catch (e) {
      if (kDebugMode) {
        print('======== Error in getPostViewsCount =========');
        print(e);
        print('======== End Error in getPostViewsCount =========');
      }
    }
    return viewsCount;
  }
}
