import 'package:flutter/material.dart';
import 'package:mobile_pi/desenho/cores.dart';
import 'package:mobile_pi/routes/rotaSemAnimacao.dart';
import 'package:mobile_pi/service/play_global.dart';
import 'package:mobile_pi/service/api.dart';
import 'package:mobile_pi/telas/buscar.dart';
import 'package:mobile_pi/telas/mini_player.dart';
import 'dart:ui';

class PlaylistPage extends StatefulWidget {
  final Map<String, dynamic> playlist;

  const PlaylistPage({super.key, required this.playlist});

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  final c = Cores();
  final api = Api();
  List musicas = [];
  bool carregando = true;
  double scaleHome = 1.0;
  double scaleBuscar = 1.0;

  @override
  void initState() {
    super.initState();
    carregarMusicas();
  }

  Future<void> carregarMusicas() async {
    final resultado = await api.listarMusicas();
    setState(() {
      musicas = resultado
          .where((m) => m['playlist_id'] == widget.playlist['id'])
          .toList();
      carregando = false;
    });
  }

  Future<void> animarHome(String escala) async {
    if(escala == 'scaleHome') setState(() => scaleHome = 0.85); 
    if(escala == 'scaleBuscar') setState(() => scaleBuscar = 0.85); 

    await Future.delayed(Duration(milliseconds: 90));

    if(escala == 'scaleHome') setState(() => scaleHome = 1.0); 
    if(escala == 'scaleBuscar') setState(() => scaleBuscar = 1.0); 

    await Future.delayed(Duration(milliseconds: 90));
  }

  void tocarPlaylist(int index) async {
    // Constrói lista de músicas para o player
    final listaParaTocar = musicas.map((m) => {
      'url': "http://127.0.0.1:8000/storage/musicas/${m['arquivo']}",
      'titulo': m['titulo'],
      'artista': m['artista'],
      'capa': m['capa']
    }).toList();

    await PlayerStateGlobal.playPlaylist(
      musicas: listaParaTocar,
      startIndex: index,
    );
    setState(() {}); // Atualiza mini player
  }

  @override
  Widget build(BuildContext context) {
    double largura = MediaQuery.sizeOf(context).width;
    return Scaffold(
      backgroundColor: c.fundo(),
      appBar: AppBar(
        backgroundColor: c.preto(),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: c.laranja()),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.playlist['titulo'], style: TextStyle(color: c.branco())),
      ),
      body: carregando
          ? Center(child: CircularProgressIndicator(color: c.laranja()))
          : Column(
              children: [
                // ---------------- CAPA DA PLAYLIST ----------------
                Container(
                  height: 200,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (widget.playlist['capa'] != null && widget.playlist['capa'] != '')
                        Image.network(
                          "http://127.0.0.1:8000/storage/capas/${widget.playlist['capa']}",
                          fit: BoxFit.cover,
                        )
                      else
                        Container(color: Colors.grey[800]),
                      BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                        child: Container(
                          color: Colors.black.withOpacity(0.4),
                        ),
                      ),
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: widget.playlist['capa'] != null && widget.playlist['capa'] != ''
                              ? Image.network(
                                  "http://127.0.0.1:8000/storage/capas/${widget.playlist['capa']}",
                                  height: 140,
                                  width: 140,
                                  fit: BoxFit.cover,
                                )
                              : Icon(Icons.music_note, size: 140, color: Colors.white54),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(20),
                    itemCount: musicas.length,
                    itemBuilder: (context, index) {
                      final m = musicas[index];
                      return ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: m['capa'] != null && m['capa'] != ''
                              ? Image.network(
                                  "http://127.0.0.1:8000/storage/capas/${m['capa']}",
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  width: 50,
                                  height: 50,
                                  color: Colors.grey[800],
                                  child: Icon(Icons.music_note, color: Colors.white54),
                                ),
                        ),
                        title: Text(m['titulo'], style: TextStyle(color: c.branco())),
                        subtitle: Text(m['artista'], style: TextStyle(color: Colors.white70)),
                        onTap: () => tocarPlaylist(index),
                      );
                    },
                  ),
                ),
              ],
            ),

      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.all(0),
        height: 110,
        color: Colors.transparent,
        elevation: 0,
        child: Container(
          padding: EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                c.preto(),
                Color.fromARGB(65, 0, 0, 0),
                Color.fromARGB(0, 14, 14, 14),
              ],
            )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MiniPlayer(),
              SizedBox(height: 5),
              Container(
                padding: EdgeInsets.symmetric(horizontal: largura * 0.07),
                height: 55,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap:(){ animarHome('scaleHome'); },
                      child: AnimatedScale(
                        scale: scaleHome,
                        duration: Duration(milliseconds: 10),
                        child: Column(
                          children: [
                            Icon(Icons.home, size: 35, color: c.branco()),
                            Text('Home', style: TextStyle(color: c.branco(), fontSize: 12))
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: largura * 0.15),
                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap:(){
                        animarHome('scaleBuscar');
                        final rotaAtual = ModalRoute.of(context)?.settings.name;
                        if (rotaAtual != '/buscar') {
                          Navigator.pushReplacement(
                            context,
                            Rotasemanimacao(
                              builder: (_) => BuscarPage(), 
                              settings: RouteSettings(name: '/buscar')
                            )
                          );
                        }
                      },
                      child: AnimatedScale(
                        scale: scaleBuscar,
                        duration: Duration(milliseconds: 10),
                        child: Column(
                          children: [
                            Icon(Icons.search, size: 35, color: c.branco()),
                            Text('Buscar', style: TextStyle(color: c.branco(), fontSize: 12))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}
