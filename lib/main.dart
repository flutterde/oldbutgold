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

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  // shared preferences
  SharedPreferences pref = await SharedPreferences.getInstance();

  // firebase
  await Firebase.initializeApp();

  // notifications
  await FirebaseApi().initNotifications();

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
      getPages: appRoutes,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      locale: const Locale('en'),
      fallbackLocale: const Locale('en'),
      translations: AppLocal(),
      initialRoute: '/',
      debugShowCheckedModeBanner: false,
      initialBinding: InitialBinding(),
    );
  }
}
