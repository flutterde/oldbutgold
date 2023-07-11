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
              title: const Text('Login'),
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Form(
                    key: ctr.formKey,
                    child: Column(
                      children: [
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
                                  if (ctr.formKey.currentState!.validate()) {
                                    ctr.loginUser();
                                  }
                                },
                                child: const Text('Login'),
                              )),
                        const SizedBox(
                          height: 20,
                        ),
                        TextButton(
                          onPressed: () {
                            Get.toNamed('/auth/register');
                          },
                          child: const Text('Register'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
