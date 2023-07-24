import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oldbutgold/core/models/user/user_model.dart';

class EditProfileController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxBool isLoading = false.obs;


  UserModel user = Get.arguments['user'];

  final TextEditingController nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Future<void> updateUserDate() async {
    try {
      //
    } catch (e) {
      if (kDebugMode) {
        print('==================== ERROR  ====================');
        print(e);
        print('==================== END ERROR  ====================');
      }
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    nameController.text = user.name!;
    super.onInit();
  }
}
