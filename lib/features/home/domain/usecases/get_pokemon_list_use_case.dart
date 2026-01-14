import 'package:pokedex_app/features/home/data/models/pokemon_response_model.dart';
import 'package:pokedex_app/features/home/domain/repositories/pokemon_repository.dart';

class GetPokemonListUseCase {
  final PokemonRepository repository;

  GetPokemonListUseCase({
    required this.repository,
  });

  Future<PokemonResponseModel> call({int limit = 20, int offset = 0}) async {
    return await repository.getPokemons(limit: limit, offset: offset);
  }
}
