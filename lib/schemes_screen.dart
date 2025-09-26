import 'package:flutter/material.dart';

class SchemesScreen extends StatelessWidget {
  const SchemesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Government Schemes in Sikkim')),
      body: const Center(child: Text('Schemes Screen')),
    );
  }
}
