import 'package:flutter_test/flutter_test.dart';
import 'package:pokedex_app/features/home/data/models/chain_node_model.dart';

void main() {
  test('fromJson handles missing fields and empty evolves_to', () {
    final json = <String, dynamic>{
      // species absent -> defaults to empty strings
    };

    final node = ChainNodeModel.fromJson(json);

    expect(node.speciesName, '');
    expect(node.speciesUrl, '');
    expect(node.minLevel, isNull);
    expect(node.evolvesTo, isEmpty);
  });

  test('fromJson parses min_level from evolution_details', () {
    final json = {
      'species': {'name': 'ivysaur', 'url': 'u'},
      'evolution_details': [
        {'min_level': 16},
      ],
      'evolves_to': [],
    };

    final node = ChainNodeModel.fromJson(json);

    expect(node.speciesName, 'ivysaur');
    expect(node.minLevel, 16);
  });

  test('toJson roundtrip keeps structure', () {
    final child = ChainNodeModel(
      speciesName: 'venusaur',
      speciesUrl: '/3/',
      minLevel: 32,
      evolvesTo: [],
    );
    final parent = ChainNodeModel(
      speciesName: 'ivysaur',
      speciesUrl: '/2/',
      minLevel: 16,
      evolvesTo: [child],
    );

    final json = parent.toJson();
    final reparsed = ChainNodeModel.fromJson(json);

    expect(reparsed.speciesName, parent.speciesName);
    expect(reparsed.evolvesTo.first.speciesName, 'venusaur');
    expect(reparsed.minLevel, 16);
  });
}
