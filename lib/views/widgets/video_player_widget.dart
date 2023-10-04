import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final String postId;
  const VideoPlayerWidget(
      {super.key, required this.videoUrl, required this.postId});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? videoPlayerController;
  RxBool isVInitialized = false.obs;

  @override
  void initState() {
    super.initState();
    initializeVideoPlayer(widget.videoUrl);
    increaseViews(widget.postId);
  }

  void initializeVideoPlayer(String vUrl) async {
    final fileInfo = await checkCacheForFile(vUrl);
    if (fileInfo == null) {
      videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(vUrl),
        //httpHeaders: {'accept': '*/*'},
      )..initialize().then((value) async {
          print('===================== 33 =====================');
          cachVideoFile(vUrl);
          videoPlayerController?.play();
          videoPlayerController?.setVolume(1);
          videoPlayerController?.setLooping(true);
          videoPlayerController?.addListener(() {
            isVInitialized.value = videoPlayerController!.value.isInitialized;
          });
        });
    } else {
      print('===================== 44 in cache =====================');
      final file = fileInfo.file;
      videoPlayerController = VideoPlayerController.file(file)
        ..initialize().then((value) {
          videoPlayerController?.play();
          videoPlayerController?.setVolume(1);
          videoPlayerController?.setLooping(true);
          videoPlayerController?.addListener(() {
            isVInitialized.value = videoPlayerController!.value.isInitialized;
          });
        });
    }
  }

  final Config _config = Config(
    'customCacheKeyConfigOBG',
    stalePeriod: const Duration(minutes: 15),
    maxNrOfCacheObjects: 20,
  );

  Future<FileInfo?> checkCacheForFile(String url) async {
    print('===================== 22 =====================');
    final FileInfo? value = await CacheManager(_config).getFileFromCache(url);
    return (value);
  }

  void cachVideoFile(String url) async {
    print('===================== 11 =====================');
    await CacheManager(_config).getSingleFile(url).then((value) =>
        print('the video Downloaded successfully to the cache: source:: $url'));
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
    videoPlayerController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    RxBool isPlaying = true.obs;
    press() {
      if (isPlaying.value) {
        // Pause vieo
        videoPlayerController?.pause();
        isPlaying.value = false;
      } else {
        // Play video
        videoPlayerController?.play();
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
              Obx(() {
                if (isVInitialized.value) {
                  return (videoPlayerController != null && isVInitialized.value)
                      ? VideoPlayer(videoPlayerController!)
                      : const Center(
                          child: SizedBox(),
                        );
                } else {
                  return Center(
                      child: AnimatedTextKit(
                    repeatForever: true,
                    isRepeatingAnimation: true,
                    animatedTexts: [
                      WavyAnimatedText('loading'.tr),
                    ],
                  ));
                }
              }),
              Obx(() {
                if (isVInitialized.value) {
                  return (videoPlayerController != null &&
                          videoPlayerController!.value.isInitialized)
                      ? VideoProgressIndicator(videoPlayerController!,
                          colors: const VideoProgressColors(
                            backgroundColor: Colors.grey,
                            bufferedColor: Colors.white,
                            playedColor: Colors.red,
                          ),
                          allowScrubbing: true)
                      : const SizedBox();
                } else {
                  return const SizedBox();
                }
              }),
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
