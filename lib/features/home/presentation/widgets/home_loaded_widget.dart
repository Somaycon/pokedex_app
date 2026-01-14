import 'package:flutter/material.dart';
import 'package:pokedex_app/features/home/data/models/pokemon_model.dart';
import 'package:pokedex_app/features/home/presentation/widgets/pokemon_card_widget.dart';

class HomeLoadedWidget extends StatelessWidget {
  final List<PokemonModel> pokemonList;
  const HomeLoadedWidget({super.key, required this.pokemonList});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 3 / 4,
      ),
      itemCount: pokemonList.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: PokemonCardWidget(
            url: pokemonList[index].url,
            name: pokemonList[index].name,
          ),
        );
      },
    );
  }
}
