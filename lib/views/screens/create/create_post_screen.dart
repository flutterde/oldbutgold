import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/controllers/posts/create_post_controller.dart';
import '../../../core/controllers/posts/post_category_controller.dart';

class CreatePostScreen extends GetWidget {
  const CreatePostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    PostCategoryController pCateCList = Get.put(PostCategoryController());
    var items = pCateCList.categories;

    return GetBuilder(
        init: CreatePostController(),
        builder: (ctr) => Scaffold(
              appBar: AppBar(
                title: const Text('Create Post'),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 20,
                      ),
                      child: Form(
                        key: ctr.formKey,
                        child: Column(
                          children: [
                            ctr.pickedVideoFile != null
                                ? Column(
                                    children: [
                                      const SizedBox(
                                        height: 200,
                                        child: Icon(
                                          Icons.play_circle_outline_outlined,
                                          size: 60,
                                        ),
                                      ),
                                      Text(ctr.pickedVideoFile!.name),
                                    ],
                                  )
                                : SizedBox(
                                    child: Column(
                                      children: [
                                        ElevatedButton(
                                          onPressed: () async {
                                            await ctr.selectFile();
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                              Colors.yellow,
                                            ),
                                          ),
                                          child: const Text('Select Video'),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          'Video is required'.tr,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              color: Colors.red),
                                        ),
                                        Text(
                                          'video duration chould be between 45 seconds \n to 2 minutes  and less than 100 Mb'
                                              .tr,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              color: Colors.orange),
                                        ),
                                      ],
                                    ),
                                  ),
                            Text(
                              ctr.videoDuration == 0.0
                                  ? ''
                                  : ctr.videoDuration < 45 ||
                                          ctr.videoDuration > 120
                                      ? 'Invalid Video Duration'
                                      : 'Video Duration: ${ctr.videoDuration.toString()}',
                              style: TextStyle(
                                  color: ctr.videoDuration < 45 ||
                                          ctr.videoDuration > 120
                                      ? Colors.red
                                      : Colors.green),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: ctr.videoDescriptionCtr,
                              decoration: const InputDecoration(
                                labelText: 'Video Description',
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Video description is required';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Obx(
                              // ignore: unnecessary_null_comparison
                              () => items.length == null
                                  ? SizedBox(
                                      child: Text(
                                        'No Category to choose'.tr,
                                        textAlign: TextAlign.center,
                                        style:
                                            const TextStyle(color: Colors.red),
                                      ),
                                    )
                                  : DropdownButton(
                                      // ignore: unrelated_type_equality_checks
                                      value: ctr.selectedCategory.value == ''
                                          ? items[0].id
                                          : ctr.selectedCategory.value,
                                      isExpanded: true,
                                      iconSize: 36,
                                      icon: const Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.black,
                                      ),
                                      items:
                                          items.map<DropdownMenuItem>((value) {
                                        return DropdownMenuItem(
                                            value: value.id,
                                            child: Row(
                                              children: [
                                                const CircleAvatar(
                                                  backgroundColor: Colors.grey,
                                                  radius: 15,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(value.name ?? ''),
                                              ],
                                            ));
                                      }).toList(),
                                      onChanged: (newValue) {
                                        ctr.selectedCategory.value = newValue;
                                      },
                                    ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Obx(
                              () => Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey[200],
                                ),
                                height: 150,
                                width: double.infinity,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: TextFormField(
                                            controller: ctr.tagsCtr,
                                            decoration: InputDecoration(
                                              labelText: 'Add Tag'.tr,
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            ctr.addTag(ctr.tagsCtr.text);
                                            ctr.tagsCtr.clear();
                                          },
                                          icon: const Icon(Icons.add),
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: ctr.tags.isEmpty
                                          ? const Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text(
                                                'No Tags',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            )
                                          : ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: ctr.tags.length,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Chip(
                                                    label:
                                                        Text(ctr.tags[index]),
                                                    onDeleted: () {
                                                      ctr.tags.removeAt(index);
                                                    },
                                                  ),
                                                );
                                              },
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Obx(() => ctr.isLoading.value
                                ? Row(
                                    children: [
                                      Expanded(
                                        child: LinearProgressIndicator(
                                          value: ctr.uploadProgress.value,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                          '${(ctr.uploadProgress.value * 100).toStringAsFixed(2)} %'),
                                    ],
                                  )
                                : const SizedBox()),
                            const SizedBox(
                              height: 20,
                            ),
                            Obx(
                              () => ctr.isLoading.value
                                  ? const CircularProgressIndicator()
                                  : ElevatedButton(
                                      onPressed: () async {
                                        if (ctr.selectedCategory.value == '') {
                                          ctr.selectedCategory.value =
                                              items[0].id ?? '';
                                        }
                                        if (ctr.formKey.currentState!
                                            .validate()) {
                                          await ctr.createPost(
                                            ctr.videoDescriptionCtr.text,
                                            ctr.selectedCategory.value,
                                          );
                                        }
                                      },
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: Text(
                                          'Create Post'.tr,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                            ),
                           const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }
}
