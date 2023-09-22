import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../models/user/user_model.dart';

class OtherUsersProfileController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String get currentUserId => _auth.currentUser!.uid;
  RxBool isLoading = false.obs;
  UserModel? user;
  String? userUid;
  @override
  void onInit() {
    handle();
    user = Get.arguments['user'];
    super.onInit();
  }

  void handle() {
    if (Get.parameters['id'] != null) {
      userUid = Get.parameters['id'];
      fetchUserData(userUid!);
    } else {
      print('===============================================');
      print('===============   NO USER ID =====================');
      print('===============================================');
    }
  }

  Future<void> fetchUserData(String uid) async {
    try {
      isLoading.value = true;
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      user = UserModel.fromDocumentSnapshot(documentSnapshot: doc);
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      print('===============================================');
      print('===============   ERROR =====================');
      print(e);
      print('===============================================');
    }
  }
}
