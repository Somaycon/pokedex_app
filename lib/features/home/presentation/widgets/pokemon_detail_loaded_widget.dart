import 'package:flutter/material.dart';
import 'package:pokedex_app/features/home/data/models/pokemon_detail_model.dart';
import 'package:pokedex_app/features/home/presentation/helpers/type_color_helper.dart';
import 'package:pokedex_app/features/home/presentation/helpers/type_icon_helper.dart';

class PokemonDetailLoadedWidget extends StatelessWidget {
  final PokemonDetailModel pokemon;
  const PokemonDetailLoadedWidget({
    super.key,
    required this.pokemon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Image.network(
              pokemon.imageUrl,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            pokemon.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 4,
            ),
            itemCount: pokemon.types.length,
            itemBuilder: (context, index) {
              final type = pokemon.types[index];
              final bg = getTypeColor(type);
              final textColor = getTypeTextColor(type);
              return Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        getTypeIcon(type),
                        size: 16,
                        color: textColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        type.toUpperCase(),
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Row(
            spacing: 20,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Icon(
                    Icons.straighten_rounded,
                    size: 38,
                  ),
                  Text(
                    '${pokemon.height}\' ${pokemon.weight}\'\'',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Icon(
                    Icons.fitness_center_rounded,
                    size: 38,
                  ),
                  Text(
                    '${pokemon.weight} kg',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
