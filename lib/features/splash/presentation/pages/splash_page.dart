import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:pokedex_app/features/splash/presentation/controller/splash_controller.dart';
import 'package:pokedex_app/features/splash/presentation/state/splash_states.dart';
import 'package:pokedex_app/features/splash/presentation/widgets/splash_loaded_widget.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  late SplashController controller;
  @override
  void initState() {
    super.initState();
    controller = Modular.get<SplashController>();
    controller.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        child: switch (controller.splashState) {
          SplashLoadedState() => SplashLoadedWidget(),
        },
      ),
    );
  }
}
