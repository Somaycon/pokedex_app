import 'package:flutter/material.dart';
import 'package:pokedex_app/features/home/data/models/pokemon_detail_model.dart';
import 'package:pokedex_app/features/home/presentation/helpers/type_color_helper.dart';
import 'package:pokedex_app/features/home/presentation/helpers/type_icon_helper.dart';

class PokemonBaseInfoWidget extends StatelessWidget {
  final int height;
  final int weight;
  final PokemonDetailModel pokemon;
  const PokemonBaseInfoWidget({
    super.key,
    required this.height,
    required this.weight,
    required this.pokemon,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        spacing: 8,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$weight Kg',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Text(
                'Weight',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20,
            ),
            child: VerticalDivider(
              color: Colors.grey,
              thickness: 1.5,
            ),
          ),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 5,
            runSpacing: 8,
            children: pokemon.types.map((type) {
              final bg = getTypeColor(type);
              final textColor = getTypeTextColor(type);
              return Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: bg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      getTypeIcon(type),
                      size: 15,
                      color: textColor,
                    ),
                  ),
                  Text(
                    type.toUpperCase(),
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20,
            ),
            child: VerticalDivider(
              color: Colors.grey,
              thickness: 1.5,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$height m',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Text(
                'Height',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
