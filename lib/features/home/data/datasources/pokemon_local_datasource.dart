import 'package:pokedex_app/features/home/data/models/pokemon_response_model.dart';

abstract class PokemonLocalDatasource {
  Future<void> cachePokemons(PokemonResponseModel pokemonsList);
  Future<PokemonResponseModel?> getLastPokemons();
}

const cachedPokemonsKey = 'CACHED_POKEMONS';
