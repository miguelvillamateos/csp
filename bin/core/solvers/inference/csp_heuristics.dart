import '../../csp.dart';
import 'csp_value_ordering_strategy.dart';
import 'csp_variable_selection_strategy.dart';
import 'csp_minimum_remaining_values_heuristic.dart';
import 'csp_least_constraining_value_heuristic.dart';

class Heuristics<VAR extends Variable, VAL> {
  final VariableSelectionStrategy<VAR, VAL> variableSelectionStrategy;
  final ValueOrderingStrategy<VAR, VAL> valueOrderingStrategy;

  const Heuristics(
      {required this.variableSelectionStrategy,
      required this.valueOrderingStrategy});
}
