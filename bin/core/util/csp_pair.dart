import 'package:equatable/equatable.dart';

class Pair<X, Y> extends Equatable {
  final X a;
  final Y b;

  Pair(this.a, this.b);

  X getFirst() => a;
  Y getSecond() => b;

  @override
  List<Object?> get props => [a, b];
}
