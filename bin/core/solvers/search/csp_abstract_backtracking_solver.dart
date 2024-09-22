part of '../../csp.dart';

abstract class AbstractBacktrackingSolver<VAR extends Variable, VAL>
    extends CspSolver<VAR, VAL> {
  @override
  Assignment<VAR, VAL> solve(Csp<VAR, VAL> csp) {
    Assignment<VAR, VAL> result = backtrack(csp, Assignment<VAR, VAL>());
    return result;
  }

  VAR selectUnassignedVariable(
      Csp<VAR, VAL> csp, Assignment<VAR, VAL> assignment);

  Iterable<VAL> orderDomainValues(
      Csp<VAR, VAL> csp, Assignment<VAR, VAL> assignment, VAR variable);

  InferenceLog<VAR, VAL> inference(
      Csp<VAR, VAL> csp, Assignment<VAR, VAL> assignment, VAR variable);

  Assignment<VAR, VAL> backtrack(
      Csp<VAR, VAL> csp, Assignment<VAR, VAL> assignment) {
    Assignment<VAR, VAL> result = Assignment<VAR, VAL>();

    if (assignment.isComplete(csp.variables)) {
      result = assignment;
    } else {
      VAR variable = selectUnassignedVariable(csp, assignment);
      for (VAL value in orderDomainValues(csp, assignment, variable)) {
        assignment.add(variable, value);
        fireStateChanged(csp, assignment, variable, "Added ($variable,$value)");
        if (assignment.isConsistent(csp.getConstraints(variable))) {
          InferenceLog<VAR, VAL> log = inference(csp, assignment, variable);
          if (!log.isEmpty()) {
            fireStateChanged(csp, null, null, "Inference");
            if (!log.inconsistencyFound()) {
              fireStateChanged(csp, null, null, "inconsistencyFound");
              result = backtrack(csp, assignment);
              if (!result.isEmpty()) {
                break;
              }
            }
            log.undo(csp);
          }
        } else {
          assignment.remove(variable);
        }
      }
    }
    return result;
  }
}
