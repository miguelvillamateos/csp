import 'dart:math';

import '../csp.dart';

class MinConflictsSolver<VAR extends Variable, VAL>
    extends CspSolver<VAR, VAL> {
  final int maxSteps;

  MinConflictsSolver({required this.maxSteps});

  @override
  Assignment<VAR, VAL> solve(Csp<VAR, VAL> csp) {
    return generateRandomAssignment(csp);
  }

  Assignment<VAR, VAL> generateRandomAssignment(Csp<VAR, VAL> csp) {
    Assignment<VAR, VAL> result = Assignment<VAR, VAL>();
    int index;
    for (VAR v in csp.variables) {
      Domain<VAL> dom = csp.getDomain(v);
      index = Random().nextInt(csp.variables.length);
      VAL randomValue = dom.values.elementAt(index);
      result.add(v, randomValue);
    }
    return result;
  }

  List<VAR> getConflictedVariables(
      Assignment<VAR, VAL> assignment, Csp<VAR, VAL> csp) {
    List<VAR> result = [];
    List<Constraint<VAR, VAL>> cons = csp.constraints
        .where((constraint) => !constraint.isSatisfiedWith(assignment))
        .toList();
    cons.map((c) => c.getScope).forEach((v) => result.addAll(v));
    return result;
  }

  VAL? getMinConflictValueFor(
      VAR v, Assignment<VAR, VAL> assignment, Csp<VAR, VAL> csp) {
    List<Constraint<VAR, VAL>> constraints = csp.getConstraints(v);
    Assignment<VAR, VAL> testAssignment = Assignment.copyFrom(assignment);
    int minConflict = 0;
    List<VAL> resultCandidates = [];
    for (VAL value in csp.getDomain(v).values) {
      testAssignment.add(v, value);
      int currConflict = countConflicts(testAssignment, constraints);
      if (currConflict <= minConflict) {
        if (currConflict < minConflict) {
          resultCandidates.clear();
          minConflict = currConflict;
        }
        resultCandidates.add(value);
      }
    }
    int index = Random().nextInt(resultCandidates.length);
    return (resultCandidates.isNotEmpty)
        ? resultCandidates.elementAt(index)
        : null;
  }

  int countConflicts(
      Assignment<VAR, VAL> assignment, List<Constraint<VAR, VAL>> constraints) {
    return constraints
        .where((constraint) => !constraint.isSatisfiedWith(assignment))
        .length;
  }
}
