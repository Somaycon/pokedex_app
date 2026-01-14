abstract class Failure {
  final String message;

  Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure([super.message = 'Erro no servidor']);
}

class NetworkFailure extends Failure {
  NetworkFailure([super.message = 'Sem conexão']);
}
