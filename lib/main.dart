import 'package:flutter/material.dart';
import 'ui/home.dart';


void main() =>  runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'Notodo',
      home: new Home(),
    );
  }
}

