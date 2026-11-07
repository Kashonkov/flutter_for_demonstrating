class UseCaseResultTypeException implements Exception {
  final String message;

  const UseCaseResultTypeException(this.message);

  @override
  String toString() => 'UseCaseResultTypeException: $message';
}

const isNotSuccessfulUseCaseResultTypeException =
    UseCaseResultTypeException('UseCaseResult is not successful but you are trying to get result');

const isNotErrorUseCaseResultTypeException =
    UseCaseResultTypeException('UseCaseResult is not error but you are trying to get exception');
