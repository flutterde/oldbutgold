import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/auth/login_controller.dart';


class LoginScreen extends GetWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: LoginController(),
        builder: (ctr) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Login'),
            ),
            body: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Login Screen',
                  ),
                ],
              ),
            ),
          );
        });
  }
}
