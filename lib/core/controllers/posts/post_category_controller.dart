import 'package:get/get.dart';
import 'package:oldbutgold/core/models/post/post_category_model.dart';

class PostCategoryController extends GetxController {
  RxBool isLoading = false.obs;


  List<PostCategoryModel> categories = [
    PostCategoryModel(
      id: '1',
      name: 'Category 1'.tr,
      description: 'Description 1'.tr,
      image: 'assets/images/1.jpg',
    ),
    PostCategoryModel(
      id: '2',
      name: 'Category 2'.tr,
      description: 'Description 2'.tr,
      image: 'assets/images/2.jpg',
    ),
    PostCategoryModel(
      id: '3',
      name: 'Category 3'.tr,
      description: 'Description 3'.tr,
      image: 'assets/images/3.jpg',
    ),
    PostCategoryModel(
      id: '4',
      name: 'Category 4'.tr,
      description: 'Description 4'.tr,
      image: 'assets/images/4.jpg',
    ),
    PostCategoryModel(
      id: '5',
      name: 'Category 5'.tr,
      description: 'Description 5'.tr,
      image: 'assets/images/5.jpg',
    ),
  ];
}
