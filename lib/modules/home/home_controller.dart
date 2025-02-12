import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/base/base_controller.dart';
import 'package:flutter_getx_boilerplate/repositories/auth_repository.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_getx_boilerplate/shared/constants/image_constants.dart';
import 'package:flutter_lyric/lyrics_reader.dart';
import 'package:flutter_lyric/lyrics_reader_model.dart';
import 'package:get/get.dart';
import 'package:xml/xml.dart';
import 'package:flutter/services.dart' show rootBundle;

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
    _initLyrics();

    _initAudioPlayer();
    super.onInit();
  }

  _initLyrics() async {
    String xmlString = await loadXmlFromAssets("assets/audios/lyrics.xml");
    print("DEBUG: XML Content => \n$xmlString");

    String lrcLyrics =
        convertXmlToLrc(xmlString, "Về Đâu Mái Tóc Người Thương", "Quang Lê");

    print("Lrc Lyrics: $lrcLyrics");

    lyricModel.value =
        LyricsModelBuilder.create().bindLyricToMain(lrcLyrics).getModel();
    isLyricLoaded.value = true;
  }

  loadXmlFromAssets(String path) async {
    return await rootBundle.loadString(path);
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

  String convertXmlToLrc(String xmlString, String title, String artist) {
    final document = XmlDocument.parse(xmlString);
    final params = document.findAllElements('param');

    print("DEBUG: Found ${params.length} params in XML");

    final lrcBuffer = StringBuffer()
      ..writeln("[ti:$title]")
      ..writeln("[ar:$artist]")
      ..writeln("[by:]")
      ..writeln("[offset:0]");

    for (var param in params) {
      final words = param.findAllElements('i');
      if (words.isEmpty) continue;

      final startTime = words.first.getAttribute('va');
      if (startTime == null) continue;

      final formattedTime = formatTime(startTime);
      final lyricLine = words.map((e) => e.innerText.trim()).join(" ");

      lrcBuffer.writeln("[$formattedTime]$lyricLine");
      print("DEBUG: [$formattedTime] $lyricLine");
    }

    return lrcBuffer.toString();
  }

  String formatTime(String time) {
    final seconds = double.tryParse(time) ?? 0.0;
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${remainingSeconds.toStringAsFixed(2).padLeft(5, '0')}';
  }

  @override
  void onClose() {
    audioPlayer?.dispose();
    audioPlayer?.stop();
    super.onClose();
  }
}
