import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/auth/register_controller.dart';

class RegisterController extends GetWidget {
  const RegisterController({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: RegisterAuthController(),
        builder: (ctr) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Register'),
            ),
            body: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Register Screen',
                  ),
                ],
              ),
            ),
          );
        });
  }
}
