import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:pokedex_app/features/home/domain/usecases/get_pokemon_list_usecase.dart';
import 'package:pokedex_app/features/home/data/models/pokemon_response_model.dart';
import 'package:pokedex_app/features/home/data/models/pokemon_model.dart';
import 'package:pokedex_app/core/error/failure.dart';
import '../../../../mocks/mock_pokemon_repository.dart';

void main() {
  late MockPokemonRepository mockRepo;
  late GetPokemonListUseCase usecase;

  setUp(() {
    mockRepo = MockPokemonRepository();
    usecase = GetPokemonListUseCase(repository: mockRepo);
  });

  final tResponse = PokemonResponseModel(
    count: 1,
    results: [
      PokemonModel(
        name: 'ivysaur',
        url: 'https://pokeapi.co/api/v2/pokemon/2/',
      ),
    ],
  );

  test(
    'retorna lista',
    () async {
      when(() => mockRepo.getPokemons(limit: 20, offset: 0)).thenAnswer(
        (_) async => Right<Failure, PokemonResponseModel>(tResponse),
      );

      final result = await usecase.call({'limit': 20, 'offset': 0});

      expect(result.isRight(), true);
      result.match(
        (l) => fail('expected Right, got Left'),
        (r) => expect(r.count, equals(1)),
      );
      verify(() => mockRepo.getPokemons(limit: 20, offset: 0)).called(1);
    },
  );

  test('retorna falha', () async {
    final failure = ServerFailure('Erro');
    when(
      () => mockRepo.getPokemons(limit: 20, offset: 0),
    ).thenAnswer((_) async => Left<Failure, PokemonResponseModel>(failure));

    final result = await usecase.call({'limit': 20, 'offset': 0});

    expect(result.isLeft(), true);
    result.match(
      (l) => expect(l, isA<ServerFailure>()),
      (r) => fail('expected Left, got Right'),
    );
    verify(() => mockRepo.getPokemons(limit: 20, offset: 0)).called(1);
  });
}
