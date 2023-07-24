import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:oldbutgold/core/models/user/user_model.dart';

class ProfileConntroller extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  UserModel? user;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    userData();
    super.onInit();
  }

  Future<void> userData() async {
    try {
      //
      isLoading.value = true;
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .get()
          .then((value) {
        user = UserModel.fromDocumentSnapshot(documentSnapshot: value);
      });
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      if (kDebugMode) {
        print('==================== ERROR  ====================');
        print(e);
        print('==================== END ERROR  ====================');
      }
    }
  }
}
