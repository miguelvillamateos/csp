///
/// Clase base para los solucionadores de CSP
///
part of './csp.dart';

abstract class CspSolver<VAR extends CspVariable, VAL> {
  final List<CspListener<VAR, VAL>> listeners = [];

  CspSolver();

  CspAssignment<VAR, VAL> solve(Csp<VAR, VAL> csp);

  void addCspListener(CspListener<VAR, VAL> listener) {
    listeners.add(listener);
  }

  void removeCspListener(CspListener<VAR, VAL> listener) {
    listeners.remove(listener);
  }

  void fireStateChanged(Csp<VAR, VAL> csp, CspAssignment<VAR, VAL>? assignment,
      VAR? variable, String info) {
    for (CspListener<VAR, VAL> listener in listeners) {
      listener.stateChanged(csp, assignment, variable, info);
    }
  }
}
