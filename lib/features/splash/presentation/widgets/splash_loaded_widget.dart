import 'package:flutter/material.dart';

class SplashLoadedWidget extends StatelessWidget {
  const SplashLoadedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
