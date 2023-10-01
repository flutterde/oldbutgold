import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/controllers/posts/single_post_wd_controller.dart';

class SinglePostScreenWidget extends GetWidget {
  const SinglePostScreenWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: SinglePostWdController(),
        builder: (ctr) => Scaffold(
              appBar: AppBar(
                title: Text('Single Post Screen'.tr),
                centerTitle: true,
              ),
              body: Center(
                child: Text('Single Post Screen'.tr),
              ),
            ));
  }
}
