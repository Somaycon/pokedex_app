import 'package:flutter_modular/flutter_modular.dart';
import 'package:pokedex_app/app_module.dart';
import 'package:pokedex_app/features/home/data/datasources/pokemon_datasource.dart';
import 'package:pokedex_app/features/home/domain/repositories/pokemon_repository.dart';
import 'package:pokedex_app/features/home/domain/usecases/get_pokemon_list_use_case.dart';
import 'package:pokedex_app/features/home/presentation/controller/home_controller.dart';
import 'package:pokedex_app/features/home/presentation/pages/home_page.dart';

class HomeModule extends Module {
  @override
  List<Module> get imports => [
    AppModule(),
  ];

  @override
  void binds(Injector i) {
    i.addLazySingleton<PokemonDatasource>(PokemonDatasource.new);
    i.addLazySingleton<PokemonRepository>(PokemonRepository.new);
    i.addLazySingleton<GetPokemonListUseCase>(GetPokemonListUseCase.new);
    i.addLazySingleton<HomeController>(HomeController.new);
    super.binds(i);
  }

  @override
  void routes(RouteManager r) {
    r.child(
      '/',
      child: (context) => HomePage(),
    );
    super.routes(r);
  }
}
