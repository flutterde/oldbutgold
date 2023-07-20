import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/languages/local_controller.dart';

class LanguageWidget extends StatelessWidget {
  const LanguageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: AppLocalController(),
      builder: ((controller) => Directionality(
            textDirection: TextDirection.ltr,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black, width: 1)),
                child: DropdownButton<String>(
                  isExpanded: true,
                  dropdownColor: Colors.white,
                  value: controller.saveLang.value,
                  icon: const Padding(
                    padding: EdgeInsets.only(left: 8, right: 8),
                    child: Icon(
                      Icons.arrow_downward,
                      size: 20,
                      color: Colors.purple,
                    ),
                  ),
                  underline: Container(
                    color: Colors.white,
                  ),
                  elevation: 16,
                  style: const TextStyle(color: Colors.grey),
                  onChanged: (String? newValue) {
                    controller.saveLang.value = newValue!;
                    Get.updateLocale(Locale(newValue.toLowerCase()));
                    controller.saveLocale();
                  },
                  items: controller.langsList
                      .map<DropdownMenuItem<String>>((value) {
                    return DropdownMenuItem<String>(
                        value: value.key,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(2),
                              child: Text(
                                value.flag,
                              ),
                            ),
                            Text(value.name),
                          ],
                        ));
                  }).toList(),
                ),
              ),
            ),
          )),
    );
  }
}