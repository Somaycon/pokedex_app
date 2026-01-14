import 'package:pokedex_app/features/home/data/models/pokemon_model.dart';

sealed class HomeStates {}

class HomeInitialState extends HomeStates {}

class HomeLoadingState extends HomeStates {}

class HomeLoadedState extends HomeStates {
  final List<PokemonModel> pokemonList;

  HomeLoadedState({
    required this.pokemonList,
  });
}

class HomeErrorState extends HomeStates {
  final String message;

  HomeErrorState({required this.message});
}
