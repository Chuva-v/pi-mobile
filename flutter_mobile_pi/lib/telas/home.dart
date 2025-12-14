import 'package:flutter/material.dart';
import 'package:mobile_pi/desenho/cores.dart';
import 'package:mobile_pi/routes/rotaSemAnimacao.dart';
import 'package:mobile_pi/service/api.dart';
import 'package:mobile_pi/telas/buscar.dart';
import 'package:mobile_pi/telas/mini_player.dart';
import 'package:mobile_pi/telas/playlist_page.dart';
import '../service/minhas_playlists.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final api = Api();
  final c = Cores();
  double scaleHome = 1.0;
  double scaleBuscar = 1.0;
  double scaleLib = 1.0;
  String nomeUsuario = '...';

  // ------------------- CARDS DE PLAYLIST -------------------
  Widget _playlistCard(Map<String, dynamic> playlist, double largura) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PlaylistPage(playlist: playlist),
          ),
        );
      },
      child: Container(
        width: largura * 0.4,
        height: 150,
        margin: EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[900],
          image: playlist['capa'] != null && playlist['capa'] != ''
              ? DecorationImage(
                  image: NetworkImage(
                      "http://127.0.0.1:8000/storage/capas/${playlist['capa']}"),
                  fit: BoxFit.cover,
                )
              : null,
        ),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              playlist['titulo'],
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: Colors.black54,
                    offset: Offset(1, 1),
                    blurRadius: 2,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ------------------- FUNÇÃO PARA CRIAR PLAYLIST -------------------
  void _criarPlaylist() {
    String nome = '';
    String? capa;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: c.preto(),
        title: Text('Criar Playlist', style: TextStyle(color: c.branco())),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              style: TextStyle(color: c.branco()),
              decoration: InputDecoration(
                hintText: 'Nome da playlist',
                hintStyle: TextStyle(color: c.laranja()),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: c.laranja()),
                ),
              ),
              onChanged: (v) => nome = v,
            ),
            SizedBox(height: 10),
            TextButton.icon(
              onPressed: () {
                // Aqui você pode implementar seleção de imagem
                capa = 'play.jpg';
              },
              icon: Icon(Icons.photo, color: c.laranja()),
              label: Text('Escolher capa', style: TextStyle(color: c.laranja())),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar', style: TextStyle(color: c.branco())),
          ),
          TextButton(
            onPressed: () {
              if (nome.isNotEmpty) {
                setState(() {
                  playlists.add({'titulo': nome, 'capa': capa ?? ''});
                });
                Navigator.pop(context);
              }
            },
            child: Text('Criar', style: TextStyle(color: c.laranja())),
          ),
        ],
      ),
    );
  }

  Future<void> deslogar() async {
    bool validacao = await api.logout();
    if (validacao) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  Future<void> animarHome(String escala) async {
    if(escala == 'scaleHome') setState(() => scaleHome = 0.85); 
    if(escala == 'scaleBuscar') setState(() => scaleBuscar = 0.85); 
    if(escala == 'scaleLib') setState(() => scaleLib = 0.85); 

    await Future.delayed(Duration(milliseconds: 90));

    if(escala == 'scaleHome') setState(() => scaleHome = 1.0); 
    if(escala == 'scaleBuscar') setState(() => scaleBuscar = 1.0); 
    if(escala == 'scaleLib') setState(() => scaleLib = 1.0); 

    await Future.delayed(Duration(milliseconds: 90));
  }

  @override
  void initState() {
    super.initState();
    carregarNome();
  }

  Future<void> carregarNome() async {
    final n = await api.meunome();
    setState(() {
      nomeUsuario = n;
    });
  }

  @override
  Widget build(BuildContext context) {
    double largura = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: c.fundo(),

      appBar: AppBar(
        backgroundColor: c.preto(),
        elevation: 0,
        centerTitle: false,
        title: Text(
          nomeUsuario,
          style: TextStyle(color: c.branco(), fontSize: 22, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: deslogar,
            icon: Icon(Icons.logout, color: c.branco()),
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ------------------- TÍTULO E BOTÃO CRIAR PLAYLIST -------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Suas Playlists",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                IconButton(
                  onPressed: _criarPlaylist,
                  icon: Icon(Icons.add, color: c.laranja()),
                ),
              ],
            ),
            SizedBox(height: 10),

            // CARROSSEL DE PLAYLISTS
            SizedBox(
              height: 160,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: playlists.length,
                itemBuilder: (context, index) {
                  return _playlistCard(playlists[index], largura);
                },
              ),
            ),
            SizedBox(height: 25),
          ],
        ),
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
                      onTap:(){
                        animarHome('scaleHome');
                      },
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
