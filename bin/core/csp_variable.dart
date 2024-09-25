/// Clase base para las variables

part of './csp.dart';

class CspVariable extends Equatable {
  final String name;

  CspVariable({required this.name});

  @override
  String toString() {
    return name;
  }

  @override
  List<Object?> get props => [name];
}
