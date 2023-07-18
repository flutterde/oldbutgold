
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthMiddleware extends GetMiddleware {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  RouteSettings? redirect(String? route) {
    if (_auth.currentUser == null) {
      return const RouteSettings(name: '/auth/login');
    } else {
      return null;
    }
  }
}


class AuthRedirectMiddleware extends GetMiddleware {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  RouteSettings? redirect(String? route) {
    if (_auth.currentUser != null) {
      return const RouteSettings(name: '/');
    } else {
      return null;
    }
  }
}