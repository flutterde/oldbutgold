import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oldbutgold/core/models/user/user_model.dart';

class EditProfileController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxBool isLoading = false.obs;

  // file picker
  PlatformFile? pickedImageFile;
  String fireStoreImagePath = '';

  UserModel user = Get.arguments['user'];

  final TextEditingController nameController = TextEditingController();
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

  Future<void> updateUserData(String name) async {
    try {
 if(pickedImageFile != null){
  //
  await __(name);

 } else{

 }
    } catch (e) {
      if (kDebugMode) {
        print('==================== ERROR  ====================');
        print(e);
        print('==================== END ERROR  ====================');
      }
    }
  }


  Future<void> __(String n) async{
         //
      isLoading.value = true;
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .update({'name': n});
  }

  Future<void> updateProfileImage() async {
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
    nameController.text = user.name!;
    super.onInit();
  }
}
