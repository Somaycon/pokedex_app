class PokemonDetailModel {
  final int id;
  final String name;
  final String imageUrl;
  final List<String> types;
  final int height;
  final int weight;
  final String speciesUrl;

  PokemonDetailModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.types,
    required this.height,
    required this.weight,
    required this.speciesUrl,
  });

  factory PokemonDetailModel.fromJson(Map<String, dynamic> json) {
    return PokemonDetailModel(
      id: json['id'] as int,
      name: json['name'] as String,
      imageUrl:
          json['sprites']['other']['official-artwork']['front_default']
              as String,
      types: (json['types'] as List)
          .map<String>((type) => type['type']['name'] as String)
          .toList(),
      height: json['height'] as int,
      weight: json['weight'] as int,
      speciesUrl: (json['species'] as Map<String, dynamic>)['url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'types': types,
      'height': height,
      'weight': weight,
      'speciesUrl': speciesUrl,
    };
  }
}
