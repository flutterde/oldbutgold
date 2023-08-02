import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/controllers/profile/profile_actions_controller.dart';
import '../language_widget.dart';

class ProfileActionsScreen extends GetWidget {
  const ProfileActionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: ProfileActionsController(),
        builder: (ctr) => Scaffold(
              appBar: AppBar(
                title:  Text('profile_actions'.tr),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    const LanguageWidget(),
                    ListTile(
                      onTap: () {
                        ctr.signOut();
                      },
                      leading: const Icon(Icons.logout),
                      title:  Text('sign_out'.tr),
                    ),
                  ],
                ),
              ),
            ));
  }
}
