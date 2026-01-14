import 'package:flutter/material.dart';

class SplashLoadedWidget extends StatelessWidget {
  const SplashLoadedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Pokedex',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
