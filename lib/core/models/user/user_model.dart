import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

class UserModel {
  String backetCdnUrl = dotenv.get('CF_R_DOMAIN');
  String? id;
  String? name;
  String? username;
  String? email;
  String? country;
  String? profilePic;
  String? bio;
  Timestamp? createdAt;
  bool? isVerified;
  int? followersCount;
  int? followingCount;
  bool? isFollowing;
  bool? isFollower;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.country,
    this.profilePic,
    this.bio,
    this.createdAt,
    this.isVerified,
    this.followersCount,
    this.followingCount,
    this.isFollowing,
    this.isFollower,
  });

  Future<UserModel> fromDocumentSnapshot(
      {required DocumentSnapshot documentSnapshot}) async {
    if (kDebugMode) {
      print('=====================');
      print('in User Model.......');
      print('======================');
    }
    return UserModel(
      id: documentSnapshot.id,
      name: documentSnapshot['name'],
      //username : documentSnapshot['username'],
      email: documentSnapshot['email'],
      country: documentSnapshot['user_data']['countryName'],
      profilePic: '$backetCdnUrl${documentSnapshot['profile_photo_url']}',
      bio: documentSnapshot['profile']['profile_bio'] ?? '',
      isVerified: documentSnapshot['profile']['is_profile_verified'] ?? false,
      createdAt: documentSnapshot['created_at'],
      followersCount: await getFollowersCount(documentSnapshot.id),
      followingCount: await getFollowingCount(documentSnapshot.id),
      isFollowing: await getIsFollowing(documentSnapshot.id),
      isFollower: await getIsFollower(documentSnapshot.id),
    );
  }

  /* Helper functions */
  Future<int> getFollowersCount(String userId) async {
    AggregateQuerySnapshot query = await _firestore
        .collection('followers')
        .doc(userId)
        .collection('following_list')
        .count()
        .get();
    return (query.count);
  }

  Future<int> getFollowingCount(String userId) async {
    AggregateQuerySnapshot query = await _firestore
        .collection('following')
        .doc(userId)
        .collection('following_list')
        .count()
        .get();
    return (query.count);
  }

  Future<bool?> getIsFollowing(String userId) async {
    if (_auth.currentUser!.uid == userId) return null;
    DocumentSnapshot doc = await _firestore
        .collection('following')
        .doc(_auth.currentUser!.uid)
        .collection('following_list')
        .doc(userId)
        .get();
    return (doc.exists);
  }

  Future<bool?> getIsFollower(String userId) async {
    if (_auth.currentUser!.uid == userId) return null;
    DocumentSnapshot doc = await _firestore
        .collection('followers')
        .doc(_auth.currentUser!.uid)
        .collection('followers_list')
        .doc(userId)
        .get();
    return (doc.exists);
  }
}
