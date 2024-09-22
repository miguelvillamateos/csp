part of '../../csp.dart';

class LeastConstrainingValueHeuristic<VAR extends Variable, VAL>
    extends ValueOrderingStrategy<VAR, VAL> {
  const LeastConstrainingValueHeuristic();

  @override
  List<VAL> apply(
      Csp<VAR, VAL> csp, Assignment<VAR, VAL> assignment, VAR variable) {
    print(" LeastConstrainingValueHeuristic apply --->");
    List<Pair<VAL, int>> pairs = [];
    for (VAL value in csp.getDomain(variable).values) {
      int num = countLostValues(csp, assignment, variable, value);
      pairs.add(Pair<VAL, int>(value, num));
    }

    pairs.sort((a, b) => a.getSecond().compareTo(b.getSecond()));

    print(" Pares: ${pairs.toString()}");

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
