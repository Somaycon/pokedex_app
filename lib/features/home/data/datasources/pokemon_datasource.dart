import 'package:dio/dio.dart';
import 'package:pokedex_app/features/home/data/models/pokemon_response_model.dart';

class PokemonDatasource {
  final Dio dio;

  PokemonDatasource({
    required this.dio,
  });

  Future<PokemonResponseModel> getPokemons({
    int limit = 20,
    int offset = 0,
  }) async {
    try {
      final response = await dio.get(
        'https://pokeapi.co/api/v2/pokemon',
        queryParameters: {
          'limit': limit,
          'offset': offset,
        },
      );
      return PokemonResponseModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}
