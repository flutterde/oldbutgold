import 'package:get/get.dart';

import 'langs/ar.dart';
import 'langs/de.dart';
import 'langs/en.dart';
import 'langs/es.dart';
import 'langs/fr.dart';
import 'langs/id.dart';
import 'langs/it.dart';
import 'langs/pt.dart';
import 'langs/ru.dart';
import 'langs/tr.dart';

class AppLocal implements Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': en,
        'ar': ar,
        'fr': fr,
        'es': es,
        'pt': pt,
        'de': de,
        'id': id,
        'ru': ru,
        'it': it,
        'tr': tr,
      };
}