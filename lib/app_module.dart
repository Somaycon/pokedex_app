import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:pokedex_app/core/network/api_client.dart';
import 'package:pokedex_app/features/home/home_module.dart';
import 'package:pokedex_app/features/splash/splash_module.dart';

class AppModule extends Module {
  @override
  void binds(Injector i) {
    i.addLazySingleton(ApiClient.new);
    i.addLazySingleton<Dio>(() => ApiClient().dio);
  }

  @override
  void routes(RouteManager r) {
    r.module('/', module: SplashModule());
    r.module('/home', module: HomeModule());
  }
}
