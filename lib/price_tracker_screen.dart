import 'package:flutter/material.dart';

class PriceTrackerScreen extends StatelessWidget {
  const PriceTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Real-Time Price Tracker')),
      body: const Center(child: Text('Price Tracker Screen')),
    );
  }
}
