import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:pokedex_app/core/error/failure.dart';
import 'package:pokedex_app/features/home/data/models/pokemon_model.dart';
import 'package:pokedex_app/features/home/domain/usecases/get_pokemon_list_usecase.dart';
import 'package:pokedex_app/features/home/presentation/state/home_states.dart';

class HomeController extends ChangeNotifier {
  final GetPokemonListUseCase getPokemonListUseCase;
  List<PokemonModel> pokemonList = [];
  HomeStates homeState = HomeInitialState();

  int currentOffset = 0;
  final int limit = 20;
  int totalCount = 0;
  bool isLoadingMore = false;

  HomeController({
    required this.getPokemonListUseCase,
  });

  Future<void> init() async {
    currentOffset = 0;
    pokemonList = [];
    await _loadPokemons();
  }

  Future<void> loadMorePokemons() async {
    if (isLoadingMore || currentOffset + limit >= totalCount) {
      return;
    }

    currentOffset += limit;
    await _loadPokemons();
  }

  Future<void> _loadPokemons() async {
    if (currentOffset == 0) {
      homeState = HomeLoadingState();
    } else {
      isLoadingMore = true;
    }
    notifyListeners();

    final Either<Failure, dynamic> response = await getPokemonListUseCase({
      'limit': limit,
      'offset': currentOffset,
    });

    response.fold(
      (exception) {
        homeState = HomeErrorState(message: exception.toString());
      },
      (response) {
        totalCount = response.count;
        pokemonList.addAll(response.results);
        homeState = HomeLoadedState(pokemonList: pokemonList);
      },
    );
    isLoadingMore = false;
    notifyListeners();
  }

  bool get hasMorePokemons => currentOffset + limit < totalCount;
}
