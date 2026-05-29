part of '../../csp.dart';

abstract class AbstractBacktrackingSolver<VAR extends CspVariable, VAL extends CspValue>
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
    if (assignment.isComplete(csp.variables)) {
      return assignment;
    }

    VAR variable = selectUnassignedVariable(csp, assignment);
    CspAssignment<VAR, VAL> bestResult = CspAssignment<VAR, VAL>();

    for (VAL value in orderDomainValues(csp, assignment, variable)) {
      assignment.add(variable, value);
      fireStateChanged(csp, assignment, variable, "Added ($variable,$value)");

      if (assignment.isConsistent(csp.getConstraints(variable))) {
        InferenceLog<VAR, VAL> log = inference(csp, assignment, variable);
        if (!log.inconsistencyFound()) {
          CspAssignment<VAR, VAL> result = backtrack(csp, assignment);
          if (result.isComplete(csp.variables)) {
            return result;
          }
          // Guardamos la mejor solución parcial encontrada
          if (result.getVariables().length > bestResult.getVariables().length) {
            bestResult = CspAssignment.copyFrom(result);
          }
        }
        log.undo(csp);
      }
      assignment.remove(variable);
    }

    // Si no encontramos una completa, devolvemos la mejor parcial o la actual
    if (bestResult.isEmpty() && !assignment.isEmpty()) {
      return CspAssignment.copyFrom(assignment);
    }

    return bestResult;
  }
}
