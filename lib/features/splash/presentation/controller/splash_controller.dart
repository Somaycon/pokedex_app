import 'package:pokedex_app/features/splash/presentation/state/splash_states.dart';

class SplashController {
  SplashStates splashState = SplashLoadedState();

  Future<void> init() async {
    // TODO: Adicionar lógica de carregamento
    // await Future.delayed(const Duration(seconds: 2));
    // Modular.to.navigate('/home');
  }
}
