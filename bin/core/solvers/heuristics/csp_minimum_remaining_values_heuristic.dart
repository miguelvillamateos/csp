part of '../../csp.dart';

class MinimumRemainingValuesHeuristic<VAR extends Variable, VAL>
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
