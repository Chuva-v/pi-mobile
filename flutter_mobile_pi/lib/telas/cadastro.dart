import 'package:flutter/material.dart';
import 'package:mobile_pi/service/api.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});
  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  // controllers
  final nome = TextEditingController();
  final email = TextEditingController();
  final senha = TextEditingController();
  final confirmar = TextEditingController();

  final api = Api();

  String mensagem = '';
  bool carregando = false;

  // cores
  Color laranja = const Color.fromARGB(255, 243, 112, 30);
  Color azul    = const Color.fromARGB(255, 75, 96, 127);
  Color branco  = const Color.fromARGB(255, 232, 216, 201);
  Color bran_1  = const Color.fromARGB(255, 194, 196, 200);
  Color cinza   = const Color.fromARGB(255, 72, 76, 81);
  Color fundo   = const Color.fromARGB(255, 29, 29, 29);

  Future<void> registrar() async {
    final n = nome.text;
    final e = email.text;
    final s = senha.text;
    final c = confirmar.text;

    // se nao estiver vazio
    if (n.isEmpty || e.isEmpty || s.isEmpty || c.isEmpty) {
      setState(() => mensagem = "Preencha todos os campos.");
      return;
    }
    // senhas tem que ta iguais
    if (s != c) {
      setState(() => mensagem = "As senhas não coincidem.");
      return;
    }

    setState(() => carregando = true);
    final resp = await api.cadastrar(n, e, s);
    if (!mounted) return;
    setState(() => carregando = false);

    if (resp['ok']) {// cadastro feito -> tenta logaar direto
      print('teste');
      final resp = await api.login(e, s);
      if (!mounted) return; 
      if(resp['ok']){//caso consiga logar -> vai direto para o home
      print('certo');
        Navigator.pushReplacementNamed(context, '/home');
      } else {// caso não consiga -> vai para a tela de login
      print('errado');
        Navigator.pushReplacementNamed(context, '/login');
      }
    } else {// caso cadastro nao feito -> printa a mensagem
      setState(() => mensagem = resp['message']);
    }
  }
//- ------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    double altura = MediaQuery.sizeOf(context).height;
    double largura = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: fundo,
      body: Center(
        child: Column(
          children: [
            SizedBox(height: altura * 0.15),

            Text(
              "Criar conta",
              style: TextStyle(color: branco, fontSize: 30, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: altura * 0.1),

            // inputs
            Container(
              constraints: const BoxConstraints(maxWidth: 300),
              child: Column(
                spacing: 10,
                children: [

                  // nome
                  campoTexto("Nome", nome, largura),

                  // email
                  campoTexto("Email", email, largura),

                  // senha
                  campoSenha("Senha", senha, largura),

                  // confirmar senha
                  campoSenha("Confirmar senha", confirmar, largura),

                  Text(mensagem, style: TextStyle(color: azul)),
                ],
              ),
            ),

            SizedBox(height: altura * 0.1),

            // botão de cadastrar
            Container(
              constraints: BoxConstraints(maxWidth: 300),
              width: largura * 0.5,
              child: ElevatedButton(
                style: ButtonStyle(backgroundColor: WidgetStateProperty.all(laranja)),
                onPressed: registrar,
                child: carregando
                    ? CircularProgressIndicator(color: fundo)
                    : Text("Cadastrar", style: TextStyle(color: fundo)),
              ),
            ),

            SizedBox(height: altura * 0.02),
            // botão de voltar
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Voltar", style: TextStyle(color: branco)),
            )
          ],
        ),
      ),
    );
  }

//-----------------------------------------------------------------------------------------------------
  // widgets reaproveitáveis (estilo igual ao login)
  Widget campoTexto(String label, TextEditingController controller, double largura) {
    return SizedBox(
      width: largura * 0.5,
      child: TextFormField(
        controller: controller,
        style: TextStyle(color: fundo),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: laranja),
          filled: true,
          fillColor: bran_1,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: BorderSide(color: laranja),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: BorderSide(color: azul, width: 2.5),
          ),
        ),
      ),
    );
  }

  Widget campoSenha(String label, TextEditingController controller, double largura) {
    return SizedBox(
      width: largura * 0.5,
      child: TextFormField(
        controller: controller,
        obscureText: true,
        style: TextStyle(color: fundo),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: laranja),
          filled: true,
          fillColor: bran_1,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: BorderSide(color: laranja),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(100),
            borderSide: BorderSide(color: azul, width: 2.5),
          ),
        ),
      ),
    );
  }
}