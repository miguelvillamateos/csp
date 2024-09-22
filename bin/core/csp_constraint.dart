part of './csp.dart';

class Constraint<VAR extends Variable, VAL> {
  List<VAR> scope = [];

  List<VAR> get getScope => scope;

  bool isSatisfiedWith(Assignment<VAR, VAL> assignment) {
    return true;
  }

  Constraint();
}
