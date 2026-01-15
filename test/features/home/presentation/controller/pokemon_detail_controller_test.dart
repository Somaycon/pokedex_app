import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:pokedex_app/features/home/presentation/controller/pokemon_detail_controller.dart';
import 'package:pokedex_app/features/home/domain/usecases/get_pokemon_evolution_chain_usecase.dart';
import 'package:pokedex_app/features/home/domain/usecases/get_pokemon_detail_usecase.dart';
import 'package:pokedex_app/features/home/data/models/evolution_chain_model.dart';
import 'package:pokedex_app/features/home/data/models/chain_node_model.dart';
import 'package:pokedex_app/core/error/failure.dart';

class MockGetPokemonEvolutionChainUseCase extends Mock
    implements GetPokemonEvolutionChainUseCase {}

class MockGetPokemonDetailUseCase extends Mock
    implements GetPokemonDetailUseCase {}

void main() {
  late MockGetPokemonEvolutionChainUseCase mockEvolutionUsecase;
  late MockGetPokemonDetailUseCase mockDetailUsecase;
  late PokemonDetailController controller;

  setUp(() {
    mockEvolutionUsecase = MockGetPokemonEvolutionChainUseCase();
    mockDetailUsecase = MockGetPokemonDetailUseCase();
    controller = PokemonDetailController(
      getPokemonDetailUseCase: mockDetailUsecase,
      getPokemonEvolutionChainUseCase: mockEvolutionUsecase,
    );
  });

  final chain = ChainNodeModel(
    speciesName: 'bulbasaur',
    speciesUrl: '/1/',
    minLevel: null,
    evolvesTo: [],
  );
  final tModel = EvolutionChainModel(id: 1, chain: chain);

  test('loadEvolutionChain sets loaded state on success', () async {
    when(() => mockEvolutionUsecase.call(1)).thenAnswer(
      (_) async => Right<Failure, EvolutionChainModel>(tModel),
    );

    var notifications = 0;
    controller.addListener(() => notifications++);

    await controller.loadEvolutionChain(1);

    expect(
      controller.evolutionChainState.runtimeType.toString(),
      contains('EvolutionChainLoadedState'),
    );
    expect(controller.evolutionChainModel?.id, 1);
    expect(notifications, greaterThanOrEqualTo(1));
    verify(() => mockEvolutionUsecase.call(1)).called(1);
  });

  test('loadEvolutionChain sets empty state on NotFoundFailure', () async {
    when(() => mockEvolutionUsecase.call(2)).thenAnswer(
      (_) async => Left<Failure, EvolutionChainModel>(
        NotFoundFailure('not found'),
      ),
    );

    await controller.loadEvolutionChain(2);

    expect(
      controller.evolutionChainState.runtimeType.toString(),
      contains('EvolutionChainEmptyState'),
    );
  });

  test('loadEvolutionChain sets error state on other failures', () async {
    when(() => mockEvolutionUsecase.call(3)).thenAnswer(
      (_) async => Left<Failure, EvolutionChainModel>(
        ServerFailure('server'),
      ),
    );

    await controller.loadEvolutionChain(3);

    expect(
      controller.evolutionChainState.runtimeType.toString(),
      contains('EvolutionChainErrorState'),
    );
  });

  test('concurrent calls: last call wins', () async {
    final chain2 = ChainNodeModel(
      speciesName: 'ivysaur',
      speciesUrl: '/2/',
      minLevel: 16,
      evolvesTo: [],
    );
    final model1 = EvolutionChainModel(id: 1, chain: chain);
    final model2 = EvolutionChainModel(id: 2, chain: chain2);

    when(() => mockEvolutionUsecase.call(1)).thenAnswer(
      (_) async {
        await Future.delayed(Duration(milliseconds: 50));
        return Right<Failure, EvolutionChainModel>(model1);
      },
    );
    when(() => mockEvolutionUsecase.call(2)).thenAnswer(
      (_) async => Right<Failure, EvolutionChainModel>(model2),
    );

    final f1 = controller.loadEvolutionChain(1);
    final f2 = controller.loadEvolutionChain(2);

    await Future.wait([f1, f2]);

    expect(controller.evolutionChainModel?.id, 2);
  });
}
