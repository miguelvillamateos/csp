///
/// Clase para gestión de pares de valores
///
part of '../csp.dart';

class Pair<X, Y> extends Equatable {
  final X a;
  final Y b;

  Pair(this.a, this.b);

  X getFirst() => a;
  Y getSecond() => b;

  @override
  String toString() {
    return "(${a.toString()},${b.toString()})";
  }

  @override
  List<Object?> get props => [a, b];
}
