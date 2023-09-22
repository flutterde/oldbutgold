import 'dart:io';

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
              title: Text('edit_profile'.tr),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Form(
                  key: ctr.formKey,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      ctr.pickedImageFile == null
                          ? CircleAvatar(
                              radius: 60,
                              backgroundImage:
                                  Image.network(ctr.user.profilePic!).image,
                              child: IconButton(
                                onPressed: () {
                                  ctr.selectFile();
                                },
                                icon: const Icon(
                                  Icons.camera_alt,
                                  size: 30,
                                  color: Colors.grey,
                                ),
                              ))
                          : CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  FileImage(File(ctr.pickedImageFile!.path!)),
                              child: IconButton(
                                onPressed: () {
                                  ctr.selectFile();
                                },
                                icon: const Icon(
                                  Icons.camera_alt,
                                  size: 30,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                      TextFormField(
                        controller: ctr.nameController,
                        decoration: InputDecoration(
                          labelText: 'name'.tr,
                        ),
                        maxLength: 20,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please_enter_your_name'.tr;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: ctr.bioController,
                        decoration: InputDecoration(
                          labelText: 'bio'.tr,
                        ),
                        maxLength: 70,
                        minLines: 2,
                        maxLines: 5,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please_enter_your_bio'.tr;
                          }
                          return null;
                        },
                      ),
                      Obx(
                        () => ctr.isLoading.value
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                  if (ctr.formKey.currentState!.validate()) {
                                    ctr.updateUserData(ctr.nameController.text,
                                        ctr.bioController.text);
                                  }
                                },
                                child: SizedBox(
                                    width: double.infinity,
                                    child: Text(
                                      'update_profile'.tr,
                                      textAlign: TextAlign.center,
                                    )),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
