import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool? seenOnboard;
  getSplashState() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    seenOnboard = pref.getBool('onboardingshowed') ?? false;
  }

  @override
  void initState() {
    super.initState();
    getSplashState();
    _skipToPages();
  }

  void _skipToPages() async {
    await Future.delayed(const Duration(milliseconds: 5000));
    Get.offAndToNamed(seenOnboard == false ? '/splashlang' : '/');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      body: Center(
        child: Lottie.asset(
          'assets/animations/welcome.json',
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
