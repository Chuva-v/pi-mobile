// exemplo_playlist.dart

List<Map<String, dynamic>> playlists = [
  // Exemplo inicial (pode ser removido se quiser começar vazio)
  {
    'titulo': 'GOUSTH',
    'capa': 'playlist.jpg', // arquivo de capa no storage ou assets
    'musicas': [
      {
        'titulo': 'Musica A',
        'artista': 'Artista X',
        'arquivo': 'musicaA.mp3',
        'capa': 'capa_musicaA.jpg',
      },
      {
        'titulo': 'Musica B',
        'artista': 'Artista Y',
        'arquivo': 'musicaB.mp3',
        'capa': 'capa_musicaB.jpg',
      },
    ],
  },
];

// Função para criar uma nova playlist
void criarPlaylist(String titulo, {String? capa}) {
  playlists.add({
    'titulo': titulo,
    'capa': capa ?? '', // capa vazia se não tiver
    'musicas': [],
  });
}

// Função para adicionar música a uma playlist
void adicionarMusica(String tituloPlaylist, Map<String, String> musica) {
  final playlist = playlists.firstWhere(
    (p) => p['titulo'] == tituloPlaylist,
    orElse: () => {},
  );

  if (playlist.isNotEmpty) {
    playlist['musicas'].add(musica);
  }
}
