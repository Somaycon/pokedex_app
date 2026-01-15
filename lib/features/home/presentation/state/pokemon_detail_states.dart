import 'package:pokedex_app/features/home/data/models/pokemon_detail_model.dart';

sealed class PokemonDetailStates {}

class PokemonDetailInitialState extends PokemonDetailStates {}

class PokemonDetailLoadingState extends PokemonDetailStates {}

class PokemonDetailLoadedState extends PokemonDetailStates {
  final PokemonDetailModel pokemon;

  PokemonDetailLoadedState({required this.pokemon});
}

class PokemonDetailErrorState extends PokemonDetailStates {
  final String message;
  PokemonDetailErrorState({required this.message});
}
