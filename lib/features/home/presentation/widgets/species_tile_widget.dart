import 'package:flutter/material.dart';
import 'package:pokedex_app/features/home/data/models/chain_node_model.dart';
import 'package:pokedex_app/features/home/presentation/helpers/flatten.dart';

class SpeciesTileWidget extends StatelessWidget {
  final ChainNodeModel node;
  final double imageSize = 80;
  const SpeciesTileWidget({
    super.key,
    required this.node,
  });

  @override
  Widget build(BuildContext context) {
    final id = extractIdFromSpeciesUrl(node.speciesUrl);
    final imageUrl = id != null
        ? 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png'
        : null;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (imageUrl != null)
          Image.network(
            imageUrl,
            height: imageSize,
            width: imageSize,
            fit: BoxFit.contain,
          ),
        const SizedBox(height: 6),
        Text(
          node.speciesName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        if (node.minLevel != null)
          Text(
            'Lv ${node.minLevel}',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
      ],
    );
  }
}
