import 'package:pokedex_app/features/home/data/datasources/pokemon_datasource.dart';
import 'package:pokedex_app/features/home/data/models/pokemon_response_model.dart';
import 'package:pokedex_app/features/home/domain/entities/pokemon_entity.dart';

class PokemonRepository {
  final PokemonDatasource pokemonDatasource;

  PokemonRepository({
    required this.pokemonDatasource,
  });

  Future<PokemonResponseModel> getPokemons() async {
    return pokemonDatasource.getPokemons();
  }

  Future<PokemonEntity> getPokemonByName(String name) async {
    return PokemonEntity(name: name, url: '');
  }
}
