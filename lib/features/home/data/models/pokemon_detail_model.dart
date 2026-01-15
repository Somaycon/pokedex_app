class PokemonDetailModel {
  final String name;
  final String imageUrl;
  final List<String> types;
  final int height;
  final int weight;

  PokemonDetailModel({
    required this.name,
    required this.imageUrl,
    required this.types,
    required this.height,
    required this.weight,
  });

  factory PokemonDetailModel.fromJson(Map<String, dynamic> json) {
    return PokemonDetailModel(
      name: json['name'],
      imageUrl: json['sprites']['other']['official-artwork']['front_default'],
      types: (json['types'] as List)
          .map<String>((type) => type['type']['name'] as String)
          .toList(),
      height: json['height'],
      weight: json['weight'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'types': types,
      'height': height,
      'weight': weight,
    };
  }
}
