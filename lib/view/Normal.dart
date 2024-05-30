import 'package:flutter/material.dart';

class NormalScreen extends StatefulWidget {
  const NormalScreen({super.key});

  @override
  State<NormalScreen> createState() => _NormalScreenState();
}

class _NormalScreenState extends State<NormalScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Welcome'),
      ),
    );
  }
}
