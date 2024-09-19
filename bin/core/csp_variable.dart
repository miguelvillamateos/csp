part of './csp.dart';

class Variable extends Equatable {
  final String name;

  Variable({required this.name});

  @override
  String toString() {
    return name;
  }

  @override 
  List<Object?> get props => [name];
}
