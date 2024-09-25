///
/// Clase para la definición de restricción binaria de <
///
part of '../csp.dart';

abstract class LessThanConstraint<VAR extends CspVariable, VAL>
    extends BinaryConstraint<VAR, VAL> {
  LessThanConstraint(super.v1, super.v2);
}
