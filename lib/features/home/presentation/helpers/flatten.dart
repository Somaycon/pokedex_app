import 'package:pokedex_app/features/home/data/models/chain_node_model.dart';

List<List<ChainNodeModel>> flattenPaths(ChainNodeModel root) {
  if (root.evolvesTo.isEmpty) return [[root]];
  final paths = <List<ChainNodeModel>>[];
  for (var child in root.evolvesTo) {
    for (var sub in flattenPaths(child)) {
      paths.add([root, ...sub]);
    }
  }
  return paths;
}

int? extractIdFromSpeciesUrl(String url) {
  final segments = Uri.parse(url).pathSegments;
  if (segments.isEmpty) return null;
  final last = segments.last.isEmpty ? (segments.length>1 ? segments[segments.length-2] : '') : segments.last;
  return int.tryParse(last);
}