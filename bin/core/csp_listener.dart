///
/// Clase base para escuchadores de cambios de estado en CSP
///
part of './csp.dart';

class CspListener<VAR extends CspVariable, VAL> {
  void stateChanged(Csp<VAR, VAL> csp, CspAssignment<VAR, VAL>? assignment,
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
