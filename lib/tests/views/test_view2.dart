import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/test_view.dart';

class TestView2 extends StatelessWidget {
  const TestView2({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: TestViewController(),
      builder: (ctr) => Scaffold(
        appBar: AppBar(
          title: const Text('TestView2'),
        ),
      body:Obx(()=> ctr.isLoading.value == true ? const Center(child: CircularProgressIndicator(),) : ListView.builder(
        itemCount: ctr.posts.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(ctr.posts[index].content!),
            subtitle: Text(ctr.posts[index].author!.name!),
          );
        },
      ))
      ),
    );
  }
}
