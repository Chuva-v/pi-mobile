import 'package:flutter/material.dart';
import 'package:mobile_pi/desenho/cores.dart';
import 'package:mobile_pi/service/api.dart';

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


  Future<void> deslogar() async {
    bool validacao = await api.logout();
    if (validacao) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/login');
    }
  }
  // função para a animação do botão
  Future<void> animarHome(String escala) async {
    if(escala == 'scaleHome'){
      setState(() => scaleHome = 0.85); 
    }
    if(escala == 'scaleBuscar'){
      setState(() => scaleBuscar = 0.85); 
    }
    if(escala == 'scaleLib'){
      setState(() => scaleLib = 0.85); 
    }

    await Future.delayed(Duration(milliseconds: 90));

    if(escala == 'scaleHome'){
      setState(() => scaleHome = 1.0); 
    }
    if(escala == 'scaleBuscar'){
      setState(() => scaleBuscar = 1.0); 
    }
    if(escala == 'scaleLib'){
      setState(() => scaleLib = 1.0); 
    }

    await Future.delayed(Duration(milliseconds: 90));

    print("Clicou no Home!");
    // aqui você faz ação: trocar página, atualizar menu, etc
  }

  @override
  Widget build(BuildContext context) {
    double altura = MediaQuery.sizeOf(context).height;
    double largura = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: c.preto(), // estilo Spotify

      // ---------------- APP BAR ----------------
      appBar: AppBar(
        backgroundColor: c.azul(),
        elevation: 10,
        centerTitle: false,
        title: Text(
          'Sua Música 🎵',
          style: TextStyle(color: c.fundo(), fontSize: 22, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: deslogar,
            icon: Icon(Icons.logout, color: c.branco()),
          ),
        ],
      ),

      // ---------------- BODY ----------------
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // SESSÃO "Tocadas Recentemente"
            Text(
              "Tocadas Recentemente",
              style: TextStyle(color: c.branco(), fontSize: 18),
            ),
            SizedBox(height: altura * 0.1),

            SizedBox(height: 25),

            // SESSÃO "Playlists"
            Text(
              "Suas Playlists",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(height: 10),

            SizedBox(height: 25),

            // 🔥 SESSÃO "Recomendadas"
            Text(
              "Recomendadas para Você",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(height: 10),

          ],
        ),

      ),
      // ----------- RODAPE -----------------------
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
                c.preto(),    // cor da parte de baixo (mais forte)
                Color.fromARGB(65, 0, 0, 0),    // cor do meio
                Color.fromARGB(0, 14, 14, 14),    // cor mais clara em cima
              ],
            )
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // musica tocando no momento
              Container(
                height: 40,
                width: largura - 10,
                color: c.verde(),
                child: Text('musica'),
              ),

              SizedBox(height: 5),

              // menuzinho
              Container(
                //color: c.azul(),
                padding: EdgeInsets.symmetric(horizontal: largura * 0.07),
                height: 55,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap:(){animarHome('scaleHome');},
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
                      onTap:(){animarHome('scaleBuscar');},
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

                    SizedBox(width: largura * 0.15),

                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap:(){animarHome('scaleLib');},
                      child: AnimatedScale(
                        scale: scaleLib,
                        duration: Duration(milliseconds: 10),
                        child: Column(
                          children: [
                            Icon(Icons.library_music, size: 35, color: c.branco()),
                            Text('Meus', style: TextStyle(color: c.branco(), fontSize: 12))
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






























  // ----------- WIDGETS DE LISTAS -----------

  Widget _buildRecentes() {
    return SizedBox(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _musicCard("Beat Trap", Icons.music_note),
          _musicCard("Funk Hits", Icons.audiotrack),
          _musicCard("Lo-fi Relax", Icons.spa),
        ],
      ),
    );
  }

  Widget _buildPlaylists() {
    return Column(
      children: [
        _playlistTile("Minhas Favoritas", Icons.favorite),
        _playlistTile("Trabalho/Focus", Icons.work),
        _playlistTile("Rock Clássico", Icons.radio),
      ],
    );
  }

  Widget _buildRecomendadas() {
    return Column(
      children: [
        _musicTile("Vibez do Momento", Icons.music_video),
        _musicTile("Top Brasil", Icons.star),
        _musicTile("Eletro Boost", Icons.flash_on),
      ],
    );
  }

  // ----------- COMPONENTES VISUAIS -----------

  Widget _musicCard(String titulo, IconData icone) {
    return Container(
      width: 110,
      margin: EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icone, color: Colors.white, size: 35),
          SizedBox(height: 10),
          Text(
            titulo,
            style: TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }

  Widget _playlistTile(String titulo, IconData icone) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      decoration: BoxDecoration(
        color: Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(icone, color: Colors.white70, size: 30),
          SizedBox(width: 15),
          Text(titulo, style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _musicTile(String titulo, IconData icone) {
    return ListTile(
      leading: Icon(icone, color: Colors.white70, size: 30),
      title: Text(titulo, style: TextStyle(color: Colors.white)),
      contentPadding: EdgeInsets.zero,
    );
  }
}
