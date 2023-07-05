import 'package:cloud_firestore/cloud_firestore.dart';

class AuthorModel {
  late String id;
  String? name;
  String? email;

  AuthorModel({
    required this.id,
    this.name,
    this.email,
  });

  AuthorModel.fromDocumentSnapshot(
      {required DocumentSnapshot documentSnapshot}) {
    print('=========Hello Author=========');
    print(documentSnapshot.id);
    print('=========End Author=========');
    id = documentSnapshot.id;
    name = documentSnapshot['name'];
    email = documentSnapshot['email'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
    };
  }
}
