import 'package:get/get.dart';

import '../../tests/views/add.dart';
import '../../views/screens/create/create_post_screen.dart';

var appRoutes = [
  GetPage(name: '/post/create', page: () => const CreatePostScreen()),
  GetPage(name: '/', page: () => const AddTest()),
];
