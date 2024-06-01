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
                title: Text('create_post'.tr),
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
                                      const SizedBox(
                                        height: 10,
                                      ),
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
                                        child: Text('select_video'.tr),
                                      ),
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
                                          child: Text('select_video'.tr),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          'video_is_required'.tr,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              color: Colors.red),
                                        ),
                                        Text(
                                          'video_duration_should_be_between_45sec_to_3_min'
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
                                          ctr.videoDuration > 180
                                      ? 'invalid_video_duration'.tr
                                      : '${'video_duration'.tr} ${ctr.videoDuration.toString()}',
                              style: TextStyle(
                                  color: ctr.videoDuration < 45 ||
                                          ctr.videoDuration > 180
                                      ? Colors.red
                                      : Colors.green),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: ctr.videoDescriptionCtr,
                              maxLength: 90,
                              minLines: 2,
                              maxLines: 4,
                              decoration: InputDecoration(
                                labelText: 'video_description'.tr,
                              ),
                              validator: (value) {
                                if (value!.isEmpty || value.trim().isEmpty) {
                                  return 'video_description_is_required'.tr;
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
                                        'no_category_to_select'.tr,
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
                                                CircleAvatar(
                                                  backgroundColor: value.color,
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
                                  color: Colors.grey[800],
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
                                              labelText: 'add_tags'.tr,
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
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                'no_tags'.tr,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
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
                                        FocusScope.of(context).unfocus();
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
                                          'create_post'.tr,
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
