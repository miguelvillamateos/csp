part of '../../csp.dart';

class Heuristics<VAR extends Variable, VAL> {
  final VariableSelectionStrategy<VAR, VAL> variableSelectionStrategy;
  final ValueOrderingStrategy<VAR, VAL> valueOrderingStrategy;

  const Heuristics(
      {required this.variableSelectionStrategy,
      required this.valueOrderingStrategy});
}
