import 'package:fpdart/fpdart.dart';
import 'package:pokedex_app/core/error/failure.dart';
import 'package:pokedex_app/core/usecase/usecase.dart';
import 'package:pokedex_app/features/home/data/models/pokemon_response_model.dart';
import 'package:pokedex_app/features/home/domain/repositories/pokemon_repository.dart';

class GetPokemonListUseCase
    implements UseCase<PokemonResponseModel, Map<String, int>> {
  final PokemonRepository repository;

  GetPokemonListUseCase({
    required this.repository,
  });

  @override
  Future<Either<Failure, PokemonResponseModel>> call(
    Map<String, int> params,
  ) async {
    final limit = params['limit'] ?? 20;
    final offset = params['offset'] ?? 0;
    return await repository.getPokemons(limit: limit, offset: offset);
  }
}
