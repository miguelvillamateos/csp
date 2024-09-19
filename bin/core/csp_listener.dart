part of './csp.dart';

mixin CspListener<VAR extends Variable, VAL> {
  void stateChanged(
      Csp<VAR, VAL> csp, Assignment<VAR, VAL>? assignment, VAR? variable);
}
