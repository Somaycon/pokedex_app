import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:pokedex_app/features/home/data/models/pokemon_model.dart';
import 'package:pokedex_app/features/home/presentation/controller/home_controller.dart';
import 'package:pokedex_app/features/home/presentation/state/home_states.dart';
import 'package:pokedex_app/features/home/presentation/widgets/home_error_widget.dart';
import 'package:pokedex_app/features/home/presentation/widgets/home_loaded_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = Modular.get<HomeController>();
  late ScrollController _scrollController;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<PokemonModel> _suggestions = [];

  @override
  void initState() {
    super.initState();
    controller.init();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _searchFocusNode.addListener(() {
      if (!_searchFocusNode.hasFocus) {
        setState(() {
          _suggestions = [];
        });
      }
    });
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 500) {
      controller.loadMorePokemons();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0.0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'Pokedex',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: TextFormField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                hintText: 'Buscar Pokémon por nome',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) async {
                final q = value.trim().toLowerCase();
                if (q.isEmpty) {
                  setState(() => _suggestions = []);
                  return;
                }
                final all = await controller.loadAllPokemons();
                final filtered = all
                    .where((p) => p.name.toLowerCase().contains(q))
                    .take(6)
                    .toList(growable: false);
                setState(() => _suggestions = filtered);
              },
              onFieldSubmitted: (value) async {
                await _searchAndNavigate(value.trim().toLowerCase());
                _searchFocusNode.unfocus();
              },
            ),
          ),
          if (_suggestions.isNotEmpty)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(vertical: 4),
              constraints: const BoxConstraints(maxHeight: 240),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  final p = _suggestions[index];
                  return ListTile(
                    title: Text(p.name),
                    leading: const Icon(Icons.search),
                    onTap: () {
                      final id = controller.extractPokemonId(p.url);
                      _searchController.text = p.name;
                      setState(() => _suggestions = []);
                      _searchFocusNode.unfocus();
                      Modular.to.pushNamed(
                        '/home/pokemon-detail',
                        arguments: {
                          'name': p.name,
                          'pokemonId': id,
                        },
                      );
                    },
                  );
                },
              ),
            ),
          Expanded(
            child: ListenableBuilder(
              listenable: controller,
              builder: (context, child) {
                return switch (controller.homeState) {
                  HomeInitialState() => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  HomeLoadingState() => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  HomeLoadedState() => HomeLoadedWidget(
                    controller: controller,
                    pokemonList: controller.pokemonList,
                    isLoadMore: controller.isLoadingMore,
                    scrollController: _scrollController,
                    onLoadMore: () {
                      controller.loadMorePokemons();
                    },
                  ),
                  HomeErrorState(:final message) => HomeErrorWidget(
                    message: message,
                    onPressed: controller.init,
                  ),
                };
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _searchAndNavigate(String q) async {
    if (q.isEmpty) return;
    final result = await controller.searchPokemonIdByName(q);
    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao buscar: ${failure.toString()}')),
        );
      },
      (id) {
        Modular.to.pushNamed(
          '/home/pokemon-detail',
          arguments: {'name': q, 'pokemonId': id},
        );
      },
    );
  }
}
