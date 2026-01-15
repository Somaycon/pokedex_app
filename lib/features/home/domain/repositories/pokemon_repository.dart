import 'package:fpdart/fpdart.dart';
import 'package:pokedex_app/core/error/failure.dart';
import 'package:pokedex_app/features/home/data/models/evolution_chain_model.dart';
import 'package:pokedex_app/features/home/data/models/pokemon_detail_model.dart';
import 'package:pokedex_app/features/home/data/models/pokemon_response_model.dart';

abstract class PokemonRepository {
  Future<Either<Failure, PokemonResponseModel>> getPokemons({
    int limit = 20,
    int offset = 0,
  });

  Future<Either<Failure, PokemonDetailModel>> getPokemonByName(String name);
  Future<Either<Failure, EvolutionChainModel>> getEvolutionChain(int id);
}
