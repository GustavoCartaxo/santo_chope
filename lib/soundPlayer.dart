import 'package:audioplayers/audio_cache.dart';

final player = AudioCache();

class SoundPlayer {
  static void playSound(String soundName) {
    player.play(soundName);
  }
}

//const String bubble = 'bubble-pop.wav';
//const String up = 'level-up.mp3';
