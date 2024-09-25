///
/// Clase base para para la definición de la heurística de ordenación de valores
/// que elige la variable con la menor cantidad de valores “legales” restantes
/// en su dominio.
part of '../../csp.dart';

class MinimumRemainingValuesHeuristic<VAR extends CspVariable, VAL>
    extends VariableSelectionStrategy<VAR, VAL> {
  const MinimumRemainingValuesHeuristic();

  @override
  List<VAR> apply(Csp<VAR, VAL> csp, List<VAR> vars) {
    List<VAR> result = [];
    int minValues = 0x7FFFFFFFFFFFFFFF; // Max int value
    for (VAR variable in vars) {
      int values = csp.getDomain(variable).size;
      if (values < minValues) {
        result.clear();
        minValues = values;
      }
      if (values == minValues) {
        result.add(variable);
      }
    }
    return result;
  }
}
