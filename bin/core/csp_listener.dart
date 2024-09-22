part of './csp.dart';

class CspListener<VAR extends Variable, VAL> {
  void stateChanged(Csp<VAR, VAL> csp, Assignment<VAR, VAL>? assignment,
      VAR? variable, String info) {
    print("stateChanged --> ");
    print(info);
    if (assignment != null) {
      print("Assignment: ${assignment.toString()}");
    }
    if (variable != null) {
      print("Variable: ${variable.toString()}");
    }
    print("<-- stateChanged");
  }
}
