import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';


class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final String postId;
  const VideoPlayerWidget(
      {super.key, required this.videoUrl, required this.postId});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController videoPlayerController;

 

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.network(
      widget.videoUrl,
    )..initialize().then((value) {
        videoPlayerController.play();
        videoPlayerController.setVolume(1);
        videoPlayerController.setLooping(true);
      });
    increaseViews(widget.postId);
  }

  Future<void> increaseViews(String postID) async {
    final dbPostsRef = FirebaseDatabase.instance.ref().child('posts');
    try {
       await dbPostsRef.child(postID).set({
        'views': ServerValue.increment(1),
      });
    } catch (e) {
      if (kDebugMode) {
        print('=========**===========');
        print(e);
        print('=========//==========');
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    RxBool isPlaying = true.obs;
    press() {
      if (isPlaying.value) {
        // Pause vieo
        videoPlayerController.pause();
        isPlaying.value = false;
      } else {
        // Play video
        videoPlayerController.play();
        isPlaying.value = true;
      }
    }

    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: size.width,
      decoration: const BoxDecoration(color: Color(0xff181D31)),
      child: InkWell(
          onTap: () {
            press();
          },
          child: Stack(
            children: [
              VideoPlayer(videoPlayerController),
              Center(
                  child: Obx(
                () => isPlaying.value
                    ? const SizedBox()
                    : InkWell(
                        onTap: () {
                          press();
                        },
                        child: const Icon(
                          Icons.play_arrow,
                          size: 80,
                          color: Colors.grey,
                        ),
                      ),
              )),
            ],
          )),
    );
  }
}