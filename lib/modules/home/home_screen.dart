// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_getx_boilerplate/modules/home/home.dart';
import 'package:flutter_getx_boilerplate/shared/extension/context_ext.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../shared/constants/image_constants.dart';
import '../../shared/widgets/image/image_widget.dart';
import 'widgets/reader_backgroud.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _buildBody(context),
      ),
      floatingActionButton: _buildPlayControl(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  _buildBody(BuildContext context) {
    return Obx(() {
      if (!controller.isLyricLoaded.value) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      return _buildReader();
    });
  }

  _buildIntroPage() {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        controller.pageController.animateToPage(
          1,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      },
      child: Center(
        child: LottieBuilder.asset(
          ImageConstants.ltBackground,
          fit: BoxFit.cover,
          width: 200,
          height: 200,
        ),
      ),
    );
  }

  _buildPlayControl(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _sliderProgress(context),
        _buidPlayMusic(),
      ],
    );
  }

  _buildReader() {
    return Stack(
      children: [
        ..._buildBackGround(),
        Positioned.fill(
          child: PageView(
            controller: controller.pageController,
            children: [
              _buildIntroPage(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Obx(() => ReaderBackgroud(
                      lyricModel: controller.lyricModel.value,
                      playProgress: controller.playProgress.value,
                      lyricUi: controller.lyricUI,
                      playing: controller.playing.value,
                      onPlay: controller.onReader,
                    )),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _buildBackGround() {
    return [
      Positioned(
        child: ImageWidget(
          ImageConstants.imageBackgroudMusic,
          fit: BoxFit.fill,
          height: Get.height,
          width: Get.width,
        ),
      ),
      Positioned(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: Colors.black.withOpacity(0.3),
          ),
        ),
      ),
    ];
  }

  _sliderProgress(BuildContext context) {
    TextStyle textStyle = TextStyle(color: context.colors.surface);

    return Obx(() {
      if (controller.sliderProgress < controller.maxValue.value) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_formatDuration(controller.timeStart.value),
                        style: textStyle),
                    Text(_formatDuration(controller.timeEnd.value),
                        style: textStyle),
                  ],
                ),
              ),
              Slider(
                min: 0,
                max: controller.maxValue.value,
                label: controller.sliderProgress.toString(),
                value: controller.sliderProgress.value,
                activeColor: Colors.orange,
                inactiveColor: Colors.white,
                onChanged: controller.onChangSlide,
                onChangeStart: (i) => controller.onChangeStart(),
                onChangeEnd: controller.onChangeEnd,
              ),
            ],
          ),
        );
      }
      return const SizedBox.shrink();
    });
  }

  _buidPlayMusic() {
    return Obx(() => InkWell(
          onTap: () => _onplayMusic(),
          child: ImageWidget(
            controller.playing.value
                ? ImageConstants.iconPause
                : ImageConstants.iconPlay,
            height: 40,
            fit: BoxFit.scaleDown,
          ),
        ));
  }

  _onplayMusic() =>
      controller.playing.value ? controller.onPause() : controller.onPlay();

  _formatDuration(double seconds) {
    int minutes = (seconds ~/ 60);
    int secs = (seconds % 60).toInt();
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}
