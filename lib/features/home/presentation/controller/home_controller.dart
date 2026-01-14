import 'package:flutter/foundation.dart';
import 'package:pokedex_app/features/home/data/models/pokemon_model.dart';
import 'package:pokedex_app/features/home/domain/usecases/get_pokemon_list_use_case.dart';
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
    print('loadMorePokemons chamado');
    print('isLoadingMore: $isLoadingMore');
    print('currentOffset: $currentOffset');
    print('limit: $limit');
    print('totalCount: $totalCount');

    if (isLoadingMore || currentOffset + limit >= totalCount) {
      print('Retornando early');
      return;
    }

    currentOffset += limit;
    print('Novo offset: $currentOffset');
    await _loadPokemons();
  }

  Future<void> _loadPokemons() async {
    print('_loadPokemons chamado com offset: $currentOffset');

    if (currentOffset == 0) {
      homeState = HomeLoadingState();
    } else {
      isLoadingMore = true;
    }
    notifyListeners();

    try {
      final response = await getPokemonListUseCase(
        limit: limit,
        offset: currentOffset,
      );
      print('Resposta recebida: ${response.results.length} pokémons');
      print('Total: ${response.count}');

      totalCount = response.count;
      pokemonList.addAll(response.results);
      homeState = HomeLoadedState(pokemonList: pokemonList);
      isLoadingMore = false;
      notifyListeners();
    } catch (e) {
      print('Erro: $e');
      homeState = HomeErrorState();
      isLoadingMore = false;
      notifyListeners();
    }
  }

  bool get hasMorePokemons => currentOffset + limit < totalCount;
}
