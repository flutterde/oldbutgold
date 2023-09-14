import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' hide Key, Category;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:video_player/video_player.dart';
import 'package:firebase_database/firebase_database.dart';

class CreatePostController extends GetxController {
  // firebase
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final storageRef = FirebaseStorage.instance.ref();
  final dbPostsRef = FirebaseDatabase.instance.ref().child('posts');
  UploadTask? uploadTask;

  final RxBool isLoading = false.obs;
  RxBool showProgress = false.obs;
  RxDouble uploadProgress = 0.0.obs;

  final formKey = GlobalKey<FormState>();
  final TextEditingController videoDescriptionCtr = TextEditingController();
  final TextEditingController tagsCtr = TextEditingController();

  // file picker
  PlatformFile? pickedVideoFile;

  // postID
  String postId = '';

  // categoryID
  RxString selectedCategory = ''.obs;
  double videoDuration = 0.0;

  RxList<String> tags = RxList<String>([]);

  addTag(String tag) {
    if (tag == '' || tag == ' ' || tag.isEmpty || tag.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Tag is required',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      );
    } else {
      tags.add(tag);
    }
  }

  // video path
  String fireStoreVideoPath = '';
  String yearPath = DateTime.now().year.toString();
  String monthPath = DateTime.now().month.toString();
  String dayPath = DateTime.now().day.toString();
  String hourPath = DateTime.now().hour.toString();
  String minutePath = DateTime.now().minute.toString();
  String randNumb = Random().nextInt(1000).toString();

  Future selectFile() async {
    var userID = _auth.currentUser!.uid;
    var fireStoreVideoFullPath =
        'uploads/$userID/videos/$yearPath/$monthPath/$dayPath/$hourPath/$minutePath/$randNumb/thevideofile';
    final result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );
    pickedVideoFile = result!.files.first;
    fireStoreVideoPath =
        '$fireStoreVideoFullPath.${pickedVideoFile!.extension!}';
    VideoPlayerController vc =
        VideoPlayerController.file(File(pickedVideoFile!.path!));
    await vc.initialize();
    var duration = vc.value.duration;
    videoDuration = duration.inSeconds.toDouble();
    if (kDebugMode) {
      print('===============Video Data ===============');
      print(videoDuration);
      print(vc.value.size);
      print(vc.value.buffered);
      print('==============================');
    }
    update();
  }

  Future<void> createPost(String description, String categoryID) async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    try {
      isLoading.value = true;
      if (pickedVideoFile == null) {
        Get.snackbar(
          'Error',
          'Video is required',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
        );
      } else if (videoDuration < 4 || videoDuration > 120) {
        Get.snackbar(
          'Error',
          'Video duration chould be between 45 seconds to 2 minutes',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
        );
      } else if (pickedVideoFile!.size > 100000000) {
        Get.snackbar(
          'Error',
          'Video size should be less than 100 Mb',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
        );
      } else if (postId == '') {
        Get.snackbar(
          'ID Error',
          'Please re-run the app',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
        );
      } else {
        final videoFile = File(pickedVideoFile!.path!);
        final videoFileDestination = storageRef.child(fireStoreVideoPath);
        // store video to Firebase Storage
        uploadTask = videoFileDestination.putFile(videoFile);
        uploadTask!.snapshotEvents.listen((event) {
          uploadProgress.value =
              event.bytesTransferred.toDouble() / event.totalBytes.toDouble();
          if (kDebugMode) {
            print('==============================================');
            print('================ Progress !! ====================');
            print(uploadProgress.value);
            print('==============================================');
            print('=================------=======================');
          }
        });
         await uploadTask!.whenComplete(() {});
        // await videoFileDestination.putFile(videoFile);
        var videoUrl = await videoFileDestination.getDownloadURL();
        FullMetadata videMetaData = await videoFileDestination.getMetadata();
        if (kDebugMode) {
          print('==============================================');
          print('================ Meta Data !! ====================');
          var sizeInMb = videMetaData.size! / 1024 / 1024;
          var description = videMetaData.contentDisposition;
          print(sizeInMb);
          print(description);
          print('==============================================');
          print('=================------=======================');
        }
        var sizeInMb = videMetaData.size! / 1024 / 1024;

        await _firestore.collection('posts').doc(postId).set({
          'id': postId,
          'user': _firestore.collection('users').doc(_auth.currentUser!.uid),
          'user_id': _auth.currentUser!.uid,
          'videoUrl': videoUrl,
          'videoDescription': description,
          'thumbnailGifUrl': '',
          'categoryID': categoryID,
          'tags': tags,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
          'fcmToken': fcmToken,
          'video_lang_code': 'en',
          'user_lang_code': 'en',
          'is_ready': false,
          'isRejected': false,
          'audience': 'public', // 'public' | 'following' | 'followers' | 'friends' | 'only_me'
          'is_processed': false,
          'meta_data': {
            'duration': videoDuration,
            'size_in_mb': sizeInMb,
            'size': videMetaData.size,
            'contentType': videMetaData.contentType,
            'contentDisposition': videMetaData.contentDisposition,
            'cacheControl': videMetaData.cacheControl,
            'contentLanguage': videMetaData.contentLanguage,
            'customMetadata': videMetaData.customMetadata,
            'md5Hash': videMetaData.md5Hash,
            'timeCreated': videMetaData.timeCreated,
            'updated': videMetaData.updated,
            'generation': videMetaData.generation,
            'metageneration': videMetaData.metageneration,
            'bucket': videMetaData.bucket,
            'name': videMetaData.name,
            'fullPath': videMetaData.fullPath,
            'video_extension': pickedVideoFile!.extension,
          },
        }).whenComplete(() async {
          await storePostView();
          videoDescriptionCtr.clear();
          tagsCtr.clear();
          pickedVideoFile = null;
          isLoading.value = false;
          Get.offAllNamed('/');
          Get.snackbar(
            'Success',
            'Post created successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
          );
        });
      }
    } catch (e) {
      isLoading.value = false;

      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      );
      if (kDebugMode) {
        print('==============================================');
        print(e);
        print('==============================================');
      }
    }
  }

  Future<void> storePostView() async {
    try {
      await dbPostsRef.child(postId).set({
        'views': 0,
      });
    } catch (e) {
      if (kDebugMode) {
        print('==============================================');
        print(e);
        print('==============================================');
      }
    }
  }

  @override
  void onInit() {
    postId = generateRandomString();
    if (kDebugMode) {
      print('==============================================');
      print('==============================================');
    }
    super.onInit();
  }

  @override
  void onClose() {
    postId = '';
    videoDescriptionCtr.clear();
    super.onClose();
  }

  // Generate Post Id
  String generateRandomString() {
    const characters =
        'ABCDEFGHIJKLMNOPQRSTVWXYZ0123456789abcdefghijklmnopqrstvwxyz'; // KuJlgYN6w3THrl0mlPporTgAIe12
    final random = Random();
    final buffer = StringBuffer();

    for (var i = 0; i < 30; i++) {
      final randomIndex = random.nextInt(characters.length);
      buffer.write(characters[randomIndex]);
    }

    return buffer.toString();
  }
}


