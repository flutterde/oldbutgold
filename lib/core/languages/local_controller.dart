import 'dart:ui';
import 'package:get/get.dart';

import '../models/lang/lang_model.dart';
import '../services/pref_service.dart';



class AppLocalController extends GetxController {
  final PrefService _prefService = PrefService();
  var saveLang = 'EN'.obs;

  List<LanguageModel> langsList = [
    LanguageModel('English', 'EN', 'assets/images/flags/english.png'),
    LanguageModel('العربية', 'AR', 'assets/images/flags/arab.png'),
    LanguageModel('Français', 'FR', 'assets/images/flags/french.png'),
    LanguageModel('Español', 'ES', 'assets/images/flags/spain.png'),
  ];

  saveLocale() {
    _prefService.createString('locale', saveLang.value);
  }

  Future<void> setLocale() async {
    _prefService.readString('locale').then((value) {
      if (value != '' && value != null) {
        Get.updateLocale(Locale(value.toString().toLowerCase()));
        saveLang.value = value.toString();
        update();
      }
    });
  }

  @override
  void onInit() async {
    setLocale();
    super.onInit();
  }
}