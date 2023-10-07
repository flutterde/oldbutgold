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
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      hintText: 'enter_your_email'.tr,
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty || !value.isEmail) {
                                        return 'please_enter_your_email'.tr;
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    'gender'.tr,
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Obx(() {
                                    return Column(
                                      children: [
                                        ListTile(
                                          title: Text('male'.tr),
                                          leading: Radio<String>(
                                            value: 'male',
                                            groupValue: ctr.gender!.value,
                                            onChanged: (value) {
                                              //
                                              ctr.gender!.value = value!;
                                            },
                                          ),
                                        ),
                                        ListTile(
                                          title: Text('female'.tr),
                                          leading: Radio<String>(
                                            value: 'female',
                                            groupValue: ctr.gender!.value,
                                            onChanged: (value) {
                                              ctr.gender!.value = value!;
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                                  Obx(() => 
                                  TextFormField(
                                    controller: ctr.passwordController,
                                    obscureText:
                                        !ctr.isPasswordVisible.value,
                                    decoration: InputDecoration(
                                      hintText: 'enter_your_password'.tr,
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          ctr.isPasswordVisible.value =
                                              !ctr.isPasswordVisible.value;
                                        },
                                        icon: ctr.isPasswordVisible.value
                                            ? const Icon(Icons.visibility)
                                            : const Icon(
                                                Icons.visibility_off),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value!.isEmpty ||
                                          value.trim().length < 6) {
                                        return 'password_should_be_longer_than_6_characters'
                                            .tr;
                                      }
                                      return null;
                                    },
                                  )),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      FocusScope.of(context).unfocus();
                                      if (ctr.formKey.currentState!
                                          .validate()) {
                                        ctr.registerNewUser();
                                      }
                                    },
                                    child: SizedBox(
                                        width: double.infinity,
                                        child: Text(
                                          'register'.tr,
                                          textAlign: TextAlign.center,
                                        )),
                                  ),
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
                          child: Text('already_have_an_account'.tr),
                        ),
                        const SizedBox(
                          height: 20,
                        ),

                        // social login
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Expanded(
                              child: Divider(
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text('or'.tr),
                            const SizedBox(
                              width: 10,
                            ),
                            const Expanded(
                              child: Divider(
                                color: Colors.grey,
                              ),
                            ),
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
                            padding: EdgeInsets.only(top: Get.height * 0.3),
                            height: Get.height,
                            width: Get.width,
                            color: Colors.black.withOpacity(0.5),
                            child: Center(
                              child: Column(
                                children: [
                                  Text(
                                    'loading'.tr,
                                    style: const TextStyle(color: Colors.white),
                                  ),
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
