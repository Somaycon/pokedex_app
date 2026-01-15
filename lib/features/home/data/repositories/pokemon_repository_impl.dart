import 'package:fpdart/fpdart.dart';
import 'package:pokedex_app/core/error/failure.dart';
import 'package:pokedex_app/features/home/data/datasources/pokemon_local_datasource.dart';
import 'package:pokedex_app/features/home/data/datasources/pokemon_remote_datasource.dart';
import 'package:pokedex_app/features/home/data/models/evolution_chain_model.dart';
import 'package:pokedex_app/features/home/data/models/pokemon_detail_model.dart';
import 'package:pokedex_app/features/home/data/models/pokemon_response_model.dart';
import 'package:pokedex_app/features/home/domain/repositories/pokemon_repository.dart';

class PokemonRepositoryImpl implements PokemonRepository {
  final PokemonRemoteDatasource remoteDatasource;
  final PokemonLocalDatasource localDatasource;

  PokemonRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
  });

  @override
  Future<Either<Failure, PokemonResponseModel>> getPokemons({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final remotePokemonsResult = await remoteDatasource.getPokemons(
        limit: limit,
        offset: offset,
      );
      if (remotePokemonsResult.isRight()) {
        final remotePokemonsData = remotePokemonsResult.getOrElse(
          (l) => throw l,
        );
        await localDatasource.cachePokemons(remotePokemonsData);
        return Right(remotePokemonsData);
      } else {
        return remotePokemonsResult;
      }
    } catch (e) {
      try {
        final localPokemons = await localDatasource.getLastPokemons();
        return Right(localPokemons!);
      } catch (e) {
        return Left(CacheFailure('Sem internet e nenhum dado em cache'));
      }
    }
  }

  @override
  Future<Either<Failure, PokemonDetailModel>> getPokemonByName(
    String name,
  ) async {
    try {
      final remotePokemonResult = await remoteDatasource.getPokemonByName(name);
      if (remotePokemonResult.isRight()) {
        final remotePokemonData = remotePokemonResult.getOrElse(
          (l) => throw l,
        );
        return Right(remotePokemonData);
      } else {
        return remotePokemonResult;
      }
    } catch (e) {
      throw ServerFailure('Erro ao buscar Pokémon por nome.');
    }
  }

  @override
  Future<Either<Failure, EvolutionChainModel>> getEvolutionChain(
    int id,
  ) async {
    try {
      final response = await remoteDatasource.getEvolutionChain(id);
      if (response.isRight()) {
        final evolutionChainData = response.getOrElse(
          (l) => throw l,
        );
        return Right(evolutionChainData);
      } else {
        return response;
      }
    } catch (e) {
      throw ServerFailure('Erro ao buscar cadeia de evolução.');
    }
  }
}
