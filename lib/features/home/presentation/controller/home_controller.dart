import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:pokedex_app/core/error/failure.dart';
import 'package:pokedex_app/features/home/data/models/pokemon_model.dart';
import 'package:pokedex_app/features/home/domain/usecases/get_pokemon_evolution_chain_usecase.dart';
import 'package:pokedex_app/features/home/domain/usecases/get_pokemon_list_usecase.dart';
import 'package:pokedex_app/features/home/presentation/state/home_states.dart';

class HomeController extends ChangeNotifier {
  final GetPokemonListUseCase getPokemonListUseCase;
  final GetPokemonEvolutionChainUseCase getPokemonEvolutionChainUseCase;
  List<PokemonModel> pokemonList = [];
  HomeStates homeState = HomeInitialState();

  int currentOffset = 0;
  final int limit = 20;
  int totalCount = 0;
  bool isLoadingMore = false;
  int pokemonId = 0;

  HomeController({
    required this.getPokemonListUseCase,
    required this.getPokemonEvolutionChainUseCase,
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

  String getPokemonImageUrl(String url) {
    final parts = url.split('/').where((part) => part.isNotEmpty).toList();
    final id = parts.last;
    return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
  }
}
