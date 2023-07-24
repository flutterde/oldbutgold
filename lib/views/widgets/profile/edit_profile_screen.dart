import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/controllers/profile/edit_profile_controller.dart';

class EditProfileScreen extends GetWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: EditProfileController(),
        builder: (ctr) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Edit Profile'),
            ),
            body: SingleChildScrollView(
              child: Form(
                key: ctr.formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: ctr.nameController,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          ctr.updateUserDate();
                        },
                        child: const Text('Update')),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
