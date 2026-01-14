import 'package:flutter/material.dart';

class PokemonCardWidget extends StatelessWidget {
  final String url;
  final String name;
  const PokemonCardWidget({
    super.key,
    required this.url,
    required this.name,
  });

  String _getPokemonImageUrl() {
    final parts = url.split('/').where((part) => part.isNotEmpty).toList();
    final id = parts.last;
    return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.network(
            _getPokemonImageUrl(),
            width: 200,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[300],
                child: const Icon(Icons.broken_image),
              );
            },
          ),
          Text(name),
        ],
      ),
    );
  }
}
