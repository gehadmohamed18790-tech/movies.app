import 'package:flutter/material.dart';
import 'package:flutter_application_4/UI.dart';

void main() { 
  runApp(Note());
}
class Note extends StatelessWidget {
  const Note({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NotesPage(),
    );
  }
}

