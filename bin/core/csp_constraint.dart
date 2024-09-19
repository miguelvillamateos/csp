part of './csp.dart';

abstract class Constraint<VAR extends Variable, VAL> {
  List<VAR> scope;

  List<VAR> get getScope => scope;

  bool isSatisfiedWith(Assignment<VAR, VAL> assignment);

  Constraint({this.scope = const []});
}
