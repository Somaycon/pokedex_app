import 'package:flutter/material.dart';
import 'package:pokedex_app/features/home/data/models/chain_node_model.dart';
import 'package:pokedex_app/features/home/presentation/helpers/flatten.dart';
import 'package:pokedex_app/features/home/presentation/widgets/species_tile_widget.dart';

class EvolutionChainWidget extends StatelessWidget {
  final ChainNodeModel chain;
  const EvolutionChainWidget({required this.chain, super.key});

  @override
  Widget build(BuildContext context) {
    final paths = flattenPaths(chain);
    return Column(
      children: paths.map((path) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < path.length; i++) ...[
                  GestureDetector(
                    onTap: () {
                      // navegar ou buscar detalhes do pokemon se quiser
                    },
                    child: SpeciesTileWidget(node: path[i]),
                  ),
                  if (i != path.length - 1) ...[
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.arrow_forward,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 8),
                  ],
                ],
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
