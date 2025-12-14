import 'package:flutter/material.dart';
import 'package:mobile_pi/desenho/cores.dart';
// import 'package:mobile_pi/controllers/auth_controller.dart';
import 'package:mobile_pi/service/api.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {


  // variaveis ----
  final emailcontroller = TextEditingController();
  final senhacontroller = TextEditingController();

  // final autenticar = AuthController();
  final api = Api();
  final c   = Cores();

  String mensagem = '';

  bool carregando = false;


  // função -------
  Future<void> fazerlogin() async{
    final email = emailcontroller.text;
    final senha = senhacontroller.text;

    if(email.isEmpty || senha.isEmpty){
      //print('vazio');
      setState(() {mensagem = 'preencha todos os campos';});
      return;
    }

    setState(() {carregando = true;});

    //print('indo para api');
    final resp = await api.login(email, senha);
    //print('....');
    setState(() {carregando = false;});
    // print('.....');

    if(resp['ok']){
      //print('voltou para o login com ok');
      //print("LOGADO! TOKEN: ${resp['body']['token']}");
      //verifica se o widgth ainda existe
      if (!mounted) return; 
      Navigator.pushReplacementNamed(context, '/home');
      
    } else {
      //print('voltou para o login com erro');
      setState(() {
        mensagem = resp['message'];
      });
    }

  }
  // --------------

  @override
  Widget build(BuildContext context) {
    // variavel para espaço de acordo com o tamanho da tela
    double altura = MediaQuery.sizeOf(context).height;
    double largura = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: c.fundo(),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              // login ----------------------------------------------------
              SizedBox(height: altura * 0.2),
              Container(
                width: 200,
                height: 100,
                decoration: BoxDecoration(
                ),
                child: Center(
                  child: Text(
                    'LOGIN', 
                    style: TextStyle(
                      color: c.laranja(),
                      fontWeight: FontWeight.bold, 
                      fontSize: 40
                    )
                  ),
                ),
              ),

              // inputs -------------------------------------------------
              SizedBox(height: altura * 0.1),
              Container(
                constraints: BoxConstraints(
                  maxWidth: 300
                ),
                child: Column(
                  spacing: 5,
                  children: [

                    campos('Gmail', emailcontroller, largura, false),
                    campos('Password', senhacontroller, largura, true),

                    Text(mensagem, style: TextStyle(color: c.azul()),),
                  ],
                ),
              ),

              // botao -------------------------------------------------
              SizedBox(height: altura * 0.05),
              Container(
                constraints: BoxConstraints(maxWidth: 300),
                child: Column(
                  children: [
                    // botão para entrar
                    SizedBox(
                      width: largura * 0.5,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(c.branco1())
                        ),
                        onPressed: (){
                          fazerlogin();
                        },
                        child: carregando ? CircularProgressIndicator(
                          color: c.laranja(),
                        ) : Text(
                          "Entrar",
                          style: TextStyle(color: c.laranja(), fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                      ),
                    ),

                    SizedBox(height: altura * 0.01),
                    // botão para redireciona para cadstro
                    SizedBox(
                      width: largura * 0.5,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          // textStyle: WidgetStateProperty.all(TextStyle(fontSize: 18)),
                          backgroundColor: WidgetStateProperty.all(c.laranja())
                        ),
                        onPressed: (){
                          Navigator.pushNamed(context, '/cadastro');
                        },
                        child: Text(
                          "cadastrar-se",
                           style: TextStyle(color: c.fundo(),fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: altura * 0.05),
            ],
          ),
        ],
      ),
    );
  }

  Widget campos(String label, TextEditingController controller, double largura, bool senha){
    return SizedBox(
      width: largura * 0.5,
      child: TextFormField(
        style: TextStyle(color: c.fundo()),
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: c.laranja()),
          filled: true,
          fillColor: c.branco1(),
      
          // bordar quando nao ta focada
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: BorderSide(color: c.laranja()),
          ),
          
          //borda focada
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: BorderSide(
              color: c.azul(),
              width: 2.5)
          ),
      
          floatingLabelBehavior: FloatingLabelBehavior.never,
          
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100)
          ),
        ),
        obscureText: senha,
      ),
    );
  }

}
