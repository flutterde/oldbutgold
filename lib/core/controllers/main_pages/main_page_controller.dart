import 'package:get/get.dart';

import '../../../views/screens/create/create_post_screen.dart';
import '../../../views/screens/mains/feed/feed_screen.dart';
import '../../../views/screens/search/search_screen.dart';
import '../../../views/widgets/profile/profile_screen.dart';


class MainPageController extends GetxController {
  int index = 0;
  selectedPage(destinationIndex) {
    index = destinationIndex;
    update();
  }

  final mainScreens = [
    const FeedScreen(),
    const SearchScreen(),


    const CreatePostScreen(),
    // Profile
    const ProfileScreen(),

  ];
}