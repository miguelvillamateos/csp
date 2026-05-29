/// Clase base para los posibles valores

part of './csp.dart';

class CspValue<T> extends Equatable {
  final T model;

  const CspValue({required this.model});

  @override
  String toString() {
    return model.toString();
  }

  @override
  List<Object?> get props => [model];
}
