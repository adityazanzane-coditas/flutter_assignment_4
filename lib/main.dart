import 'package:flutter/material.dart';
import 'package:stopwatch/stopwatch_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stopwatch App',
      theme: ThemeData.dark(),
      home: StopwatchScreen(),
    );
  }
}
