import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:pokedex_app/features/home/presentation/controller/pokemon_detail_controller.dart';
import 'package:pokedex_app/features/home/presentation/state/pokemon_detail_states.dart';
import 'package:pokedex_app/features/home/presentation/widgets/home_error_widget.dart';
import 'package:pokedex_app/features/home/presentation/widgets/pokemon_detail_loaded_widget.dart';

class PokemonDetailPage extends StatefulWidget {
  final String name;
  final int pokemonId;
  const PokemonDetailPage({
    super.key,
    required this.name,
    required this.pokemonId,
  });

  @override
  State<PokemonDetailPage> createState() => _PokemonDetailPageState();
}

class _PokemonDetailPageState extends State<PokemonDetailPage> {
  late PokemonDetailController controller;
  @override
  void initState() {
    super.initState();
    controller = Modular.get<PokemonDetailController>();
    controller.init(widget.name);
    controller.loadEvolutionChain(widget.pokemonId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0.0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      body: ListenableBuilder(
        listenable: controller,
        builder: (context, child) => switch (controller.pokemonDetailState) {
          PokemonDetailInitialState() => const Center(
            child: CircularProgressIndicator(),
          ),
          PokemonDetailLoadingState() => const Center(
            child: CircularProgressIndicator(),
          ),
          PokemonDetailLoadedState() => PokemonDetailLoadedWidget(
            pokemon: controller.pokemon,
            controller: controller,
            pokemonId: widget.pokemonId,
          ),

          PokemonDetailErrorState(:final message) => HomeErrorWidget(
            message: message,
            onPressed: () => controller.init(widget.name),
          ),
        },
      ),
    );
  }
}
