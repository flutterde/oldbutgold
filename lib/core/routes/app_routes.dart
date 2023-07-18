import 'package:get/get.dart';

import '../../tests/views/add.dart';
import '../../views/screens/auth/login_screen.dart';
import '../../views/screens/auth/register_screen.dart';
import '../../views/screens/create/create_post_screen.dart';
import '../../views/screens/mains/feed/feed_screen.dart';
import '../../views/screens/mains/main_page.dart';
import '../../views/screens/notifications/notification_screen.dart';
import '../middlewares/auth_middlewares.dart';

var appRoutes = [
  GetPage(name: '/post/create', page: () => const CreatePostScreen(), middlewares: [AuthMiddleware()]),
  GetPage(name: '/test', page: () => const AddTest(), middlewares: [AuthMiddleware()]),


  // auth
  GetPage(name: '/auth/register', page: ()=> const RegisterUserScreen(), middlewares: [AuthRedirectMiddleware()]),
  GetPage(name: '/auth/login', page: ()=> const LoginUserScreen(), middlewares: [AuthRedirectMiddleware()]),


  // main screens

  GetPage(name: '/', page: ()=> const MainPage(), middlewares: [AuthMiddleware()]),
  GetPage(name: '/main/feed', page: ()=> const FeedScreen(), middlewares: [AuthMiddleware()]),


  // notifications
  GetPage(name: '/notifications/announcement', page: ()=> const NotificationScreen(), middlewares: [AuthMiddleware()]),
];
