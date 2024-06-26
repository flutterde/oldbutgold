import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oldbutgold/core/models/user/user_model.dart';

class SearchScreenController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final formKey = GlobalKey<FormState>();
  final TextEditingController searchCtr = TextEditingController();
  RxBool isLoading = false.obs;
  RxBool isUsersEmpty = false.obs;
  RxList<UserModel> users = <UserModel>[].obs;
  String get currentUserId => _auth.currentUser!.uid;

  void clearSearch() {
    searchCtr.clear();
    users.clear();
    update();
  }

  Future<void> search() async {
    try {
      isLoading.value = true;
      await _firestore
          .collection('users')
          .orderBy('name')
          .startAt([searchCtr.text.toLowerCase()])
          .endAt(['${searchCtr.text.toLowerCase()}\uf8ff'])
          .limit(10)
          .get()
          .then((value) async {
            users.clear();
            for (var doc in value.docs) {
              users.add(await UserModel()
                  .fromDocumentSnapshot(documentSnapshot: doc));
            }
            users.isEmpty
                ? isUsersEmpty.value = true
                : isUsersEmpty.value = false;
            isLoading.value = false;
          });
    } catch (e) {
      isLoading.value = false;

      if (kDebugMode) {
        print('========= Search Error ==========');
        print(e);
        print('========= End Search Error ==========');
      }
      Get.snackbar(
        'error'.tr,
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
