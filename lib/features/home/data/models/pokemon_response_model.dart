import 'package:pokedex_app/features/home/data/models/pokemon_model.dart';

class PokemonResponseModel {
  final int count;
  final String next;
  final List<PokemonModel> results;

  PokemonResponseModel({
    required this.count,
    required this.next,
    required this.results,
  });

  factory PokemonResponseModel.fromJson(Map<String, dynamic> json) {
    return PokemonResponseModel(
      count: json['count'],
      next: json['next'],
      results: (json['results'] as List)
          .map<PokemonModel>((e) => PokemonModel.fromJson(e))
          .toList(),
    );
  }
}
