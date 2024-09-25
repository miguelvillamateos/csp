///
/// Clase base para las restricciones
///
part of './csp.dart';

class CspConstraint<VAR extends CspVariable, VAL> {
  List<VAR> scope = [];

  List<VAR> get getScope => scope;

  bool isSatisfiedWith(CspAssignment<VAR, VAL> assignment) {
    return true;
  }

  CspConstraint();
}
