import 'package:fpdart/fpdart.dart';
import 'package:pokedex_app/core/error/failure.dart';
import 'package:pokedex_app/core/usecase/usecase.dart';
import 'package:pokedex_app/features/home/data/models/pokemon_detail_model.dart';
import 'package:pokedex_app/features/home/domain/repositories/pokemon_repository.dart';

class GetPokemonDetailUseCase implements UseCase<PokemonDetailModel, String> {
  final PokemonRepository repository;

  GetPokemonDetailUseCase(this.repository);

  @override
  Future<Either<Failure, PokemonDetailModel>> call(String params) {
    return repository.getPokemonByName(params);
  }
}
