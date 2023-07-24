import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/controllers/profile/profile_controller.dart';
import 'profile_card.dart';

class ProfileScreen extends GetWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: Get.put(ProfileConntroller(), permanent: true),
        builder: (ctr) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Profile'),
            ),
            body: Obx(()=> ctr.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        profileCard(ctr.user!),
                      ],
                    ),
                  )),
          );
        });
  }
}
