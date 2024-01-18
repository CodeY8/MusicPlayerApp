import 'package:flutter/material.dart';
import 'package:my_music/pages/home.dart';
import 'package:my_music/providers/audio_player_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Music',
      theme: ThemeData.dark(),
      home: ChangeNotifierProvider(
        create: (context) => AudioPlayerProvider(),
        child: const HomePage(),
      ),
    );
  }
}

/*
  Hello guys in this video we are going to create a simple music plaer app

  It consists of a list of audio files which are fetched from the device and a miniplayer

  For this app we are going to use dependencies like
    provider
    on_audio_query
    audioplayers

  In the lib folder I have created three separate folders which are widget, providers and pages

  Now let's get started.
 */
