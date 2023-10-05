import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SQLite database"),
        centerTitle: true,
      ),
      body: const Column(
        children: [
          Text("data"),
        ],
      ),
    );
  }
}
