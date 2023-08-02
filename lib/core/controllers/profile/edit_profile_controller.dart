import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oldbutgold/core/models/user/user_model.dart';

class EditProfileController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ref = FirebaseStorage.instance.ref();

  RxBool isLoading = false.obs;

  // file picker
  PlatformFile? pickedImageFile;
  String fireStoreImagePath = '';

  UserModel user = Get.arguments['user'];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Future selectFile() async {
    var dateTime = DateTime.now();
    var milliSeconds = dateTime.millisecondsSinceEpoch;
    var randNumb = milliSeconds.toString().substring(7);
    var userID = _auth.currentUser!.uid;
    var fireStoreImageFullPath =
        'uploads/$userID/profile/$milliSeconds/$randNumb/image';
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    pickedImageFile = result!.files.first;
    fireStoreImagePath =
        '$fireStoreImageFullPath.${pickedImageFile!.extension!}';

    if (kDebugMode) {
      print('===============Image Data ===============');
      print('Image Name: ${pickedImageFile!.name}');

      print('==============================');
    }
    update();
  }

  Future<void> updateUserData(String name, String bio) async {
    try {
      isLoading.value = true;
      if (pickedImageFile != null) {
        //
        await updateProfileImage();
        await __(name, bio);
      } else {
        await __(name, bio);
      }
      isLoading.value = false;
      Get.back();
      Get.snackbar(
        'Success',
        'Profile Updated Successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
      );
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Something went wrong, try again later',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      );
      if (kDebugMode) {
        print('==================== ERROR  ====================');
        print(e);
        print('==================== END ERROR  ====================');
      }
    }
  }

  Future<void> __(String n, String b) async {
    //
    isLoading.value = true;
    await _firestore.collection('users').doc(_auth.currentUser!.uid).update({
      'name': n,
      'profile': {'profile_bio': b}
    });
  }

  Future<void> updateProfileImage() async {
    try {
      //
      final imageDestination = ref.child(fireStoreImagePath);
      await imageDestination.putFile(File(pickedImageFile!.path!));
      var imgUrl = await imageDestination.getDownloadURL();
      FullMetadata metadata = await imageDestination.getMetadata();

      await _firestore
          .collection('change_profile')
          .doc(_auth.currentUser!.uid)
          .set({
        'profile_pic': imgUrl,
        'user_id': _auth.currentUser!.uid,
        'img_file_path': metadata.fullPath,
        'img_content_type': metadata.contentType,
        'extension': pickedImageFile!.extension,
      });
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
    nameController.text = user.name!;
    bioController.text = user.bio!;
    super.onInit();
  }
}
