import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_lyric/lyrics_reader.dart';
import 'package:flutter_lyric/lyrics_reader_model.dart';

class ReaderBackgroud extends StatelessWidget {
  const ReaderBackgroud({
    super.key,
    this.lyricModel,
    this.playProgress = 0,
    this.lyricUi,
    this.playing,
    this.onPlay,
  });

  final LyricsReaderModel? lyricModel;
  final int playProgress;
  final LyricUI? lyricUi;
  final bool? playing;
  final Function(int progress)? onPlay;

  @override
  Widget build(BuildContext context) {
    return LyricsReader(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      model: lyricModel,
      position: playProgress,
      lyricUi: lyricUi,
      playing: playing,
      size: Size(double.infinity, MediaQuery.of(context).size.height / 6),
      emptyBuilder: () => Center(
        child: Text(
          "No lyrics",
          style: lyricUi?.getOtherMainTextStyle(),
        ),
      ),
      selectLineBuilder: (progress, confirm) {
        return Row(
          children: [
            IconButton(
                onPressed: () {
                  confirm.call();
                  onPlay?.call(progress);
                },
                icon: const Icon(Icons.play_arrow, color: Colors.green)),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(color: Colors.green),
                height: 1,
                width: double.infinity,
              ),
            ),
            Text(
              progress.toString(),
              style: const TextStyle(color: Colors.green),
            )
          ],
        );
      },
    );
  }
}
