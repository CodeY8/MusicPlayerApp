import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:my_music/providers/audio_player_provider.dart';
import 'package:my_music/widgets/miniplayer.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final OnAudioQuery audioQuery = OnAudioQuery();
  List<SongModel> _songs = [];

  /*
    First Let's fetch the songs

    Add the following dependencies to the pubspec.yaml
      permission_handler and device_info_plus

      Let's add the permissions in the androidmanifest.xml and info.plist

      Add the on_audio_query dependency to the pubspec.yaml

   */

  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  Future<void> requestPermission() async {
    final deviceInfo = await DeviceInfoPlugin().androidInfo;
    if (Theme.of(context).platform == TargetPlatform.android) {
      if (await Permission.audio.isGranted ||
          await Permission.storage.isGranted) {
        _fetchSongs();
      } else {
        if (deviceInfo.version.sdkInt > 32) {
          await Permission.audio.request();
        } else {
          await Permission.storage.request();
        }
      }
    } else if (Theme.of(context).platform == TargetPlatform.iOS) {
      if (await Permission.mediaLibrary.isGranted) {
        _fetchSongs();
      } else {
        await Permission.mediaLibrary.request();
      }
    }
  }

  Future<void> _fetchSongs() async {
    List<SongModel> songs = await audioQuery.querySongs();

    setState(() {
      _songs = songs;
    });
  }

  @override
  Widget build(BuildContext context) {
    final audioProvider = Provider.of<AudioPlayerProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Music'),
      ),
      body: ListView.builder(
        itemCount: _songs.length,
        itemBuilder: (context, index) {
          return ListTile(
            tileColor: audioProvider.isPlaying
                ? audioProvider.currentPlayingIndex == index
                    ? Colors.white12
                    : null
                : null,
            onTap: () {
              audioProvider.playPause(index, _songs);
            },
            leading: QueryArtworkWidget(
              id: _songs[index].id,
              type: ArtworkType.AUDIO,
              artworkWidth: 55,
              artworkHeight: 55,
              artworkBorder: BorderRadius.circular(8),
            ),
            title: Text(
              _songs[index].title ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              _songs[index].artist ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.white38),
            ),
            trailing: audioProvider.isPlaying
                ? audioProvider.currentPlayingIndex == index
                    ? Icon(Icons.graphic_eq)
                    : null
                : null,
          );
        },
      ),
      bottomNavigationBar: MiniPlayer(
        songs: _songs,
      ),
    );
  }
}
