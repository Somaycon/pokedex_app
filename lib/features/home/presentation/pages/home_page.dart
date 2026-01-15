import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:pokedex_app/features/home/presentation/controller/home_controller.dart';
import 'package:pokedex_app/features/home/presentation/state/home_states.dart';
import 'package:pokedex_app/features/home/presentation/widgets/home_error_widget.dart';
import 'package:pokedex_app/features/home/presentation/widgets/home_loaded_widget.dart';
import 'package:pokedex_app/features/home/presentation/widgets/pokemon_search_delegate.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = Modular.get<HomeController>();
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    controller.init();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
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
        title: Text(
          'Pokedex',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: PokemonSearchDelegate(controller: controller),
              );
            },
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: controller,
        builder: (context, child) {
          return switch (controller.homeState) {
            HomeInitialState() => throw UnimplementedError(),
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
    );
  }
}
