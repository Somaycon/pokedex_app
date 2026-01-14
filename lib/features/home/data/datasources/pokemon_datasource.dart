import 'package:dio/dio.dart';
import 'package:pokedex_app/features/home/data/models/pokemon_response_model.dart';

class PokemonDatasource {
  final Dio dio;

  PokemonDatasource({
    required this.dio,
  });

  Future<PokemonResponseModel> getPokemons() async {
    final response = await dio.get('https://pokeapi.co/api/v2/pokemon');
    return PokemonResponseModel.fromJson(response.data);
  }
}
