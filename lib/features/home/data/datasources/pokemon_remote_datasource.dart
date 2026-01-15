import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:pokedex_app/core/error/failure.dart';
import 'package:pokedex_app/core/network/api_client.dart';
import 'package:pokedex_app/features/home/data/models/evolution_chain_model.dart';
import 'package:pokedex_app/features/home/data/models/pokemon_detail_model.dart';
import 'package:pokedex_app/features/home/data/models/pokemon_response_model.dart';

class PokemonRemoteDatasource {
  final ApiClient apiClient;

  PokemonRemoteDatasource({
    required this.apiClient,
  });

  Future<Either<Failure, PokemonResponseModel>> getPokemons({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final response = await apiClient.get(
        '/pokemon',
        queryParameters: {
          'limit': limit,
          'offset': offset,
        },
      );
      return Right(PokemonResponseModel.fromJson(response.data));
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return Left(ServerFailure('Tempo Esgotado. Verifique sua conexão.'));
      }
      return Left(NetworkFailure('Erro de rede. Tente novamente.'));
    } catch (_) {
      return Left(ServerFailure('Erro inesperado. Tente novamente.'));
    }
  }

  Future<Either<Failure, PokemonDetailModel>> getPokemonByName(
    String name,
  ) async {
    try {
      final response = await apiClient.get('/pokemon/$name');
      return Right(PokemonDetailModel.fromJson(response.data));
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return Left(ServerFailure('Tempo Esgotado. Verifique sua conexão.'));
      }
      return Left(NetworkFailure('Erro de rede. Tente novamente.'));
    } catch (_) {
      return Left(ServerFailure('Erro inesperado. Tente novamente.'));
    }
  }

  Future<Either<Failure, EvolutionChainModel>> getEvolutionChain(
    int id,
  ) async {
    try {
      final speciesResponse = await apiClient.get('/pokemon-species/$id/');
      final chainInfo =
          speciesResponse.data['evolution_chain'] as Map<String, dynamic>?;
      final chainUrl = chainInfo?['url'] as String?;
      if (chainUrl == null) {
        return Left(
          NotFoundFailure('Evolution chain not found for species $id'),
        );
      }

      final uri = Uri.parse(chainUrl);
      final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
      if (segments.isEmpty) {
        return Left(ServerFailure('Invalid evolution chain url: $chainUrl'));
      }
      final chainIdStr = segments.last;
      final chainId = int.tryParse(chainIdStr);
      if (chainId == null) {
        return Left(
          ServerFailure('Invalid evolution chain id parsed from $chainUrl'),
        );
      }

      try {
        final response = await apiClient.get('/evolution-chain/$chainId/');
        final evolutionChain = EvolutionChainModel.fromJson(response.data);
        return Right(evolutionChain);
      } on DioException catch (e) {
        final status = e.response?.statusCode;
        if (status == 404) {
          return Left(NotFoundFailure());
        }
        return Left(ServerFailure(e.toString()));
      }
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status == 404) {
        return Left(NotFoundFailure());
      }
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        return Left(ServerFailure('Tempo Esgotado. Verifique sua conexão.'));
      }
      return Left(NetworkFailure('Erro de rede. Tente novamente.'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
