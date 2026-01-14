import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:pokedex_app/core/error/failure.dart';
import 'package:pokedex_app/core/network/api_client.dart';
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
}
