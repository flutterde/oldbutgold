import 'package:flutter/material.dart';
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
              title: const Text('Register'),
            ),
            body: SingleChildScrollView(
              child: Column(
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
                              decoration: const InputDecoration(
                                hintText: 'Enter your name',
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: ctr.emailController,
                              decoration: const InputDecoration(
                                hintText: 'Enter your email',
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
                              decoration: const InputDecoration(
                                hintText: 'Enter your password',
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your password';
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
                                      if (ctr.formKey.currentState!
                                          .validate()) {
                                        ctr.registerNewUser();
                                      }
                                    },
                                    child: const Text('Register'),
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
                    child: const Text('Login'),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
