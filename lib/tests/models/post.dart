import 'package:cloud_firestore/cloud_firestore.dart';

import 'author_model.dart';

class PostM {
  late String id;
  String? content;
  AuthorModel? author;

  PostM({
    required this.id,
    this.content,
     required this.author,
  });

  Future<PostM> fromDocumentSnapshot(
      {required DocumentSnapshot documentSnapshot}) async {
        final data = documentSnapshot;
        final authorRef = data['user'] as DocumentReference;
    print('=========ID=========');
    print(documentSnapshot.id);
    print('=========End ID=========');

    return PostM(
      id: documentSnapshot.id,
      content: documentSnapshot['content'],
      author: AuthorModel.fromDocumentSnapshot(
        documentSnapshot: await authorRef.get(),
      ),
    );
  }
}
