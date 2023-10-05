import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
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
              title: Text('login'.tr),
            ),
            body: SingleChildScrollView(
              child: Stack(children: [
                Column(
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
                            Obx(() => TextFormField(
                                  controller: ctr.passwordController,
                                  obscureText: !ctr.isPasswordVisible.value,
                                  decoration: InputDecoration(
                                    hintText: 'enter_your_password'.tr,
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        ctr.isPasswordVisible.value =
                                            !ctr.isPasswordVisible.value;
                                      },
                                      icon: ctr.isPasswordVisible.value
                                          ? const Icon(Icons.visibility)
                                          : const Icon(Icons.visibility_off),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty ||
                                        value.trim().length < 6) {
                                      return 'please_enter_your_password'.tr;
                                    }
                                    return null;
                                  },
                                )),
                            const SizedBox(
                              height: 10,
                            ),
                            TextButton(
                              onPressed: () {
                                Get.toNamed('/auth/reset');
                              },
                              child: Text('forgot_password'.tr),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                FocusScope.of(context).unfocus();
                                if (ctr.formKey.currentState!.validate()) {
                                  ctr.loginUser();
                                }
                              },
                              child: SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    'login'.tr,
                                    textAlign: TextAlign.center,
                                  )),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextButton(
                              onPressed: () {
                                Get.toNamed('/auth/register');
                              },
                              child: Text('dont_have_an_account'.tr),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
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
                        ctr.loginWithGoogle();
                      },
                    ),
                  ],
                ),
                Obx(() => ctr.isLoading.value
                    ? Center(
                        child: Container(
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
                        ),
                      )
                    : const SizedBox()),
              ]),
            ),
          );
        });
  }
}
