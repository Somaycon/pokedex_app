import 'package:flutter/foundation.dart';
import 'package:pokedex_app/features/home/data/models/pokemon_model.dart';
import 'package:pokedex_app/features/home/domain/usecases/get_pokemon_list_use_case.dart';
import 'package:pokedex_app/features/home/presentation/state/home_states.dart';

class HomeController extends ChangeNotifier {
  final GetPokemonListUseCase getPokemonListUseCase;
  List<PokemonModel> pokemonList = [];
  HomeStates homeState = HomeInitialState();

  HomeController({
    required this.getPokemonListUseCase,
  });

  Future<void> init() async {
    homeState = HomeLoadingState();
    notifyListeners();
    try {
      pokemonList = (await getPokemonListUseCase()).results;

      homeState = HomeLoadedState(pokemonList: pokemonList);
      notifyListeners();
    } catch (e) {
      homeState = HomeErrorState();
      notifyListeners();
    }
  }
}
