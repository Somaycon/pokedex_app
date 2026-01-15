import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:pokedex_app/core/error/failure.dart';
import 'package:pokedex_app/features/home/data/models/evolution_chain_model.dart';
import 'package:pokedex_app/features/home/data/models/pokemon_detail_model.dart';
import 'package:pokedex_app/features/home/domain/usecases/get_pokemon_detail_usecase.dart';
import 'package:pokedex_app/features/home/domain/usecases/get_pokemon_evolution_chain_usecase.dart';
import 'package:pokedex_app/features/home/presentation/state/evolution_chain_states.dart';
import 'package:pokedex_app/features/home/presentation/state/pokemon_detail_states.dart';

class PokemonDetailController extends ChangeNotifier {
  final GetPokemonDetailUseCase getPokemonDetailUseCase;
  final GetPokemonEvolutionChainUseCase getPokemonEvolutionChainUseCase;
  PokemonDetailModel pokemon = PokemonDetailModel(
    id: 0,
    name: '',
    imageUrl: '',
    types: [],
    height: 0,
    weight: 0,
    speciesUrl: '',
  );
  EvolutionChainModel? evolutionChainModel;
  int? _currentEvolutionRequestId;

  PokemonDetailStates pokemonDetailState = PokemonDetailInitialState();
  EvolutionChainStates evolutionChainState = EvolutionChainInitialState();

  PokemonDetailController({
    required this.getPokemonDetailUseCase,
    required this.getPokemonEvolutionChainUseCase,
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

  Future<void> loadEvolutionChain(int id) async {
    _currentEvolutionRequestId = id;
    evolutionChainState = EvolutionChainLoadingState();
    notifyListeners();

    final Either<Failure, EvolutionChainModel> response =
        await getPokemonEvolutionChainUseCase(id);

    if (_currentEvolutionRequestId != id) return;

    response.fold(
      (exception) {
        if (exception is NotFoundFailure) {
          evolutionChainState = EvolutionChainEmptyState();
          notifyListeners();
          return;
        }
        evolutionChainState = EvolutionChainErrorState(
          message: exception.message,
        );
        notifyListeners();
      },
      (response) {
        evolutionChainModel = response;
        evolutionChainState = EvolutionChainLoadedState(
          evolutionChain: evolutionChainModel!,
        );
        notifyListeners();
      },
    );
  }
}
