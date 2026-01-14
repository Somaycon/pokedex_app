import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:pokedex_app/features/home/presentation/controller/home_controller.dart';
import 'package:pokedex_app/features/home/presentation/state/home_states.dart';
import 'package:pokedex_app/features/home/presentation/widgets/home_loaded_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = Modular.get<HomeController>();

  @override
  void initState() {
    super.initState();
    controller.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Pokedex',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListenableBuilder(
        listenable: controller,
        builder: (context, child) {
          return switch (controller.homeState) {
            HomeInitialState() => throw UnimplementedError(),
            HomeLoadingState() => const Center(
              child: CircularProgressIndicator(),
            ),
            HomeLoadedState() => HomeLoadedWidget(
              pokemonList: controller.pokemonList,
            ),
            HomeErrorState() => throw UnimplementedError(),
          };
        },
      ),
    );
  }
}
