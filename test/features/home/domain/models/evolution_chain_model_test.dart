import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_app/features/home/data/models/evolution_chain_model.dart';
import 'package:pokedex_app/features/home/data/models/chain_node_model.dart';

void main() {
  test('EvolutionChainModel fromJson and toJson roundtrip', () {
    final chain = ChainNodeModel(
      speciesName: 'bulbasaur',
      speciesUrl: '/1/',
      minLevel: null,
      evolvesTo: [
        ChainNodeModel(
          speciesName: 'ivysaur',
          speciesUrl: '/2/',
          minLevel: 16,
          evolvesTo: [],
        ),
      ],
    );

    final model = EvolutionChainModel(id: 1, chain: chain);

    final json = model.toJson();
    final reparsed = EvolutionChainModel.fromJson(json);

    expect(reparsed.id, 1);
    expect(reparsed.chain.speciesName, 'bulbasaur');
    expect(reparsed.chain.evolvesTo.first.minLevel, 16);
  });
}
