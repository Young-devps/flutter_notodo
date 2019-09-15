import 'package:flutter/material.dart';
import '../ui/notodo_screen.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: new Text('Notodo'),
        backgroundColor: Colors.black54,
      ),
      
      body: new NotodoScreen(),
    );
  }
}
