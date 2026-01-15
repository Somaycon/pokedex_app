# Pokedex App

[![Made with Flutter](https://img.shields.io/badge/Made%20with-Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev) [![Dart SDK ^3.10.4](https://img.shields.io/badge/Dart-%5E3.10.4-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev) [![Platforms](https://img.shields.io/badge/Platforms-Android%20%7C%20iOS-green?style=for-the-badge&logo=android)](https://flutter.dev/docs/deployment) [![License](https://img.shields.io/badge/License-Unknown-lightgrey?style=for-the-badge)]()

Descrição do projeto
--------------------

Aplicativo Flutter que consome a PokeAPI para listar Pokémons, exibir detalhes (imagem, tipos, altura, peso) e a cadeia de evolução de cada Pokémon. O projeto está organizado por feature (`features/home`) com separação entre `data`, `domain` e `presentation`.

API utilizada
-------------

O app utiliza a PokeAPI (https://pokeapi.co). Endpoints principais usados:

- `/api/v2/pokemon` — listagem de pokémons
- `/api/v2/pokemon/{name}` — detalhes do Pokémon
- `/api/v2/pokemon-species/{id}` e `/api/v2/evolution-chain/{id}` — para recuperar a cadeia de evolução

Arquitetura aplicada
--------------------

O projeto segue uma variação de Clean Architecture / camada por feature:

- `data`: modelos, data sources e implementação dos repositórios
- `domain`: entidades, `usecases` e contratos de repositório (interfaces)
- `presentation`: controllers (ChangeNotifier), estados e widgets

Padrões e bibliotecas relevantes:

- Padrões: Repository, UseCase, Controllers (ChangeNotifier)
- Bibliotecas: `fpdart` (Either), `mocktail` (mocks), `shared_preferences` (cache), `flutter_modular` (injerção de dependências e modularização) e `dio` (requisições http)

Como rodar o app
----------------

Pré-requisitos:

- Flutter SDK instalado (recomenda-se a mesma versão usada no projeto)
- Android SDK / emulador ou dispositivo físico configurado

Comandos básicos (PowerShell/Terminal):

```bash
# obter dependências
flutter pub get

# rodar no dispositivo conectado ou emulador
flutter run

# rodar em um dispositivo específico (ex.: Android emulator)
flutter devices
flutter run -d <deviceId>
```

Observações:

- Em Windows, certifique-se de ter o `Android SDK` e variáveis de ambiente configuradas (`ANDROID_HOME`/`ANDROID_SDK_ROOT`) se pretende rodar no Android.
- Para builds de release siga a documentação oficial do Flutter para geração de APK/AAB.

Como executar os testes
-----------------------

Rodar todos os testes (unitários, de widget e integração presentes na pasta `test`):

```bash
flutter test
```

Rodar um único arquivo de teste:

```bash
flutter test test/features/home/presentation/controller/pokemon_detail_controller_test.dart
```

Rodar um teste pelo nome (filtro):

```bash
flutter test --plain-name "nome do teste"
```

Com cobertura (opcional):

```bash
flutter test --coverage
# depois abra o relatório em tools como lcov
```

Notas finais
-----------

- Caso os testes falhem por dependências, execute `flutter pub get` antes de rodá-los.
- Se precisar, posso expandir este README com instruções de desenvolvimento (fluxo de PR, linting, CI) ou adicionar badges de build/test.

