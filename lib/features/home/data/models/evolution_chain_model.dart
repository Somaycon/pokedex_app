import 'package:pokedex_app/features/home/data/models/chain_node_model.dart';

class EvolutionChainModel {
  final int? id;
  final ChainNodeModel chain;

  EvolutionChainModel({
    required this.id,
    required this.chain,
  });

  factory EvolutionChainModel.fromJson(Map<String, dynamic> json) {
    return EvolutionChainModel(
      id: json['id'] as int?,
      chain: ChainNodeModel.fromJson(json['chain'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'chain': chain.toJson(),
  };
}
