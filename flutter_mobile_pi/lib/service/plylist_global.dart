
//import '../models/musica_model.dart';
import '../models/playlist_model.dart';
import 'package:just_audio/just_audio.dart';
import 'play_global.dart'; // para controlar o player real

class PlaylistStateGlobal {
  static List<Playlist> playlists = []; // todas as playlists
  static Playlist? playlistAtual;       // playlist que está tocando
  static int indexMusicaAtual = 0;      // índice da música atual

  // Tocar música
  static void tocarMusica(int index) {
    if (playlistAtual == null || playlistAtual!.musicas.isEmpty) return;
    indexMusicaAtual = index;
    final musica = playlistAtual!.musicas[index];

    PlayerStateGlobal.tocando = true;
    PlayerStateGlobal.titulo = musica.titulo;
    PlayerStateGlobal.artista = musica.artista;
    PlayerStateGlobal.capa = musica.capa;

    PlayerStateGlobal.player.setAudioSource(
      AudioSource.uri(Uri.parse(musica.arquivo)),
      preload: true,
    ).then((_) => PlayerStateGlobal.player.play());
  }

  static void proximaMusica() {
    if (playlistAtual == null) return;
    indexMusicaAtual = (indexMusicaAtual + 1) % playlistAtual!.musicas.length;
    tocarMusica(indexMusicaAtual);
  }

  static void musicaAnterior() {
    if (playlistAtual == null) return;
    indexMusicaAtual = (indexMusicaAtual - 1 + playlistAtual!.musicas.length) %
        playlistAtual!.musicas.length;
    tocarMusica(indexMusicaAtual);
  }
}
