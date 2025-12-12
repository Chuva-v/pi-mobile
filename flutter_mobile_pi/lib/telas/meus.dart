import 'package:flutter/material.dart';
import 'package:mobile_pi/desenho/cores.dart';
import 'package:mobile_pi/routes/rotaSemAnimacao.dart';
import 'package:mobile_pi/service/api.dart';
import 'package:mobile_pi/telas/buscar.dart';
import 'package:mobile_pi/telas/home.dart';

class MeusPage extends StatefulWidget {
  const MeusPage({super.key});

  @override
  State<MeusPage> createState() => _MeusPageState();
}

class _MeusPageState extends State<MeusPage> {
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

                    SizedBox(width: largura * 0.15),

                    InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap:(){
                        animarHome('scaleLib');
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