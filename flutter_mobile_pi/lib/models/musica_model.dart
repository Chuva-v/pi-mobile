

class Musica {
  final String id;
  final String titulo;
  final String artista;
  final String arquivo; // url ou caminho local
  final String? capa;   // url da capa (opcional)

  Musica({
    required this.id,
    required this.titulo,
    required this.artista,
    required this.arquivo,
    this.capa,
  });
}
