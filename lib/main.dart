import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:transl8/canvas/home.dart';

void main() {
  OpenAI.apiKey = const String.fromEnvironment('OPEN_AI');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const HomeCanvas(),
    );
  }
}

/*
prompt para tradução:

*/
