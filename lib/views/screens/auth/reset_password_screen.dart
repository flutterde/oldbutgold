import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/auth/reset_password_controller.dart';

class ResetPasswordScreen extends GetWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: ResetPasswordController(),
        builder: (ctr) => Scaffold(
              appBar: AppBar(
                title: Text('reset_password'.tr),
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
                                controller: ctr.emailController,
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
                              Obx(() => ctr.isLoading.value
                                  ? const CircularProgressIndicator()
                                  : ElevatedButton(
                                      onPressed: () {
                                        if (ctr.formKey.currentState!
                                            .validate()) {
                                          ctr.resetPass(
                                              ctr.emailController.text);
                                        }
                                      },
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: Text('reset_password'.tr , textAlign: TextAlign.center,),)),
                                    )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }
}
