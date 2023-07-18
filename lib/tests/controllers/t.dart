import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class Tctr extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

 Future<void> f()async {
    var t = FieldValue.serverTimestamp();
    try{
      //
      await FirebaseFirestore.instance.collection('times').doc('1').set({
        'name': 'name',
        'createdAt': t,
      });

    } catch(e) {
      print('==============================================');
      print(e);
      print('==============================================');
    }

  }
}
