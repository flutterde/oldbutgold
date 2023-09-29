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

class CaptionController extends GetxController {
  var captionText = ''.obs;

  void updateCaption(String text) {
    captionText.value = text;
    update();
  }
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController videoPlayerController;
  late CaptionController captionController;

  @override
  void initState() {
    super.initState();
    captionController = Get.put(CaptionController());
    videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl),
      httpHeaders: {'accept': '*/*'},
      closedCaptionFile: _loadCaptions(),
    )..initialize().then((value) {
        videoPlayerController.play();
        videoPlayerController.setVolume(1);
        videoPlayerController.setLooping(true);
        videoPlayerController.addListener(() {
          captionController
              .updateCaption(videoPlayerController.value.caption.text);
        });
      });
    increaseViews(widget.postId);
  }

  Future<ClosedCaptionFile> _loadCaptions() async {
    final String fileContents = await DefaultAssetBundle.of(context)
        .loadString('assets/animations/caption_en.vtt');
    return WebVTTCaptionFile(
        fileContents); // For vtt files, use WebVTTCaptionFile
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
              Obx(
                () => ClosedCaption(
                  text: captionController.captionText.value,
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                  ),
                ),
              ),
              VideoProgressIndicator(videoPlayerController,
                  colors: const VideoProgressColors(
                    backgroundColor: Colors.grey,
                    bufferedColor: Colors.white,
                    playedColor: Colors.red,
                  ),
                  allowScrubbing: true),
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
