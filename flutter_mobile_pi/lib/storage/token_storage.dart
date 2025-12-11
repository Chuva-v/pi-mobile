import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {

  Future<void> salvarToken(String token) async{
    print('estamos dentro de salvar token');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    print('tudo ok, voltando');
  }

  Future<String?> pegarToken() async {
    final prefs = await SharedPreferences.getInstance();
    print(' 1- ${prefs}');
    print(' 2- ${prefs.getString('token')}');
    return prefs.getString('token');
  }

  Future<void> apagarToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}