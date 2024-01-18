import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:my_music/providers/audio_player_provider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class MiniPlayer extends StatelessWidget {
  final List<SongModel> songs;

  const MiniPlayer({super.key, required this.songs});

  // NOw let's add the audio playing functions

  @override
  Widget build(BuildContext context) {
    final audioProvider = Provider.of<AudioPlayerProvider>(context);
    final currentPlayingIndex = audioProvider.currentPlayingIndex;
    final currentSong = audioProvider.currentSong;
    return currentPlayingIndex != null && currentSong != null
        ? BottomAppBar(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentSong.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          currentSong.artist ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white38),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  if (currentPlayingIndex != null)
                    IconButton(
                      onPressed: () {
                        audioProvider.playPause(currentPlayingIndex, songs);
                        if (audioProvider.isPlaying) {
                          AudioPlayer().pause();
                        } else {
                          AudioPlayer().resume();
                        }
                      },
                      iconSize: 36,
                      icon: Icon(audioProvider.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow),
                    ),
                  if (currentPlayingIndex != null)
                    IconButton(
                      onPressed: () {
                        final nextIndex =
                            (currentPlayingIndex + 1) % songs.length;
                        audioProvider.playPause(nextIndex, songs);
                      },
                      iconSize: 36,
                      icon: const Icon(Icons.skip_next),
                    ),
                ],
              ),
            ),
          )
        : const SizedBox();
  }
}
