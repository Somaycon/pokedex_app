import 'package:pokedex_app/features/home/data/models/pokemon_response_model.dart';
import 'package:pokedex_app/features/home/domain/repositories/pokemon_repository.dart';

class GetPokemonListUseCase {
  final PokemonRepository repository;

  GetPokemonListUseCase({
    required this.repository,
  });

  Future<PokemonResponseModel> call() async {
    return await repository.getPokemons();
  }
}
