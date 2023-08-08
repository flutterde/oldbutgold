import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:get/get.dart';

import '../../../core/auth/register_controller.dart';

class RegisterUserScreen extends GetWidget {
  const RegisterUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: RegisterAuthController(),
        builder: (ctr) {
          return Scaffold(
            appBar: AppBar(
              title: Text('register'.tr),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Form(
                              key: ctr.formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: ctr.nameController,
                                    decoration: InputDecoration(
                                      hintText: 'enter_your_name'.tr,
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'please_enter_your_name'.tr;
                                      }
                                      return null;
                                    },
                                  ),
                                  TextFormField(
                                    controller: ctr.emailController,
                                    decoration: InputDecoration(
                                      hintText: 'enter_your_email'.tr,
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty || !value.isEmail) {
                                        return 'Please enter your email';
                                      }
                                      return null;
                                    },
                                  ),
                                  TextFormField(
                                    controller: ctr.passwordController,
                                    decoration: InputDecoration(
                                      hintText: 'enter_your_password'.tr,
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty ||
                                          value.trim().length < 6) {
                                        return 'password_should_be_longer_than_6_characters'
                                            .tr;
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Obx(() => ctr.isLoading.value
                                      ? const CircularProgressIndicator()
                                      : ElevatedButton(
                                          onPressed: () {
                                            FocusScope.of(context).unfocus();
                                            if (ctr.formKey.currentState!
                                                .validate()) {
                                              ctr.registerNewUser();
                                            }
                                          },
                                          child: Text('register'.tr),
                                        )),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextButton(
                          onPressed: () {
                            Get.toNamed('/auth/login');
                          },
                          child: Text('login'.tr),
                        ),
                        const SizedBox(
                          height: 20,
                        ),

                        // social login
                        Row(
                          children: [
                            const Divider(),
                            Text('or'.tr),
                            const Divider(),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SignInButton(
                          Buttons.Google,
                          text: "continue_with_google".tr,
                          onPressed: () {
                            ctr.registerWithGoogle();
                          },
                        ),
                      ],
                    ),
                    Obx(() => ctr.isLoading.value
                        ? Container(
                            height: Get.height,
                            width: Get.width,
                            color: Colors.black.withOpacity(0.5),
                            child: Center(
                              child: Column(
                                children: [
                                  Text('loading'.tr),
                                  const CircularProgressIndicator(),
                                ],
                              ),
                            ),
                          )
                        : const SizedBox()),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
