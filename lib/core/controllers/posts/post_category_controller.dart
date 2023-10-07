import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oldbutgold/core/models/post/post_category_model.dart';

class PostCategoryController extends GetxController {
  RxBool isLoading = false.obs;

  List<PostCategoryModel> categories = [
    PostCategoryModel(
      id: '1',
      name: 'music'.tr,
      description: 'Description 1'.tr,
      image: 'assets/images/1.jpg',
      color: Colors.red,
    ),
    PostCategoryModel(
      id: '2',
      name: 'comedy'.tr,
      description: 'Description 2'.tr,
      image: 'assets/images/2.jpg',
      color: Colors.blue,
    ),
    PostCategoryModel(
      id: '3',
      name: 'gaming'.tr,
      description: 'Description 3'.tr,
      image: 'assets/images/3.jpg',
      color: Colors.green,
    ),
    PostCategoryModel(
      id: '4',
      name: 'news'.tr,
      description: 'Description 4'.tr,
      image: 'assets/images/4.jpg',
      color: Colors.yellow,
    ),
    PostCategoryModel(
      id: '5',
      name: 'entertainment'.tr,
      description: 'Description 5'.tr,
      image: 'assets/images/5.jpg',
      color: Colors.purple,
    ),
    PostCategoryModel(
      id: '6',
      name: 'education'.tr,
      description: 'description',
      image: 'image',
      color: Colors.orange,
    ),
    PostCategoryModel(
      id: '7',
      name: 'people'.tr,
      description: 'description',
      image: 'image',
      color: Colors.redAccent,
    ),
    PostCategoryModel(
      id: '8',
      name: 'animals'.tr,
      description: 'description',
      image: 'image',
      color: Colors.blueAccent,
    ),
    PostCategoryModel(
      id: '9',
      name: 'travel'.tr,
      description: 'description',
      image: 'image',
      color: Colors.greenAccent,
    ),
    PostCategoryModel(
      id: '10',
      name: 'sports'.tr,
      description: 'description',
      image: 'image',
      color: Colors.grey,
    ),
    PostCategoryModel(
      id: '11',
      name: 'film'.tr,
      description: 'description',
      image: 'image',
      color: Colors.pinkAccent,
    ),
    PostCategoryModel(
      id: '12',
      name: 'series'.tr,
      description: 'description',
      image: 'image',
      color: Colors.purpleAccent,
    ),
    PostCategoryModel(
      id: '13',
      name: 'history'.tr,
      description: 'description',
      image: 'image',
      color: Colors.yellowAccent,
    ),
    PostCategoryModel(
      id: '14',
      name: 'art'.tr,
      description: 'description',
      image: 'image',
      color: Colors.lightGreenAccent,
    ),
    PostCategoryModel(
      id: '15',
      name: 'food'.tr,
      description: 'description',
      image: 'image',
      color: Colors.lightBlueAccent,
    ),
    PostCategoryModel(
      id: '16',
      name: 'fashion'.tr,
      description: 'description',
      image: 'image',
      color: Colors.deepOrangeAccent,
    ),
    PostCategoryModel(
      id: '17',
      name: 'war'.tr,
      description: 'description',
      image: 'image',
      color: Colors.deepPurpleAccent,
    ),
  ];
}
