import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../models/post.dart';



class TestViewController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxBool isLoading = false.obs;
  List<PostM> posts = [];

  @override
  void onInit() {
    getTests();
    super.onInit();
  }

  Future<void> getTests() async{
    try{
      isLoading.value = true;
      QuerySnapshot querySnapshot = await _firestore.collection('tests').get();
      posts.clear();
      for (var post in querySnapshot.docs) {
        posts.add(await PostM(id: post.id, author: null).fromDocumentSnapshot(documentSnapshot: post));
        print('=========Post from Doc=========');
        print(post.id);
        print('=========End Post from Doc=========');

      }
      isLoading.value = false;
    } catch(e){
      print('=========Error=========');
      print(e);
      print('=========End Error=========');
    } 


  }
}
