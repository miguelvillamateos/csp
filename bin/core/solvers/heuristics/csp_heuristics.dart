///
/// Clase base para para la definición de la heurística a aplicar al CSP
///
part of '../../csp.dart';

class Heuristics<VAR extends CspVariable, VAL> {
  final VariableSelectionStrategy<VAR, VAL> variableSelectionStrategy;
  final ValueOrderingStrategy<VAR, VAL> valueOrderingStrategy;

  const Heuristics(
      {required this.variableSelectionStrategy,
      required this.valueOrderingStrategy});
}
