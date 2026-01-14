import 'package:pokedex_app/features/home/domain/entities/pokemon_entity.dart';

class PokemonModel extends PokemonEntity {
  PokemonModel({
    required super.name,
    required super.url,
  });

  factory PokemonModel.fromJson(Map<String, dynamic> json) {
    return PokemonModel(
      name: json['name'],
      url: json['url'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
    };
  }
}
