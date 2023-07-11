import 'package:get/get.dart';

import '../../tests/views/add.dart';
import '../../views/screens/auth/login_screen.dart';
import '../../views/screens/auth/register_screen.dart';
import '../../views/screens/create/create_post_screen.dart';
import '../../views/screens/mains/feed/feed_screen.dart';

var appRoutes = [
  GetPage(name: '/post/create', page: () => const CreatePostScreen()),
  GetPage(name: '/', page: () => const AddTest()),


  // auth
  GetPage(name: '/auth/register', page: ()=> const RegisterUserScreen()),
  GetPage(name: '/auth/login', page: ()=> const LoginUserScreen()),


  // main screens
  GetPage(name: '/main/feed', page: ()=> const FeedScreen()),
];
