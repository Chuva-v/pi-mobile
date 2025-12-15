import 'package:flutter/material.dart';
import 'package:mobile_pi/desenho/cores.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mobile_pi/routes/rotaSemAnimacao.dart';
import 'package:mobile_pi/service/api.dart';
import 'package:mobile_pi/service/play_global.dart';
import 'package:mobile_pi/telas/home.dart';
import 'package:mobile_pi/telas/mini_player.dart';

class BuscarPage extends StatefulWidget {
  const BuscarPage({super.key});

  @override
  State<BuscarPage> createState() => _BuscarPageState();
}

class _BuscarPageState extends State<BuscarPage> {
  final api = Api();
  final c = Cores();
  final player = AudioPlayer();
  String? categoriaSelecionada;

  List musicas= [];
  bool carregando = true;
  String pesquisa = '';

  // variaveis para a animação do botão
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

    //print("Clicou no Home!");
    // aqui você faz ação: trocar página, atualizar menu, etc
  }

  Future<void> carregar() async {
    final resultado = await api.listarMusicas();

    setState(() {
      musicas = resultado;
      carregando = false;
    });
  }

  Future<void> tocar(Map musica) async {
    final url = "http://127.0.0.1:8000/storage/musicas/${musica['arquivo']}";

    await PlayerStateGlobal.player.setAudioSource(
      AudioSource.uri(Uri.parse(url)),
      preload: true,
    );

    await PlayerStateGlobal.player.play();

    PlayerStateGlobal.tocando = true;
    PlayerStateGlobal.capa = musica['capa'];
    PlayerStateGlobal.titulo = musica['titulo'];
    PlayerStateGlobal.artista = musica['artista'];
    PlayerStateGlobal.duracao = PlayerStateGlobal.player.duration ?? Duration.zero;
  }

  @override
  void initState() {
    super.initState();
    carregar();
  }

  @override
  Widget build(BuildContext context) {
    double largura = MediaQuery.sizeOf(context).width;

    return Scaffold(
      extendBody: true,
      backgroundColor: c.fundo(), // estilo Spotify

      // ---------------- APP BAR ----------------
      appBar: AppBar(
        backgroundColor: c.preto(),
        elevation: 0,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: c.fundo(),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextField(
            style: TextStyle(color: c.branco()),
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search, color: c.laranja()),
              hintText: 'Buscar músicas...',
              hintStyle: TextStyle(color: c.laranja()),
              border: InputBorder.none,
            ),
            onChanged: (valor) {
              setState(() {
                pesquisa = valor;
              });
            },
          ),
        ),
      ),

      // ---------------- BODY ----------------
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // =====================================
            // PESQUISA VAZIA
            // =====================================
            if (pesquisa.isEmpty) ...[

              // ---------------------------
              // NENHUMA CATEGORIA SELECIONADA
              // ---------------------------
              if (categoriaSelecionada == null) ...[
                // Linha 1
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _categoriaCard('Boombap', c.azul()),
                    _categoriaCard('Forró', c.laranja()),
                  ],
                ),

                // Linha 2
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _categoriaCard('Pagode', Color(0xFF1DB954)), // verde spotify
                    _categoriaCard('Reggae', Color.fromARGB(255, 154, 53, 53)),
                  ],
                ),

                // Linha 3
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _categoriaCard('MPB', Color(0xFF2A5334)),
                    _categoriaCard('Pop', Color(0xFF8E44AD)),
                  ],
                ),

                // Linha 4
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _categoriaCard('Rock', Color.fromARGB(255, 218, 218, 105)),
                    _categoriaCard('Funk', Color(0xFFE84393)),
                  ],
                ),

                // Linha 5
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _categoriaCard('Eletrônica', Color(0xFF0984E3)),
                    _categoriaCard('Rapper', Color(0xFF6C5CE7)),
                  ],
                ),

                // Linha 6
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _categoriaCard('Gospel', Color(0xFF00B894)),
                    _categoriaCard('Sertanejo', Color(0xFFD35400)),
                  ],
                ),

                // linhas vazias 
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(height: 200,),
                    SizedBox(height: 200,),
                  ],
                ),
              ],


              // ---------------------------
              // CATEGORIA SELECIONADA
              // ---------------------------
              if (categoriaSelecionada != null) ...[
                
                // Botão voltar
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      categoriaSelecionada = null;
                    });
                  },
                  icon: Icon(Icons.arrow_back, color: c.branco()),
                  label: Text(
                    categoriaSelecionada!,
                    style: TextStyle(color: c.branco()),
                  ),
                ),
                SizedBox(height: 5,),

                // Lista músicas da categoria
                ...musicas
                    .where((m) => m['categoria'] == categoriaSelecionada)
                    .map((m) {
                    return _itemMusica(m);
                  }
                ),
              ],

            ],

            // =====================================
            // PESQUISA COM TEXTO
            // =====================================
            if (pesquisa.isNotEmpty)
              ...musicas
                  .where((m) =>
                      m['titulo']
                          .toLowerCase()
                          .contains(pesquisa.toLowerCase()) ||
                      m['artista']
                          .toLowerCase()
                          .contains(pesquisa.toLowerCase()))
                  .map((m) {
                return _itemMusica(m);
              }
            ),
          ],
        )
      ),
      // ----------- RODAPE -----------------------
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.all(0),
        height: 110,
        color: const Color.fromARGB(0, 195, 185, 185),
        elevation: 0,
        child: Container(
          padding: EdgeInsets.only(bottom: 5),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                c.preto(),    // cor da parte de baixo (mais forte)
                Color.fromARGB(137, 0, 0, 0),    // cor do meio
                Color.fromARGB(0, 14, 14, 14),    // cor mais clara em cima
              ],
            )
          ),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // -----------------------Mini player--------------------------------
              MiniPlayer(),

              SizedBox(height: 5),

              // --------------------MENU INFERIO-----------------------------------
              Container(
                //color: c.azul(),
                padding: EdgeInsets.symmetric(horizontal: largura * 0.07),
                height: 55,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap:(){
                        animarHome('scaleHome');
                        final rotaAtual = ModalRoute.of(context)?.settings.name;
                        if (rotaAtual != '/home') {
                          Navigator.pushReplacement(
                            context,
                            Rotasemanimacao(
                              builder: (_) => HomePage(), 
                              settings: RouteSettings(name: '/home')
                            )
                          );
                        }
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

  Widget _categoriaCard(String nome, Color cor) {
    double largura = MediaQuery.sizeOf(context).width;
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        setState(() {
          categoriaSelecionada = nome;
        });
      },
      child: Container(
        height: 120,
        width: largura * 0.5 - 30,
        margin: EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(
          color: cor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            nome,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: c.preto(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _itemMusica(Map m) {
    final capaUrl =
        "http://127.0.0.1:8000/storage/capas/${m['capa']}";

    return InkWell(
      onTap: () => tocar(m),
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        child: Row(
          children: [
            // -------- CAPA --------
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                capaUrl,
                width: 55,
                height: 55,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 55,
                  height: 55,
                  color: Colors.grey[800],
                  child: Icon(Icons.music_note, color: c.branco()),
                ),
              ),
            ),

            SizedBox(width: 12),

            // -------- TEXTO --------
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    m['titulo'],
                    style: TextStyle(
                      color: c.branco(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    m['artista'],
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}