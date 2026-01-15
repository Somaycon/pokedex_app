import 'package:pokedex_app/features/home/data/models/evolution_chain_model.dart';

sealed class EvolutionChainStates {}

class EvolutionChainInitialState extends EvolutionChainStates {}

class EvolutionChainLoadingState extends EvolutionChainStates {}

class EvolutionChainLoadedState extends EvolutionChainStates {
  final EvolutionChainModel evolutionChain;
  EvolutionChainLoadedState({required this.evolutionChain});
}

class EvolutionChainErrorState extends EvolutionChainStates {
  final String message;
  EvolutionChainErrorState({required this.message});
}
