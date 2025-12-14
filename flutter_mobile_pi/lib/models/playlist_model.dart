
import 'musica_model.dart';

class Playlist {
  final String id;
  final String nome;
  final String? capa; // capa da playlist
  final List<Musica> musicas;

  Playlist({
    required this.id,
    required this.nome,
    required this.musicas,
    this.capa,
  });
}
