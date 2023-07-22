import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UserModel {
  String backetCdnUrl = dotenv.get('CF_R_DOMAIN');
  late String id;
  String? name;
  String? username;
  String? email;
  String? country;
  String? profilePic;
  String? bio;
  DateTime? createdAt;

  UserModel({
    required this.id,
    this.name,
    this.email,
    this.country,
    this.profilePic,
    this.bio,
   // this.createdAt,
  });

  UserModel.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot}) {
    if (kDebugMode) {
      print('=====================');
      print('in User Model.......');
      print('======================');
    }
    id = documentSnapshot.id;
    name = documentSnapshot['name'];
    //username = documentSnapshot['username'];
    email = documentSnapshot['email'];
    country = documentSnapshot['user_data']['countryName'];
    profilePic = '$backetCdnUrl${documentSnapshot['profile']['profile_photo_url']}';
    bio = documentSnapshot['profile']['profile_bio'];
   // createdAt = documentSnapshot['created_at'];
  }
   

}
