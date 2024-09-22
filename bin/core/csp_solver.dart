part of './csp.dart';

abstract class CspSolver<VAR extends Variable, VAL> {
  final List<CspListener<VAR, VAL>> listeners = [];

  CspSolver();

  Assignment<VAR, VAL> solve(Csp<VAR, VAL> csp);

  void addCspListener(CspListener<VAR, VAL> listener) {
    listeners.add(listener);
  }

  void removeCspListener(CspListener<VAR, VAL> listener) {
    listeners.remove(listener);
  }

  void fireStateChanged(
      Csp<VAR, VAL> csp, Assignment<VAR, VAL>? assignment, VAR? variable) {
    for (CspListener<VAR, VAL> listener in listeners) {
      listener.stateChanged(csp, assignment, variable);
    }
  }
}
