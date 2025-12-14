import 'package:just_audio/just_audio.dart';

class PlayerStateGlobal {
  static final player = AudioPlayer();

  // 🎵 ESTADO
  static bool tocando = false;

  // CAPA
  static String? capa;

  // 🎶 DADOS DA MÚSICA
  static String? titulo;
  static String? artista;

  // ⏱ DURAÇÃO
  static Duration duracao = Duration.zero;

  // 📃 PLAYLIST
  static List<Map<String, dynamic>> playlist = [];
  static int indexAtual = 0;

  // 🎛 MODOS
  static bool shuffle = false;
  static LoopMode loopMode = LoopMode.off;

  // ===============================
  // ▶️ MÚSICA AVULSA
  // ===============================
  static Future<void> playSingle({
    required String url,
    required String tituloMusica,
    String? artistaMusica,
  }) async {
    playlist = [];
    indexAtual = 0;

    titulo = tituloMusica;
    artista = artistaMusica;

    await player.setUrl(url);
    await player.play();

    tocando = true;
  }

  // ===============================
  // ▶️ PLAYLIST
  // ===============================
  static Future<void> playPlaylist({
    required List<Map<String, dynamic>> musicas,
    int startIndex = 0,
  }) async {
    playlist = musicas;
    indexAtual = startIndex;

    final sources = musicas
        .map((m) => AudioSource.uri(Uri.parse(m['url'])))
        .toList();

    await player.setAudioSource(
      ConcatenatingAudioSource(children: sources),
      initialIndex: startIndex,
    );

    titulo = musicas[startIndex]['titulo'];
    artista = musicas[startIndex]['artista'];

    await player.play();
    tocando = true;
  }

  // ===============================
  // ⏸ PAUSE
  // ===============================
  static Future<void> pause() async {
    await player.pause();
    tocando = false;
  }

  // ===============================
  // ▶️ PLAY
  // ===============================
  static Future<void> resume() async {
    await player.play();
    tocando = true;
  }

  // ===============================
  // ⏭ / ⏮
  // ===============================
  static void next() {
    if (playlist.isEmpty) return;
    player.seekToNext();
  }

  static void previous() {
    if (playlist.isEmpty) return;
    player.seekToPrevious();
  }

  // ===============================
  // 🔀 SHUFFLE
  // ===============================
  static Future<void> toggleShuffle() async {
    shuffle = !shuffle;
    await player.setShuffleModeEnabled(shuffle);
  }

  // ===============================
  // 🔁 LOOP
  // ===============================
  static Future<void> toggleLoop() async {
    if (loopMode == LoopMode.off) {
      loopMode = LoopMode.all;
    } else if (loopMode == LoopMode.all) {
      loopMode = LoopMode.one;
    } else {
      loopMode = LoopMode.off;
    }
    await player.setLoopMode(loopMode);
  }
}
