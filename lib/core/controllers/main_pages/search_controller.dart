import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oldbutgold/core/models/user/user_model.dart';

class SearchScreenController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final formKey = GlobalKey<FormState>();
  final TextEditingController searchCtr = TextEditingController();
  RxBool isLoading = false.obs;
  RxList<UserModel> users = <UserModel>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

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
          .where('name', isGreaterThanOrEqualTo: searchCtr.text)
          .where('name', isLessThanOrEqualTo: searchCtr.text)
          .get()
          .then((value) {
        for (var doc in value.docs) {
          users.add(UserModel.fromDocumentSnapshot(documentSnapshot: doc));
        }
        isLoading.value = false;
      });
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
