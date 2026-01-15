import 'package:flutter/material.dart';
import 'package:pokedex_app/features/home/presentation/controller/pokemon_detail_controller.dart';
import 'package:pokedex_app/features/home/presentation/helpers/type_color_helper.dart';
import 'package:pokedex_app/features/home/presentation/widgets/pokemon_title_badge_widget.dart';

class PokemonDetailCardWidget extends StatelessWidget {
  final PokemonDetailController controller;
  final Widget body;
  final String title;
  const PokemonDetailCardWidget({
    super.key,
    required this.controller,
    required this.body,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) => Stack(
        alignment: Alignment.topCenter,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: body,
            ),
          ),
          PokemonTitleBadgeWidget(
            color: getTypeColor(controller.pokemon.types[0]),
            title: title,
          ),
        ],
      ),
    );
  }
}
