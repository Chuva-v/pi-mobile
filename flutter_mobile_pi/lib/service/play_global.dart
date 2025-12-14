import 'package:just_audio/just_audio.dart';

class PlayerStateGlobal {
  static final player = AudioPlayer();

  // ===============================
  // 🎵 ESTADO
  // ===============================
  static bool tocando = false;

  // 🎶 DADOS ATUAIS
  static String? titulo;
  static String? artista;
  static String? capa;

  // ⏱ DURAÇÃO
  static Duration duracao = Duration.zero;

  // ===============================
  // 📃 PLAYLIST
  // ===============================
  static List<Map<String, dynamic>> playlist = [];
  static int indexAtual = 0;

  // ===============================
  // 🎛 MODOS
  // ===============================
  static bool shuffle = false;
  static LoopMode loopMode = LoopMode.off;

  // ===============================
  // 🔔 INICIALIZAR LISTENERS
  // ===============================
  static void init() {
    // 🔁 Quando a música mudar
    player.currentIndexStream.listen((index) {
      if (index == null) return;
      if (playlist.isEmpty) return;
      if (index >= playlist.length) return;

      indexAtual = index;

      final musica = playlist[index];

      titulo = musica['titulo'];
      artista = musica['artista'];
      capa = musica['capa'];

      duracao = player.duration ?? Duration.zero;
    });

    // ▶️ Estado de reprodução
    player.playerStateStream.listen((state) {
      tocando = state.playing;
    });
  }

  // ===============================
  // ▶️ MÚSICA AVULSA
  // ===============================
  static Future<void> playSingle({
    required String url,
    required String tituloMusica,
    String? artistaMusica,
    String? capaMusica,
  }) async {
    playlist = [];
    indexAtual = 0;

    titulo = tituloMusica;
    artista = artistaMusica;
    capa = capaMusica;

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

    final sources = musicas.map((m) {
      return AudioSource.uri(Uri.parse(m['url']));
    }).toList();

    await player.setAudioSource(
      ConcatenatingAudioSource(children: sources),
      initialIndex: startIndex,
    );

    final musica = musicas[startIndex];
    titulo = musica['titulo'];
    artista = musica['artista'];
    capa = musica['capa'];

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
