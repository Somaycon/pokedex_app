import 'package:flutter_modular/flutter_modular.dart';
import 'package:pokedex_app/features/splash/presentation/controller/splash_controller.dart';
import 'package:pokedex_app/features/splash/presentation/pages/splash_page.dart';

class SplashModule extends Module {
  @override
  void binds(Injector i) {
    i.addLazySingleton(SplashController.new);
    super.binds(i);
  }

  @override
  void routes(RouteManager r) {
    r.child(
      '/',
      child: (context) => SplashPage(),
    );
    super.routes(r);
  }
}
