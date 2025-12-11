import 'dart:convert';
// import 'package:flutter/gestures.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_pi/storage/token_storage.dart';

class Api {
  
  final String baseUrl = "http://127.0.0.1:8000/api";

  Future<Map<String, dynamic>> login(String email, String password) async {
    print('chegamos na funcao login');
    final url = Uri.parse("$baseUrl/login");

    final respostaApi = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    if(respostaApi.statusCode == 200){
      print('api respondeu ok');
      // salvando o token no aparelho
      Map respo = jsonDecode(respostaApi.body);

      print('pespo  ${respo}');

      final String token = respo['token'];
      print('token  ${token}');
      print('indo salvar o token');
      await TokenStorage().salvarToken(token);
      print('token salvo');

      //retornando um map para a tela login
      return {"ok" : true};

    } else {
      print('api respondeu erro');
      Map respo = jsonDecode(respostaApi.body);
      print('pespo  ${respo}');
      return {'ok' : false, 'message' : respo['message']};

    }
  }


  Future<Map<String, dynamic>> cadastrar(String name, String email, String senha) async {
    final url = Uri.parse('$baseUrl/registrar');

    final respo = await http.post(url,
      headers : {"Content-Type": "application/json"},
      body    : jsonEncode({
        'name'     : name,
        'email'    : email,
        'password' : senha
      })
    );

    return {
      'statusConde' : respo.statusCode,
      'body'        : jsonDecode(respo.body)
    };

  }

  Future<bool> me() async {
    final url = Uri.parse('$baseUrl/perfil');
    final token = await TokenStorage().pegarToken();

    if (token == null) {
      print('ta null');
      return false;
    
    } else {
      print('presente');
      final res = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      if (res.statusCode == 200) {
        print('resposta da api ok');
        return true;
      }

      print('api nao achou o token');
      return false;
    }

  }

}
