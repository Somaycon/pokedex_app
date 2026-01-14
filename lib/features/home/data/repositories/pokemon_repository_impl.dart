import 'package:fpdart/fpdart.dart';
import 'package:pokedex_app/core/error/failure.dart';
import 'package:pokedex_app/features/home/data/datasources/pokemon_datasource.dart';
import 'package:pokedex_app/features/home/data/models/pokemon_response_model.dart';
import 'package:pokedex_app/features/home/domain/entities/pokemon_entity.dart';
import 'package:pokedex_app/features/home/domain/repositories/pokemon_repository.dart';

class PokemonRepositoryImpl implements PokemonRepository {
  final PokemonDatasource pokemonDatasource;

  PokemonRepositoryImpl({required this.pokemonDatasource});

  @override
  Future<Either<Failure, PokemonResponseModel>> getPokemons({
    int limit = 20,
    int offset = 0,
  }) async {
    return pokemonDatasource.getPokemons(limit: limit, offset: offset);
  }

  @override
  Future<PokemonEntity> getPokemonByName(String name) {
    throw UnimplementedError();
  }
}
