import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:pokedex_app/features/home/domain/usecases/get_pokemon_detail_usecase.dart';
import 'package:pokedex_app/features/home/data/models/pokemon_detail_model.dart';
import 'package:pokedex_app/core/error/failure.dart';
import '../../../../mocks/mock_pokemon_repository.dart';

void main() {
  late MockPokemonRepository mockRepo;
  late GetPokemonDetailUseCase usecase;

  setUp(() {
    mockRepo = MockPokemonRepository();
    usecase = GetPokemonDetailUseCase(mockRepo);
  });

  const tName = 'ivysaur';
  final tModel = PokemonDetailModel(
    id: 2,
    name: 'ivysaur',
    imageUrl: 'https://example.com/ivysaur.png',
    types: ['grass', 'poison'],
    height: 10,
    weight: 130,
    speciesUrl: 'https://pokeapi.co/api/v2/pokemon-species/2/',
  );

  test(
    'retorna detalhe',
    () async {
      when(
        () => mockRepo.getPokemonByName(tName),
      ).thenAnswer((_) async => Right<Failure, PokemonDetailModel>(tModel));

      final result = await usecase.call(tName);

      expect(result.isRight(), true);
      result.match(
        (l) => fail('expected Right, got Left'),
        (r) => expect(r.name, equals('ivysaur')),
      );
      verify(() => mockRepo.getPokemonByName(tName)).called(1);
    },
  );

  test('retorna falha', () async {
    final failure = ServerFailure('Erro');
    when(
      () => mockRepo.getPokemonByName(tName),
    ).thenAnswer((_) async => Left<Failure, PokemonDetailModel>(failure));

    final result = await usecase.call(tName);

    expect(result.isLeft(), true);
    result.match(
      (l) => expect(l, isA<ServerFailure>()),
      (r) => fail('expected Left, got Right'),
    );
    verify(() => mockRepo.getPokemonByName(tName)).called(1);
  });
}
