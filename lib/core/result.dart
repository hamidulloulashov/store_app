sealed class Result<T> {
  const Result();
  const factory Result.ok(T value) = Ok<T>._;
  const factory Result.error(Exception error) = Error<T>._;
  Exception? get exception => null;
  T? get data => null;
  bool get isSuccess => false;

  R fold<R>(R Function(Exception error) onError, R Function(T value) onSuccess);
}
final class Ok<T> extends Result<T> {
  const Ok._(this.value);
  final T value;

  @override
  T get data => value;
  @override
  bool get isSuccess => true;

  @override
  R fold<R>(
    R Function(Exception error) onError,
    R Function(T value) onSuccess,
  ) => onSuccess(value);
}

final class Error<T> extends Result<T> {
  const Error._(this.error);
  final Exception error;

  @override
  Exception get exception => error;
  @override
  bool get isSuccess => false;

  @override
  R fold<R>(
    R Function(Exception error) onError,
    R Function(T value) onSuccess,
  ) => onError(error);
}
