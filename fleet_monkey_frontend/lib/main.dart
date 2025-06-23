
import 'package:flutter/material.dart';
import 'screens/load_list_screen.dart';

void main() => runApp(const FleetMonkeyApp());

class FleetMonkeyApp extends StatelessWidget {
  const FleetMonkeyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fleet Monkey',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const LoadListScreen(),
    );
  }
}

