///
/// Clase para la definición de restricción binaria de =
///
part of '../csp.dart';

class EqualConstraint<VAR extends CspVariable, VAL>
    extends BinaryConstraint<VAR, VAL> {
  EqualConstraint(super.v1, super.v2);

  @override
  bool isSatisfiedWith(CspAssignment<VAR, VAL> assignment) {
    return assignment.getValue(v1) == (assignment.getValue(v2));
  }
}
