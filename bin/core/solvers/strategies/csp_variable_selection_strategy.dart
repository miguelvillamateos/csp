part of '../../csp.dart';

abstract class VariableSelectionStrategy<VAR extends Variable, VAL> {
  const VariableSelectionStrategy();

  List<VAR> apply(Csp<VAR, VAL> csp, List<VAR> vars);
}
