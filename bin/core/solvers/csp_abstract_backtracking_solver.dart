import '../csp.dart';
import 'inference/csp_inference_log.dart';

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
      Csp<VAR, VAL> csp, Assignment<VAR, VAL> assignment, VAR v);

  InferenceLog<VAR, VAL> inference(
      Csp<VAR, VAL> csp, Assignment<VAR, VAL> assignment, VAR v);

  Assignment<VAR, VAL> backtrack(
      Csp<VAR, VAL> csp, Assignment<VAR, VAL> assignment) {
    Assignment<VAR, VAL> result = Assignment<VAR, VAL>();

    if (assignment.isComplete(csp.variables)) {
      result = assignment;
    } else {
      VAR v = selectUnassignedVariable(csp, assignment);
      for (VAL value in orderDomainValues(csp, assignment, v)) {
        assignment.add(v, value);
        fireStateChanged(csp, assignment, v);
        if (assignment.isConsistent(csp.getConstraints(v))) {
          InferenceLog<VAR, VAL> log = inference(csp, assignment, v);
          if (!log.isEmpty()) {
            fireStateChanged(csp, null, null);
            if (!log.inconsistencyFound()) {
              result = backtrack(csp, assignment);
              if (!result.isEmpty()) {
                break;
              }
            }
            log.undo(csp);
          }
          assignment.remove(v);
        }
      }
    }
    return result;
  }
}
