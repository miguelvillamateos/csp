///
/// Clase base para el dominio de las variables
///
part of './csp.dart';

class CspDomain<VAL extends CspValue> extends Equatable {
  final List<VAL> values;

  const CspDomain({this.values = const []});

  int get size => values.length;

  VAL operator [](int index) => values[index];

  VAL get(int index) => values[index];

  bool isEmpty() => values.isEmpty;

  bool get isNotEmpty => values.isNotEmpty;

  bool contains(VAL value) => values.contains(value);

  void add(VAL value) {
    values.add(value);
  }

  @override
  String toString() {
    return values.toString();
  }

  @override
  List<Object?> get props => [values];
}
