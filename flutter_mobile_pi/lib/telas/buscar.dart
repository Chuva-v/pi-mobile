import 'package:flutter/material.dart';
import 'package:mobile_pi/desenho/cores.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mobile_pi/routes/rotaSemAnimacao.dart';
import 'package:mobile_pi/service/api.dart';
import 'package:mobile_pi/service/play_global.dart';
import 'package:mobile_pi/telas/home.dart';
import 'package:mobile_pi/telas/meus.dart';
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
    print('url : ${url}');

    await PlayerStateGlobal.player.setAudioSource(
      AudioSource.uri(Uri.parse(url)),
    );

    await PlayerStateGlobal.player.play();

    PlayerStateGlobal.tocando = true;
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
          children: [

            // if para mostrar as categorias caso a barra de pesquisa esteja vazia
            if(pesquisa.isEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 120,
                    width: largura * 0.5 - 30,
                    margin: EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: c.azul(),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(child: Text('TESTE', style: TextStyle(fontSize: largura * 0.06, fontWeight: FontWeight.bold, color: c.preto()))),
                  ),
                  Container(
                    height: 120,
                    width: largura * 0.5 - 30,
                    margin: EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: c.laranja(),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ],
              ),
              

            ],

            // mostra as musicas com nome ou cantor parecidos
            if(pesquisa.isNotEmpty)
              ...musicas
                .where((m) =>
                  // pesquisa.isEmpty ||
                  m['titulo'].toLowerCase().contains(pesquisa.toLowerCase()) ||
                  m['artista'].toLowerCase().contains(pesquisa.toLowerCase())
                )
                
                .map((m) {
                  return ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        'http://SEU_IP:8000/api/capas/${m['capa']}',
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 50,
                            height: 50,
                            color: Colors.grey[800],
                            child: Icon(
                              Icons.music_note,
                              color: Colors.white70,
                              size: 30,
                            ),
                          );
                        },
                      ),
                    ),
  
                    title: Text(m['titulo'], style: TextStyle(color: Colors.white)),
                    subtitle: Text(m['artista'], style: TextStyle(color: Colors.white70)),
                    //trailing: Icon(Icons.play_arrow, color: Colors.white),
                    onTap: () {
                      tocar(m);
                    },
                  );
                })
                //.toList()
          ],
        ),

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

                    SizedBox(width: largura * 0.15),

                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap:(){
                        animarHome('scaleLib');
                        final rotaAtual = ModalRoute.of(context)?.settings.name;

                        if (rotaAtual != '/meus') {
                          Navigator.pushReplacement(
                            context,
                            Rotasemanimacao(
                              builder: (_) => MeusPage(), 
                              settings: RouteSettings(name: '/meus')
                            )
                          );
                        }
                      },
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
}