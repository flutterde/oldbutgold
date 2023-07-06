import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oldbutgold/tests/views/test_view2.dart';

import '../controllers/add.dart';

class AddTest extends GetWidget {
  const AddTest({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: AddCtrTest(),
        builder: (ctr) => Scaffold(
              appBar: AppBar(
                title: const Text('Add Test'),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => ctr.login(),
                      child: const Text('Login'),
                    ),
                    ElevatedButton(
                      onPressed: () => ctr.addTest(),
                      child: const Text('Add Test'),
                    ),
                    ElevatedButton(
                      onPressed: () => Get.to(const TestView2()),
                      child: const Text('view posts'),
                    ),
                    ElevatedButton(
                      onPressed: () => Get.toNamed('/post/create'),
                      child: const Text('Create Post'),
                    )
                  ],
                ),
              ),
            ));
  }
}
