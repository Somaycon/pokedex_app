import 'package:flutter/material.dart';
import 'package:pokedex_app/features/home/data/models/pokemon_model.dart';
import 'package:pokedex_app/features/home/presentation/widgets/pokemon_card_widget.dart';

class HomeLoadedWidget extends StatelessWidget {
  final List<PokemonModel> pokemonList;
  final ScrollController scrollController;
  final bool isLoadMore;
  final Function() onLoadMore;
  const HomeLoadedWidget({
    super.key,
    required this.pokemonList,
    required this.isLoadMore,
    required this.scrollController,
    required this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels >=
            scrollInfo.metrics.maxScrollExtent - 500) {
          onLoadMore();
        }
        return false;
      },
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 3 / 4,
        ),
        itemCount: pokemonList.length + (isLoadMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == pokemonList.length) {
            return Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: PokemonCardWidget(
              url: pokemonList[index].url,
              name: pokemonList[index].name,
            ),
          );
        },
      ),
    );
  }
}
