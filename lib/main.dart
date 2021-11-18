import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:promosi/loading.dart';

void main() {
   WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
   runApp(MaterialApp(home: Main()));
}

class Main extends StatefulWidget {
  const Main({ Key? key }) : super(key: key);

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    
    return Loading();
  }
}