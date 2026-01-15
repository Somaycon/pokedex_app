class ChainNodeModel {
  final String speciesName;
  final String speciesUrl;
  final int? minLevel;
  final List<ChainNodeModel> evolvesTo;

  ChainNodeModel({
    required this.speciesName,
    required this.speciesUrl,
    this.minLevel,
    required this.evolvesTo,
  });

  factory ChainNodeModel.fromJson(Map<String, dynamic> json) {
    final species = json['species'] as Map<String, dynamic>? ?? {};
    // evolution_details é uma lista; pegamos o primeiro entry.min_level quando presente
    int? parseMinLevel(Map<String, dynamic> src) {
      final details = src['evolution_details'] as List<dynamic>?;
      if (details == null || details.isEmpty) return null;
      final first = details.first as Map<String, dynamic>?;
      return first?['min_level'] as int?;
    }

    return ChainNodeModel(
      speciesName: species['name'] as String? ?? '',
      speciesUrl: species['url'] as String? ?? '',
      minLevel: parseMinLevel(json),
      evolvesTo:
          (json['evolves_to'] as List<dynamic>?)
              ?.map((e) => ChainNodeModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'species': {'name': speciesName, 'url': speciesUrl},
    'evolution_details': [
      if (minLevel != null) {'min_level': minLevel},
    ],
    'evolves_to': evolvesTo.map((e) => e.toJson()).toList(),
  };
}
