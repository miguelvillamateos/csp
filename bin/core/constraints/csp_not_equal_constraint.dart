///
/// Clase para la definición de restricción binaria de !=
///
part of '../csp.dart';

class NotEqualConstraint<VAR extends CspVariable, VAL extends CspValue>
    extends BinaryConstraint<VAR, VAL> {
  NotEqualConstraint(super.v1, super.v2);

  @override
  bool isSatisfiedWith(CspAssignment<VAR, VAL> assignment) {
    VAL? value1 = assignment.getValue(v1);
    return value1 != (assignment.getValue(v2));
  }

  @override
  String toString() => "$v1 no tiene asignado el mismo valor que $v2";
}
