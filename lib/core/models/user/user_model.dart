import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UserModel {
  String backetCdnUrl = dotenv.get('CF_R_DOMAIN');
  String? id;
  String? name;
  String? username;
  String? email;
  String? country;
  String? profilePic;
  String? bio;
  DateTime? createdAt;
  bool? isVerified;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.country,
    this.profilePic,
    this.bio,
    // this.createdAt,
    this.isVerified,
  });

  UserModel.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot}) {
    if (kDebugMode) {
      print('=====================');
      print('in User Model.......');
      print('======================');
    }
    id = documentSnapshot.id;
    if (kDebugMode) {
      print(' User Model id.......${id!}');
      print('======================');
    }
    if (kDebugMode) {
      print(' User Model Name.......');
      print('======================');
    }
    name = documentSnapshot['name'];
    //username = documentSnapshot['username'];
    if (kDebugMode) {
      print(' User Model Email.......');
      print('======================');
    }
    email = documentSnapshot['email'];
    if (kDebugMode) {
      print(' User Model country.......');
      print('======================');
    }
    country = documentSnapshot['user_data']['countryName'];
    if (kDebugMode) {
      print(' User Model country.......');
      print('======================');
    }
    profilePic = '$backetCdnUrl${documentSnapshot['profile_photo_url']}';
    if (kDebugMode) {
      print(' User Model image.......');
      print('======================');
    }
    bio = documentSnapshot['profile']['profile_bio'] ?? '';
    if (kDebugMode) {
      print(' User Model Name.......');
      print('======================');
    }
    isVerified = documentSnapshot['profile']['is_profile_verified'] ?? false;
    // createdAt = documentSnapshot['created_at'];
    if (kDebugMode) {
      print('Out User Model.......');
      print('======================');
    }
  }
}
