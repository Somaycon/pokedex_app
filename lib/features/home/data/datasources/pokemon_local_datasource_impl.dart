import 'dart:convert';

import 'package:pokedex_app/core/error/failure.dart';
import 'package:pokedex_app/core/helpers/shared_prefs_helper.dart';
import 'package:pokedex_app/features/home/data/datasources/pokemon_local_datasource.dart';
import 'package:pokedex_app/features/home/data/models/pokemon_response_model.dart';

class PokemonLocalDatasourceImpl implements PokemonLocalDatasource {
  @override
  Future<bool> cachePokemons(PokemonResponseModel pokemonsList) async {
    final sharedPreferences = await SharedPrefsHelper.instance;
    final jsonString = jsonEncode(pokemonsList.toJson());
    try {
      final result = await sharedPreferences.setString(
        cachedPokemonsKey,
        jsonString,
      );
      return result;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<PokemonResponseModel?> getLastPokemons() async {
    final sharedPreferences = await SharedPrefsHelper.instance;
    final jsonString = sharedPreferences.getString(cachedPokemonsKey);
    if (jsonString != null) {
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      return PokemonResponseModel.fromJson(jsonMap);
    }
    throw CacheFailure('Nenhum dado em cache encontrado.');
  }
}
