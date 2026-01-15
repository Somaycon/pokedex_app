import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fpdart/fpdart.dart';
import 'package:pokedex_app/core/error/failure.dart';
import 'package:pokedex_app/features/home/data/models/pokemon_model.dart';
import 'package:pokedex_app/features/home/domain/usecases/get_pokemon_detail_usecase.dart';
import 'package:pokedex_app/features/home/domain/usecases/get_pokemon_list_usecase.dart';
import 'package:pokedex_app/features/home/presentation/controller/home_controller.dart';

class PokemonSearchDelegate extends SearchDelegate<String?> {
  final HomeController controller;
  final GetPokemonDetailUseCase getPokemonDetailUseCase =
      Modular.get<GetPokemonDetailUseCase>();
  final GetPokemonListUseCase getPokemonListUseCase =
      Modular.get<GetPokemonListUseCase>();

  List<PokemonModel>? _allPokemons;

  PokemonSearchDelegate({required this.controller});

  Future<Either<Failure, List<PokemonModel>>> _loadAllPokemons() async {
    if (_allPokemons != null) return Right(_allPokemons!);

    final int limit = controller.totalCount > 0
        ? controller.totalCount
        : 100000;
    final Either<Failure, dynamic> res = await getPokemonListUseCase({
      'limit': limit,
      'offset': 0,
    });

    return res.fold(
      (l) => Left(l),
      (r) {
        final List<PokemonModel> list = List<PokemonModel>.from(r.results);
        _allPokemons = list;
        return Right(list);
      },
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _searchAndNavigate(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        return snapshot.data ?? const Center(child: Text('Nenhum resultado'));
      },
    );
  }

  Future<Widget> _searchAndNavigate(BuildContext context) async {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return const Center(child: Text('Digite um nome'));

    final Either<Failure, List<PokemonModel>> allRes = await _loadAllPokemons();
    return allRes.fold(
      (l) => Center(child: Text('Erro ao carregar lista: ${l.toString()}')),
      (all) async {
        final exact = all
            .where((p) => p.name.toLowerCase() == q)
            .toList(growable: false);
        if (exact.isNotEmpty) {
          Modular.to.pushNamed(
            '/home/pokemon-detail',
            arguments: exact.first.name,
          );
          close(context, exact.first.name);
          return const SizedBox.shrink();
        }

        final Either<Failure, dynamic> res = await getPokemonDetailUseCase(q);
        return res.fold(
          (l) => Center(child: Text('Não encontrado: ${l.toString()}')),
          (r) {
            final name = (r.name ?? q);
            Modular.to.pushNamed('/home/pokemon-detail', arguments: name);
            close(context, name);
            return const SizedBox.shrink();
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) {
      final preview = controller.pokemonList.take(10).toList();
      return ListView.builder(
        itemCount: preview.length,
        itemBuilder: (context, index) {
          final PokemonModel p = preview[index];
          return ListTile(
            leading: const Icon(Icons.history),
            title: Text(p.name),
            onTap: () {
              close(context, p.name);
              Modular.to.pushNamed('/home/pokemon-detail', arguments: p.name);
            },
          );
        },
      );
    }

    return FutureBuilder<Either<Failure, List<PokemonModel>>>(
      future: _loadAllPokemons(),
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError) {
          return const Center(child: Text('Erro ao buscar sugestões'));
        }
        final either = snap.data;
        if (either == null) return const SizedBox.shrink();
        return either.fold(
          (l) => Center(child: Text('Erro: ${l.toString()}')),
          (all) {
            final filtered = all
                .where((p) => p.name.toLowerCase().contains(q))
                .toList();
            if (filtered.isEmpty) {
              return const Center(
                child: Text(
                  'Nenhuma sugestão. Pressione pesquisar para buscar remotamente.',
                ),
              );
            }
            return ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final PokemonModel p = filtered[index];
                return ListTile(
                  leading: const Icon(Icons.search),
                  title: Text(p.name),
                  onTap: () {
                    close(context, p.name);
                    Modular.to.pushNamed(
                      '/home/pokemon-detail',
                      arguments: p.name,
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
