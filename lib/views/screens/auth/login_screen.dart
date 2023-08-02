import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/auth/login_controller.dart';

class LoginUserScreen extends GetWidget {
  const LoginUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: LoginController(),
        builder: (ctr) {
          return Scaffold(
            appBar: AppBar(
              title:  Text('login'.tr),
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: ctr.formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: ctr.emailController,
                            decoration:  InputDecoration(
                              hintText: 'enter_your_email'.tr,
                            ),
                            validator: (value) {
                              if (value!.isEmpty || !value.isEmail) {
                                return 'please_enter_your_email'.tr;
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: ctr.passwordController,
                            decoration:  InputDecoration(
                              hintText: 'enter_your_password'.tr,
                            ),
                            validator: (value) {
                              if (value!.isEmpty || value.trim().length < 6) {
                                return 'please_enter_your_password'.tr;
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
                                    if (ctr.formKey.currentState!.validate()) {
                                      ctr.loginUser();
                                    }
                                  },
                                  child:  Text('login'.tr),
                                )),
                          const SizedBox(
                            height: 20,
                          ),
                          TextButton(
                            onPressed: () {
                              Get.toNamed('/auth/register');
                            },
                            child:  Text('register'.tr),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
