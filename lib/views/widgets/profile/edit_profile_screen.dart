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
              title: const Text('Edit Profile'),
            ),
            body: SingleChildScrollView(
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
                          ctr.updateUserData(ctr.nameController.text);
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
