import 'package:just_audio/just_audio.dart';

class PlayerStateGlobal {
  static final AudioPlayer player = AudioPlayer();

  static bool tocando = false;
  static String? titulo;
  static String? artista;
  static Duration duracao = Duration.zero;
}