import 'package:fpdart/fpdart.dart';
import 'package:pokedex_app/core/error/failure.dart';
import 'package:pokedex_app/core/usecase/usecase.dart';
import 'package:pokedex_app/features/home/data/models/evolution_chain_model.dart';
import 'package:pokedex_app/features/home/domain/repositories/pokemon_repository.dart';

class GetPokemonEvolutionChainUseCase
    implements UseCase<EvolutionChainModel, int> {
  final PokemonRepository repository;

  GetPokemonEvolutionChainUseCase({required this.repository});

  @override
  Future<Either<Failure, EvolutionChainModel>> call(int params) async {
    return await repository.getEvolutionChain(params);
  }
}
