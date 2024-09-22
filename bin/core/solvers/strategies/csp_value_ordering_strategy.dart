part of '../../csp.dart';

abstract class ValueOrderingStrategy<VAR extends Variable, VAL> {
  const ValueOrderingStrategy();

  List<VAL> apply(
      Csp<VAR, VAL> csp, Assignment<VAR, VAL> assignment, VAR variable);
}
