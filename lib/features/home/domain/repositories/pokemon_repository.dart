import 'package:pokedex_app/features/home/data/datasources/pokemon_datasource.dart';
import 'package:pokedex_app/features/home/data/models/pokemon_response_model.dart';
import 'package:pokedex_app/features/home/domain/entities/pokemon_entity.dart';

class PokemonRepository {
  final PokemonDatasource pokemonDatasource;

  PokemonRepository({
    required this.pokemonDatasource,
  });

  Future<PokemonResponseModel> getPokemons({
    int limit = 20,
    int offset = 0,
  }) async {
    return pokemonDatasource.getPokemons(limit: limit, offset: offset);
  }

  Future<PokemonEntity> getPokemonByName(String name) async {
    return PokemonEntity(name: name, url: '');
  }
}
