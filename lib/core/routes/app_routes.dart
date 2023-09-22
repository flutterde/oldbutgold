import 'package:get/get.dart';

import '../../onboarding/views/onboarding_page.dart';
import '../../onboarding/views/splash_lang_page.dart';
import '../../onboarding/views/splash_page.dart';
import '../../tests/views/add.dart';
import '../../tests/views/add_t.dart';
import '../../views/screens/auth/login_screen.dart';
import '../../views/screens/auth/register_screen.dart';
import '../../views/screens/auth/reset_password_screen.dart';
import '../../views/screens/create/create_post_screen.dart';
import '../../views/screens/mains/feed/feed_screen.dart';
import '../../views/screens/mains/main_page.dart';
import '../../views/screens/notifications/anouncements_screen.dart';
import '../../views/screens/post/single_post_screen.dart';
import '../../views/widgets/comments/comments_screen.dart';
import '../../views/widgets/profile/edit_profile_screen.dart';
import '../../views/widgets/profile/other_users_profile.dart';
import '../../views/widgets/profile/profile_actions_screen.dart';
import '../../views/widgets/profile/profile_screen.dart';
import '../middlewares/auth_middlewares.dart';

var appRoutes = [
  GetPage(name: '/splash', page: () => const SplashPage()),
  GetPage(name: '/post/create', page: () => const CreatePostScreen(), middlewares: [AuthMiddleware()]),
  GetPage(name: '/test', page: () => const AddTest(), middlewares: [AuthMiddleware()]),


  // auth
  GetPage(name: '/auth/register', page: ()=> const RegisterUserScreen(), middlewares: [AuthRedirectMiddleware()]),
  GetPage(name: '/auth/login', page: ()=> const LoginUserScreen(), middlewares: [AuthRedirectMiddleware()]),
  GetPage(name: '/auth/reset', page: ()=> const ResetPasswordScreen(), middlewares: [AuthRedirectMiddleware()]),

  // main screens
  GetPage(name: '/', page: ()=> const MainPage(), middlewares: [AuthMiddleware()]),
  GetPage(name: '/main/feed', page: ()=> const FeedScreen(), middlewares: [AuthMiddleware()]),
  GetPage(name: '/main/comments', page: ()=> const CommentsScreen(), middlewares: [AuthMiddleware()]),

  GetPage(name: '/post/:id', page: ()=> const SinglePostScreen(), middlewares: [AuthMiddleware()]),
  // notifications
  GetPage(name: '/notifications/announcement', page: ()=> const AnnouncementsScreen(), middlewares: [AuthMiddleware()]),

  GetPage(name: '/splashlang', page: () => const SplashLangPage()),
  GetPage(name: '/onboarding', page: () => OnboardingPage()),

  // tests
  GetPage(name: '/test2', page: ()=> const AddT(), middlewares: [AuthMiddleware()]),
  

  // profile
  GetPage(name: '/edit-profile', page: ()=> const EditProfileScreen(), middlewares: [AuthMiddleware()]),
  GetPage(name: '/profile/actions', page: ()=> const ProfileActionsScreen(), middlewares: [AuthMiddleware()]),
  GetPage(name: '/profile', page: ()=> const ProfileScreen(), middlewares: [AuthMiddleware()]),
  GetPage(name: '/users/profile', page: ()=> const OtherUsersProfile(), middlewares: [AuthMiddleware()]),
  GetPage(name: '/users/profile/:id', page: ()=> const OtherUsersProfile(), middlewares: [AuthMiddleware()]),
];
