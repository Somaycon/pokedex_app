import 'package:flutter/material.dart';
import 'package:pokedex_app/features/home/data/models/pokemon_detail_model.dart';
import 'package:pokedex_app/features/home/presentation/controller/pokemon_detail_controller.dart';
import 'package:pokedex_app/features/home/presentation/state/evolution_chain_states.dart';
import 'package:pokedex_app/features/home/presentation/widgets/evolution_chain_widget.dart';
import 'package:pokedex_app/features/home/presentation/widgets/home_error_widget.dart';
import 'package:pokedex_app/features/home/presentation/widgets/pokemon_detail_card_widget.dart';
import 'package:pokedex_app/features/home/presentation/widgets/pokemon_base_info_widget.dart';

class PokemonDetailLoadedWidget extends StatelessWidget {
  final PokemonDetailModel pokemon;
  final int pokemonId;
  final PokemonDetailController controller;
  const PokemonDetailLoadedWidget({
    super.key,
    required this.pokemon,
    required this.controller,
    required this.pokemonId,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Column(
          children: [
            Center(
              child: Image.network(
                pokemon.imageUrl,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            Text(
              pokemon.name.substring(0, 1).toUpperCase() +
                  pokemon.name.substring(1),
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            Column(
              spacing: 20,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                PokemonDetailCardWidget(
                  title: 'Base Info',
                  controller: controller,
                  body: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: PokemonBaseInfoWidget(
                          pokemon: pokemon,
                          height: pokemon.height,
                          weight: pokemon.weight,
                        ),
                      ),
                    ],
                  ),
                ),
                switch (controller.evolutionChainState) {
                  EvolutionChainInitialState() => Container(),
                  EvolutionChainLoadingState() => CircularProgressIndicator(),
                  EvolutionChainLoadedState() => PokemonDetailCardWidget(
                    title: 'Evolution Chain',
                    controller: controller,
                    body: EvolutionChainWidget(
                      chain: controller.evolutionChainModel!.chain,
                    ),
                  ),
                  EvolutionChainErrorState() => HomeErrorWidget(
                    message: 'Erro ao carregar linha evolutiva',
                    onPressed: () => controller.loadEvolutionChain(pokemonId),
                  ),
                  EvolutionChainEmptyState(:final message) =>
                    PokemonDetailCardWidget(
                      title: 'Evolution Chain',
                      controller: controller,
                      body: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(message),
                        ),
                      ),
                    ),
                },
              ],
            ),
          ],
        ),
      ),
    );
  }
}
