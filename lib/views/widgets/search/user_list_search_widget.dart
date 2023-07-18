



import 'package:flutter/material.dart';

import '../../../core/models/user/user_model.dart';

Widget userListSearchWidget(UserModel user) {
  return ListTile(
    title: Text(user.name!),
    subtitle: Text(user.email!),
  );
}