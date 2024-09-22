import '../../csp.dart';
import '../../util/csp_value_int_pair.dart';
import 'csp_value_ordering_strategy.dart';

class LeastConstrainingValueHeuristic<VAR extends Variable, VAL>
    extends ValueOrderingStrategy<VAR, VAL> {
  const LeastConstrainingValueHeuristic();
 
  @override
  List<VAL> apply(
      Csp<VAR, VAL> csp, Assignment<VAR, VAL> assignment, VAR variable) {
    List<ValueIntPair<VAL>> pairs = [];
    for (VAL value in csp.getDomain(variable).values) {
      int num = countLostValues(csp, assignment, variable, value);
      pairs.add(ValueIntPair<VAL>(value, num));
    }

    pairs.sort((a, b) => a.getSecond().compareTo(b.getSecond()));

    List<VAL> result = [];
    pairs.every((p) {
      result.add(p.getFirst());
      return true;
    });

    return result;
  }

  int countLostValues(Csp<VAR, VAL> csp, Assignment<VAR, VAL> assignment,
      VAR variable, VAL value) {
    int result = 0;
    Assignment<VAR, VAL> assign = Assignment();
    assign.add(variable, value);
    for (Constraint<VAR, VAL> constraint in csp.getConstraints(variable)) {
      if (constraint.getScope.length == 2) {
        VAR? neighbor = csp.getNeighbor(variable, constraint);
        if (neighbor != null) {
          if (!assignment.contains(neighbor)) {
            for (VAL nValue in csp.getDomain(neighbor).values) {
              assign.add(neighbor, nValue);
              if (!constraint.isSatisfiedWith(assign)) {
                ++result;
              }
            }
          }
        }
      }
    }
    return result;
  }
}
