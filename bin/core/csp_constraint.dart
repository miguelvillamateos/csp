///
/// Clase base para las restricciones
///
part of './csp.dart';

class CspConstraint<VAR extends CspVariable, VAL extends CspValue> {
  final List<VAR> scope;

  const CspConstraint({this.scope = const []});

  List<VAR> get getScope => scope;

  bool isSatisfiedWith(CspAssignment<VAR, VAL> assignment) {
    return true;
  }


}
