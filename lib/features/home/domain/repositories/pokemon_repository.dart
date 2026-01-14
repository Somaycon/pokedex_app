import 'package:fpdart/fpdart.dart';
import 'package:pokedex_app/core/error/failure.dart';
import 'package:pokedex_app/features/home/data/models/pokemon_response_model.dart';
import 'package:pokedex_app/features/home/domain/entities/pokemon_entity.dart';

abstract class PokemonRepository {
  Future<Either<Failure, PokemonResponseModel>> getPokemons({
    int limit = 20,
    int offset = 0,
  });

  Future<PokemonEntity> getPokemonByName(String name);
}
