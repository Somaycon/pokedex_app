import 'package:pokedex_app/features/home/data/models/pokemon_model.dart';

class PokemonResponseModel {
  final int count;
  final String? next;
  final String? previous;
  final List<PokemonModel> results;

  PokemonResponseModel({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory PokemonResponseModel.fromJson(Map<String, dynamic> json) {
    return PokemonResponseModel(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      results: (json['results'] as List)
          .map<PokemonModel>((e) => PokemonModel.fromJson(e))
          .toList(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'next': next,
      'previous': previous,
      'results': results.map((e) => e.toJson()).toList(),
    };
  }
}
