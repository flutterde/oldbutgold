import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/apis/firebase_api.dart';
import 'core/bindings/initial_binding.dart';
import 'core/languages/local.dart';
import 'core/languages/local_controller.dart';
import 'core/routes/app_routes.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

bool? seenOnboard;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotifications();
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.debug,
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
  );
  await dotenv.load(fileName: ".env");
  SharedPreferences pref = await SharedPreferences.getInstance();
  seenOnboard = pref.getBool('onboardingshowed') ?? false;
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Get.put(AppLocalController());
    return GetMaterialApp(
      title: 'Old But Gold',
      unknownRoute: appRoutes[0],
      getPages: appRoutes,
      theme: ThemeData.dark().copyWith(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.dark,
      locale: const Locale('en'),
      fallbackLocale: const Locale('en'),
      translations: AppLocal(),
      initialRoute: '/splash',
      debugShowCheckedModeBanner: false,
      initialBinding: InitialBinding(),
    );
  }
}
