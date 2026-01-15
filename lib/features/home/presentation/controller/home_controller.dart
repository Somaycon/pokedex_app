import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:pokedex_app/core/error/failure.dart';
import 'package:pokedex_app/features/home/data/enums/sort_option.dart';
import 'package:pokedex_app/features/home/data/models/pokemon_model.dart';
import 'package:pokedex_app/features/home/domain/usecases/get_pokemon_evolution_chain_usecase.dart';
import 'package:pokedex_app/features/home/domain/usecases/get_pokemon_detail_usecase.dart';
import 'package:pokedex_app/features/home/domain/usecases/get_pokemon_list_usecase.dart';
import 'package:pokedex_app/features/home/presentation/state/home_states.dart';

class HomeController extends ChangeNotifier {
  final GetPokemonListUseCase getPokemonListUseCase;
  final GetPokemonDetailUseCase getPokemonDetailUseCase;
  final GetPokemonEvolutionChainUseCase getPokemonEvolutionChainUseCase;
  List<PokemonModel> pokemonList = [];
  List<PokemonModel>? _allPokemonsCache;
  HomeStates homeState = HomeInitialState();

  int currentOffset = 0;
  final int limit = 20;
  int totalCount = 0;
  bool isLoadingMore = false;
  int pokemonId = 0;
  SortOption currentSortOption = SortOption.indexAsc;

  HomeController({
    required this.getPokemonListUseCase,
    required this.getPokemonDetailUseCase,
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

  void sortPokemons(SortOption option) {
    currentSortOption = option;
    if (pokemonList.isEmpty) {
      notifyListeners();
      return;
    }
    switch (option) {
      case SortOption.indexAsc:
        pokemonList.sort(
          (a, b) => extractPokemonId(a.url).compareTo(extractPokemonId(b.url)),
        );
        break;
      case SortOption.indexDesc:
        pokemonList.sort(
          (a, b) => extractPokemonId(b.url).compareTo(extractPokemonId(a.url)),
        );
        break;
      case SortOption.nameAsc:
        pokemonList.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortOption.nameDesc:
        pokemonList.sort((a, b) => b.name.compareTo(a.name));
        break;
    }
    notifyListeners();
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

  int extractPokemonId(String url) {
    final parts = url.split('/').where((part) => part.isNotEmpty).toList();
    final id = parts.last;
    return int.parse(id);
  }

  Future<List<PokemonModel>> loadAllPokemons() async {
    if (_allPokemonsCache != null) return _allPokemonsCache!;

    final int limit = totalCount > 0 ? totalCount : 100000;
    final Either<Failure, dynamic> res = await getPokemonListUseCase({
      'limit': limit,
      'offset': 0,
    });
    return res.fold((l) => <PokemonModel>[], (r) {
      final List<PokemonModel> list = List<PokemonModel>.from(r.results);
      _allPokemonsCache = list;
      return list;
    });
  }

  Future<Either<Failure, int>> searchPokemonIdByName(String name) async {
    final q = name.trim().toLowerCase();
    if (q.isEmpty) return Left(CacheFailure('Nome vazio'));

    final all = await loadAllPokemons();
    final exact = all
        .where((p) => p.name.toLowerCase() == q)
        .toList(growable: false);
    if (exact.isNotEmpty) {
      try {
        final id = extractPokemonId(exact.first.url);
        return Right(id);
      } catch (e) {
        return Left(ServerFailure('Erro ao extrair id local'));
      }
    }

    final Either<Failure, dynamic> res = await getPokemonDetailUseCase(q);
    return res.fold(
      (l) => Left(l),
      (r) {
        final id = (r.id as int?);
        if (id == null) {
          return Left(ServerFailure('ID não encontrado no detalhe'));
        }
        return Right(id);
      },
    );
  }
}
