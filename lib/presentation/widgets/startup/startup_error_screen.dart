import 'package:flutter/material.dart';

class StartupErrorScreen extends StatelessWidget {
  const StartupErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFF8FAFC), // Slate 50
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'No se pudo iniciar la app.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFFEF4444), // Red 500
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}
