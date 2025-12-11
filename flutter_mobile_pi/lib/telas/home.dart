import 'package:flutter/material.dart';
import 'package:mobile_pi/storage/token_storage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String mes = 'aeeee';

  Future<dynamic> t() async {
    return await TokenStorage().pegarToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 40, 131, 72),
        leading: Container(height: 10, width: 10, decoration: BoxDecoration(color: Color.fromARGB(121, 52, 52, 151)),child: ElevatedButton(onPressed: (){
          TokenStorage().apagarToken();
          Navigator.pushReplacementNamed(context, '/login');
        }, child: Text('data')),),
      ),
      body: Center(
        child: Column(
          children: [
            Text(mes),
            ElevatedButton(onPressed: (){
              setState(() {
                mes = 'testado ${t()}';
              });
            }, child: Text('botao'))
          ],
        ),
      ),
    );
  }
}