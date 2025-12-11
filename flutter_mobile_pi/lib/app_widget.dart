import 'package:flutter/material.dart';
import 'package:mobile_pi/service/api.dart';
import 'package:mobile_pi/storage/token_storage.dart';
import 'package:mobile_pi/telas/login.dart';
import 'package:mobile_pi/telas/home.dart';
//import 'package:mobile_pi/telas/teste.dart';



// class AppWidget extends StatelessWidget {
//   const AppWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       initialRoute: '/',
//       routes: {
//         '/'     : (_) => Login(),
//         '/home' : (_) => HomePage()
//       },
//     );
//   }
// }


class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {

  Widget? _telaInicial;

  Future<void> _verificarLogin() async {
    final tok = await TokenStorage().pegarToken();

    if(tok == null){
      setState(() {_telaInicial = const Login();});
      return;
    }

    final validar = await Api().me();

    if(validar){
      print('valido -----------');
      setState(() {
        _telaInicial = const HomePage();
      });

    } else {
      print('invalido -------------');
      await TokenStorage().apagarToken();
      setState(() {
        _telaInicial = const Login();
      });
    }
    

  }

  @override
  void initState(){
    super.initState();
    _verificarLogin();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _telaInicial ?? const _Splash(),
      routes: {
        '/home' : (_) => const HomePage(),
        '/login' : (_) => const Login()
      },
    );
  }
}

class _Splash extends StatelessWidget {
  const _Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(255, 182, 95, 25),
      body: Center(child: CircularProgressIndicator(),),
    );
  }
}