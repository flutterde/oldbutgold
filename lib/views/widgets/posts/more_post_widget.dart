import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:oldbutgold/core/models/post/post_model.dart';

import '../../../core/controllers/downloads/download_post_controller.dart';
import '../../../core/controllers/reports/post_report_controller.dart';

Future<dynamic> morePostWidget(PostModel post) async {
  final DownloadPostController downloadCtr = Get.put(DownloadPostController());
  final PostReportController reportCtr = Get.put(PostReportController());
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
            IconButton(
                onPressed: () {
                  reportCtr.reportPost(post.id!);
                },
                icon: Obx(
                  () => reportCtr.isLoading.value
                      ? const Icon(Icons.autorenew_sharp)
                      : const Icon(Icons.report),
                )),
            const SizedBox(
              height: 10,
            ),
            Obx(() => Text(
                  reportCtr.isLoading.value ? 'load'.tr : 'report'.tr,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )),
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
                        '${'download'.tr} ${downloadCtr.progress.value.toStringAsFixed(0)}%')),
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
            Text(
              'download'.tr,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        )),
        Expanded(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(onPressed: () async{
             // await Clipboard.setData(ClipboardData(text: "https://old-butgold.web.app/post/${post.id}"));
              Get.back();
              Get.snackbar('sorry'.tr, 'you_cannot_copy'.tr, backgroundColor: Colors.red);
            }, icon: const Icon(Icons.copy)),
            const SizedBox(
              height: 10,
            ),
            Text(
              'copy_link'.tr,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        )),
      ]),
    ),
  );
}
