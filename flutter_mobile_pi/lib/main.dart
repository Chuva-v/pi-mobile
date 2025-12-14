import 'package:flutter/material.dart';
import 'package:mobile_pi/app_widget.dart';
import 'package:mobile_pi/service/play_global.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); 
  PlayerStateGlobal.init();                  
  runApp(AppWidget());
}
