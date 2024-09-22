part of './csp.dart';

class Domain<VAL> extends Equatable {
  final List<VAL> values;

  Domain({this.values = const []});

  int get size => values.length;

  VAL get(int index) => values[index];

  bool isEmpty() => values.isEmpty;

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
