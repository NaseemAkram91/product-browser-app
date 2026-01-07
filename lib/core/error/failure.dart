import 'package:equatable/equatable.dart';

/// Base class for all failures in the application
abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Failure representing a server-side error
class ServerFailure extends Failure {
  const ServerFailure({required super.message});
}

/// Failure representing a network connectivity issue
class NetworkFailure extends Failure {
  const NetworkFailure({required super.message});
}

/// Failure representing a parsing or data transformation error
class ParsingFailure extends Failure {
  const ParsingFailure({required super.message});
}

/// Convenience function to map failures to error messages
String mapFailureToMessage(Failure failure) {
  switch (failure) {
    case ServerFailure():
      return 'Server error: ${failure.message}';
    case NetworkFailure():
      return 'Network error: Please check your internet connection';
    case ParsingFailure():
      return 'Data error: ${failure.message}';
  }
  return 'Unknown error';
}
