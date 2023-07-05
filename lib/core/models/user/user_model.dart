import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UserModel {
  String backetCdnUrl = dotenv.get('CLOUDFLARE_R2_URL');
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
    this.createdAt,
  });

  UserModel.fromDocumentSnapshot({required DocumentSnapshot documentSnapshot}) {
    id = documentSnapshot.id;
    name = documentSnapshot['name'];
    username = documentSnapshot['username'];
    email = documentSnapshot['email'];
    country = documentSnapshot['user_location']['country'];
    profilePic = '$backetCdnUrl/${documentSnapshot['profile']['profile_image']}';
    bio = documentSnapshot['bio'];
    createdAt = documentSnapshot['created_at'].toDate();
  }


}
