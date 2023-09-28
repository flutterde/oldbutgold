import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../views/screens/mains/feed/feed_screen.dart';
import '../../../views/screens/notifications/notifications_screen.dart';
import '../../../views/screens/search/search_screen.dart';
import '../../../views/widgets/profile/profile_screen.dart';

class MainPageController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  int nCount = 0;
  int index = 0;
  selectedPage(destinationIndex) {
    index = destinationIndex;
    update();
  }

  final mainScreens = [
    const FeedScreen(),
    const SearchScreen(),
    const NotificationsScreen(),
    const ProfileScreen(),
  ];

  Future<int> getNotificationsCount() async {
    try {
      AggregateQuerySnapshot query = await _firestore
          .collectionGroup('notifications')
          .where('post_owner_id', isEqualTo: _auth.currentUser!.uid)
          .where('is_read', isEqualTo: false)
          .orderBy('created_at', descending: true)
          .count()
          .get();
      return (query.count);
    } catch (e) {
      print(e);
    }
    return (0);
  }

  @override
  void onInit() async {
    nCount = await getNotificationsCount();
    update();
    super.onInit();
  }
}
