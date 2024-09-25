part of '../../csp.dart';

abstract class AbstractBacktrackingSolver<VAR extends CspVariable, VAL>
    extends CspSolver<VAR, VAL> {
  @override
  CspAssignment<VAR, VAL> solve(Csp<VAR, VAL> csp) {
    CspAssignment<VAR, VAL> result = backtrack(csp, CspAssignment<VAR, VAL>());
    return result;
  }

  VAR selectUnassignedVariable(
      Csp<VAR, VAL> csp, CspAssignment<VAR, VAL> assignment);

  Iterable<VAL> orderDomainValues(
      Csp<VAR, VAL> csp, CspAssignment<VAR, VAL> assignment, VAR variable);

  InferenceLog<VAR, VAL> inference(
      Csp<VAR, VAL> csp, CspAssignment<VAR, VAL> assignment, VAR variable);

  CspAssignment<VAR, VAL> backtrack(
      Csp<VAR, VAL> csp, CspAssignment<VAR, VAL> assignment) {
    CspAssignment<VAR, VAL> result = CspAssignment<VAR, VAL>();
    print("backtrack -->");

    if (assignment.isComplete(csp.variables)) {
      print("${assignment.toString()} --> is complete");
      result = assignment;
    } else {
      print("${assignment.toString()} --> is not Complete");
      VAR variable = selectUnassignedVariable(csp, assignment);
      print(" Selecting --> $variable");
      for (VAL value in orderDomainValues(csp, assignment, variable)) {
        assignment.add(variable, value);
        fireStateChanged(csp, assignment, variable, "Added ($variable,$value)");
        if (assignment.isConsistent(csp.getConstraints(variable))) {
          InferenceLog<VAR, VAL> log = inference(csp, assignment, variable);
          if (!log.isEmpty()) {
            fireStateChanged(csp, null, null, "Inference");
          }
          if (!log.inconsistencyFound()) {
            fireStateChanged(csp, null, null, "NO inconsistencyFound ");
            result = backtrack(csp, assignment);
            if (!result.isEmpty()) {
              break;
            }
          }
          log.undo(csp);
        }
        assignment.remove(variable);
      }
    }
    return result;
  }
}
