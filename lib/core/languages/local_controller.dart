import 'dart:ui';
import 'package:get/get.dart';

import '../models/lang/lang_model.dart';
import '../services/pref_service.dart';



class AppLocalController extends GetxController {
  final PrefService _prefService = PrefService();
  var saveLang = 'EN'.obs;

  List<LanguageModel> langsList = [
    LanguageModel('English         ', 'EN', 'assets/images/flags/english.png'),
    LanguageModel('العربية        ', 'AR', 'assets/images/flags/arabic.png'),
    LanguageModel('Français        ', 'FR', 'assets/images/flags/french.png'),
    LanguageModel('Español         ', 'ES', 'assets/images/flags/spain.png'),
    LanguageModel('Português       ', 'PT', 'assets/images/flags/portugal.png'),
    LanguageModel('Deutsche        ', 'DE', 'assets/images/flags/german.png'),
    LanguageModel('Bahasa Indonesia', 'ID', 'assets/images/flags/indonesia.png'),
    LanguageModel('русский         ', 'RU', 'assets/images/flags/russia.png'),
    LanguageModel('Italiano        ', 'IT', 'assets/images/flags/italy.png'),
    LanguageModel('Türk            ', 'TR', 'assets/images/flags/turkey.png'),
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