import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';





class AddT extends StatefulWidget {
  const AddT({super.key});

  @override
  State<AddT> createState() => _AddTState();
}

class _AddTState extends State<AddT> {


  final dbPostsRef = FirebaseDatabase.instance.ref().child('tests');
  Future<void> inc() async {
    try {
      //
      await dbPostsRef.child('123').set({
        'views': ServerValue.timestamp,
      });
    } catch (e) {
      //
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Text('AddT'),
            ElevatedButton(onPressed: () {
              inc();
            }, child: const Text('Add Now')),
          ],
        ),
      ),
    );
  }
}
