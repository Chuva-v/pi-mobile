import 'package:flutter/material.dart';
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



  // cores
  Color laranja = Color.fromARGB(255, 243, 112, 30);
  Color azul    = Color.fromARGB(255, 75, 96, 127);
  Color branco  = Color.fromARGB(255, 232, 216, 201);
  Color bran_1  = Color.fromARGB(255, 194, 196, 200);
  Color cinza   = Color.fromARGB(255, 72, 76, 81);
  Color verde   = Color.fromARGB(255, 0, 255, 67);
  Color fundo   = Color.fromARGB(255, 29, 29, 29);


  @override
  Widget build(BuildContext context) {
    // variavel para espaço de acordo com o tamanho da tela
    double altura = MediaQuery.sizeOf(context).height;
    double largura = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: fundo,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              // logo ----------------------------------------------------
              SizedBox(height: altura * 0.2),
              Container(
                color: azul,
                width: 100,
                height: 100,
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

                    Text(mensagem, style: TextStyle(color: azul),),
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
                          backgroundColor: WidgetStateProperty.all(bran_1)
                        ),
                        onPressed: (){
                          fazerlogin();
                        },
                        child: carregando ? CircularProgressIndicator(
                          color: laranja,
                        ) : Text(
                          "Entrar",
                          style: TextStyle(color: laranja, fontSize: 16, fontWeight: FontWeight.bold),
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
                          backgroundColor: WidgetStateProperty.all(laranja)
                        ),
                        onPressed: (){
                          Navigator.pushNamed(context, '/cadastro');
                        },
                        child: Text(
                          "cadastrar-se",
                           style: TextStyle(color: fundo,fontSize: 16, fontWeight: FontWeight.bold),
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
        style: TextStyle(color: fundo),
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: laranja),
          filled: true,
          fillColor: bran_1,
      
          // bordar quando nao ta focada
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: BorderSide(color: laranja),
          ),
          
          //borda focada
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: BorderSide(
              color: azul,
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
