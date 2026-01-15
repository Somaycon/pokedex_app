import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:pokedex_app/features/home/domain/usecases/get_pokemon_evolution_chain_usecase.dart';
import 'package:pokedex_app/features/home/data/models/evolution_chain_model.dart';
import 'package:pokedex_app/features/home/data/models/chain_node_model.dart';
import 'package:pokedex_app/core/error/failure.dart';
import '../../../../mocks/mock_pokemon_repository.dart';

void main() {
  late MockPokemonRepository mockRepo;
  late GetPokemonEvolutionChainUseCase usecase;

  setUp(() {
    mockRepo = MockPokemonRepository();
    usecase = GetPokemonEvolutionChainUseCase(repository: mockRepo);
  });

  final chain = ChainNodeModel(
    speciesName: 'bulbasaur',
    speciesUrl: 'https://pokeapi.co/api/v2/pokemon-species/1/',
    minLevel: null,
    evolvesTo: [],
  );
  final tModel = EvolutionChainModel(id: 1, chain: chain);

  test(
    'deve retornar EvolutionChainModel quando o repositório retornar sucesso',
    () async {
      when(
        () => mockRepo.getEvolutionChain(1),
      ).thenAnswer((_) async => Right<Failure, EvolutionChainModel>(tModel));

      final result = await usecase.call(1);

      expect(result.isRight(), true);
      result.match(
        (l) => fail('expected Right, got Left'),
        (r) => expect(r.id, equals(1)),
      );
      verify(() => mockRepo.getEvolutionChain(1)).called(1);
    },
  );

  test('deve retornar Failure quando o repositório retornar falha', () async {
    final failure = ServerFailure('Erro');
    when(
      () => mockRepo.getEvolutionChain(1),
    ).thenAnswer((_) async => Left<Failure, EvolutionChainModel>(failure));

    final result = await usecase.call(1);

    expect(result.isLeft(), true);
    result.match(
      (l) => expect(l, isA<ServerFailure>()),
      (r) => fail('expected Left, got Right'),
    );
    verify(() => mockRepo.getEvolutionChain(1)).called(1);
  });

  test('deve propagar NotFoundFailure corretamente', () async {
    final failure = NotFoundFailure('não encontrado');
    when(() => mockRepo.getEvolutionChain(2)).thenAnswer(
      (_) async => Left<Failure, EvolutionChainModel>(failure),
    );

    final result = await usecase.call(2);

    expect(result.isLeft(), true);
    result.match(
      (l) => expect(l, isA<NotFoundFailure>()),
      (r) => fail('expected Left, got Right'),
    );
    verify(() => mockRepo.getEvolutionChain(2)).called(1);
  });

  test('deve propagar NetworkFailure corretamente', () async {
    final failure = NetworkFailure('timeout');
    when(() => mockRepo.getEvolutionChain(3)).thenAnswer(
      (_) async => Left<Failure, EvolutionChainModel>(failure),
    );

    final result = await usecase.call(3);

    expect(result.isLeft(), true);
    result.match(
      (l) => expect(l, isA<NetworkFailure>()),
      (r) => fail('expected Left, got Right'),
    );
    verify(() => mockRepo.getEvolutionChain(3)).called(1);
  });
}
