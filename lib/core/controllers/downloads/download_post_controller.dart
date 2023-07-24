import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadPostController extends GetxController {
  RxDouble progress = 0.0.obs;
  RxBool isDownloaded = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  Future<void> downloadVideo(String videoUrl, String videoExtension) async {
    try {
      //

      var status = await Permission.storage.request();
      if (status.isGranted) {
        // permission is granted
        var time = DateTime.now().millisecondsSinceEpoch;
        Dio dio = Dio();
        var path = "/storage/emulated/0/Download/video_$time.$videoExtension";
        var file = File(path);

        await dio.download(
          videoUrl,
          path,
          onReceiveProgress: (rec, total) {
            progress.value = ((rec / total) * 100);
            print('==================== DOWNLOADING ====================');
            print('Rec: $rec, Total: $total');
            print('==================== End DOWNLOADING ====================');
            update();
          },
          deleteOnError: true,
        );
        isDownloaded.value = true;
        Get.snackbar(
          'Success',
          'Video downloaded successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          
        

        );
      } else if (status.isDenied) {
        // permission is denied
      } else if (status.isPermanentlyDenied) {
        // permission is permanently denied, navigate to app settings
      }
    } catch (e) {
      print('==================== ERROR DOWNLOADING ====================');
      print(e);
      Get.snackbar(
        'Error',
        'Error downloading video',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
      );
    }
  }
}
