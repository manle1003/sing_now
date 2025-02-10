import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/base/base_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/auth_repository.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_getx_boilerplate/shared/constants/image_constants.dart';
import 'package:flutter_lyric/lyrics_reader.dart';
import 'package:flutter_lyric/lyrics_reader_model.dart';
import 'package:get/get.dart';

import '../../shared/constants/common.dart';

class HomeController extends BaseController<AuthRepository> {
  HomeController(super.repository);

  final sliderProgress = 0.0.obs;
  final playProgress = 0.obs;
  final maxValue = 211658.0.obs;

  final timeStart = 0.0.obs;
  final timeEnd = 0.0.obs;

  final lyricUI = UINetease();

  final lyricModel = LyricsReaderModel().obs;

  final isLyricLoaded = false.obs;
  final isTap = false.obs;
  final playing = false.obs;
  final isPause = false.obs;

  AudioPlayer? audioPlayer;
  final PageController pageController = PageController();

  @override
  void onInit() {
    _initData();
    _initAudioPlayer();
    super.onInit();
  }

  _initData() async {
    lyricModel.value = LyricsModelBuilder.create()
        .bindLyricToMain(CommonConstants.normalLyric)
        .getModel();
    isLyricLoaded.value = true;
  }

  _initAudioPlayer() async {
    audioPlayer = AudioPlayer()
      ..setSourceAsset(ImageConstants.beatAudio)
      ..onDurationChanged.listen((event) {
        maxValue.value = event.inMilliseconds.toDouble();
        timeEnd.value = event.inSeconds.toDouble();
      })
      ..onPositionChanged.listen((event) {
        if (!isTap.value) {
          sliderProgress.value = event.inMilliseconds.toDouble();
          playProgress.value = event.inMilliseconds;
          timeStart.value = event.inSeconds.toDouble();
        }
      })
      ..onPlayerStateChanged.listen((state) {
        playing.value = state == PlayerState.playing;
      });
  

    audioPlayer?.setReleaseMode(ReleaseMode.stop);
  }

  onPlay() {
    if (playing.value) {
      audioPlayer?.pause();
      return;
    }

    audioPlayer?.play(AssetSource(ImageConstants.beatAudio));
    playing.value = true;
  }

  onPause() => audioPlayer?.pause();

  onChangSlide(double value) => sliderProgress.value = value;

  onChangeStart() => isTap.value = true;

  onChangeEnd(double value) {
    isTap.value = false;
    playProgress.value = value.toInt();
    audioPlayer?.seek(Duration(milliseconds: value.toInt()));
  }

  onReader(progress) => audioPlayer?.seek(Duration(milliseconds: progress));

  @override
  void onClose() {
    audioPlayer?.dispose();
    audioPlayer?.stop();
    super.onClose();
  }
}
