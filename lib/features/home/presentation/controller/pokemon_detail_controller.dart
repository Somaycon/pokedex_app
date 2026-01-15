import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:pokedex_app/core/error/failure.dart';
import 'package:pokedex_app/features/home/data/models/pokemon_detail_model.dart';
import 'package:pokedex_app/features/home/domain/usecases/get_pokemon_detail_usecase.dart';
import 'package:pokedex_app/features/home/presentation/state/pokemon_detail_states.dart';

class PokemonDetailController extends ChangeNotifier {
  final GetPokemonDetailUseCase getPokemonDetailUseCase;
  PokemonDetailModel pokemon = PokemonDetailModel(
    name: '',
    imageUrl: '',
    types: [],
    height: 0,
    weight: 0,
  );
  PokemonDetailStates pokemonDetailState = PokemonDetailInitialState();

  PokemonDetailController({
    required this.getPokemonDetailUseCase,
  });

  Future<void> init(String name) async {
    await _loadPokemonDetail(name);
  }

  Future<void> _loadPokemonDetail(String name) async {
    pokemonDetailState = PokemonDetailLoadingState();
    notifyListeners();
    final Either<Failure, dynamic> response = await getPokemonDetailUseCase(
      name,
    );
    response.fold(
      (exception) {
        pokemonDetailState = PokemonDetailErrorState(
          message: exception.toString(),
        );
      },
      (response) {
        pokemon = response;
        pokemonDetailState = PokemonDetailLoadedState(pokemon: pokemon);
      },
    );
    notifyListeners();
  }
}
