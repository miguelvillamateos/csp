part of './csp.dart';

abstract class CspSolver<VAR extends Variable, VAL> {
  List<CspListener<VAR, VAL>> listeners = <CspListener<VAR, VAL>>[];
  Assignment<VAR, VAL> solve(Csp<VAR, VAL> csp);

  fireStateChanged(
      Csp<VAR, VAL> csp, Assignment<VAR, VAL>? assignment, VAR? variable) {
    for (CspListener<VAR, VAL> listener in listeners) {
      listener.stateChanged(csp, assignment, variable);
    }
  }
}
