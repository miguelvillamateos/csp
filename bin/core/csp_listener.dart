part of './csp.dart';

class CspListener<VAR extends Variable, VAL> {
  void stateChanged(
      Csp<VAR, VAL> csp, Assignment<VAR, VAL>? assignment, VAR? variable) {
    print("-----------");
    print("Assignment: ${assignment.toString()}");
    print("Variable: ${variable.toString()}");
  }
}
