import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oldbutgold/core/models/post/post_model.dart';

import '../../../core/controllers/downloads/download_post_controller.dart';

Future<dynamic> morePostWidget(PostModel post) async {
  final DownloadPostController downloadCtr = Get.put(DownloadPostController());
  final scaffoldMessenger = ScaffoldMessenger.of(Get.context!);
  return await Get.bottomSheet(
    Container(
      height: Get.height * 0.25,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 5,
            spreadRadius: 0.5,
            offset: Offset(0.7, 0.7),
          ),
        ],
      ),
      child: Row(children: [
        const SizedBox(
          height: 10,
        ),
        Expanded(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.report)),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Report',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        )),
        Expanded(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.download_for_offline_rounded),
              onPressed: () {
                Get.back();
                scaffoldMessenger.showSnackBar(
                  SnackBar(
                    content: Obx(() => Text(
                        'Downloading ${downloadCtr.progress.value.toStringAsFixed(0)}%')),
                    duration: const Duration(seconds: 100),
                  ),
                );
                downloadCtr
                    .downloadVideo(post.videoUrl!, post.videoExtension!)
                    .then((value) {
                  Future.delayed(const Duration(seconds: 2), () {
                    scaffoldMessenger.hideCurrentSnackBar();
                    downloadCtr.progress.value = 0.0;
                  });
                });
              },
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Download',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        )),
        Expanded(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.copy)),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Copy Link',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        )),
      ]),
    ),
  );
}
