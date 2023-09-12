import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/controllers/main_pages/search_controller.dart';
import '../../widgets/search/search4user_widget.dart';
import '../../widgets/search/user_list_search_widget.dart';

class SearchScreen extends GetWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: SearchScreenController(),
        builder: (ctr) {
          return Scaffold(
            appBar: AppBar(
              title: Form(
                key: ctr.formKey,
                child: TextFormField(
                  controller: ctr.searchCtr,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'search_here'.tr,
                    border: InputBorder.none,
                  ),
                  onFieldSubmitted: (value) {
                    ctr.search();
                  },
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    ctr.clearSearch();
                  },
                  icon: const Icon(Icons.clear),
                ),
              ],
            ),
            body: Obx(
              () => ctr.isLoading.value == false && ctr.users.isEmpty
                  ? search4UserWidget()
                  : ctr.isLoading.value == true && ctr.users.isEmpty
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          itemCount: ctr.users.length,
                          itemBuilder: (context, index) {
                            return userListSearchWidget(ctr.users[index]);
                          },
                        ),
            ),
          );
        });
  }
}
