



import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/models/user/user_model.dart';

Widget userListSearchWidget(UserModel user) {
  return ListTile(
    leading: CircleAvatar(
      backgroundImage: NetworkImage(user.profilePic!),
    ),
    title: Text(user.name!),
    subtitle: Text("${'from'.tr} ${user.country ?? '*'}"),
  );
}