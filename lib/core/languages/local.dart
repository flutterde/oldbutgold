import 'package:get/get.dart';

import 'langs/ar.dart';
import 'langs/en.dart';
import 'langs/es.dart';
import 'langs/fr.dart';

class AppLocal implements Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': en,
        'ar': ar,
        'fr': fr,
        'es': es,
      };
}