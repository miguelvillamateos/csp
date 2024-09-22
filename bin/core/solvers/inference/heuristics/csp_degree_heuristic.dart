part of '../../../csp.dart';


class DegreeHeuristic<VAR extends Variable, VAL>
    extends VariableSelectionStrategy<VAR, VAL> {
  @override
  List<VAR> apply(Csp<VAR, VAL> csp, List<VAR> vars) {
    List<VAR> result = [];
    int maxDegree = -1;
    for (VAR variable in vars) {
      int degree = csp.getConstraints(variable).length;
      if (degree > maxDegree) {
        result.clear();
        maxDegree = degree;
      }
      if (degree == maxDegree) {
        result.add(variable);
      }
    }
    return result;
  }
}
