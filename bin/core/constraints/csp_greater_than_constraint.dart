///
/// Clase para la definición de restricción binaria de >
///
part of '../csp.dart';

abstract class GreaterThanConstraint<VAR extends CspVariable, VAL>
    extends BinaryConstraint<VAR, VAL> {
  GreaterThanConstraint(super.v1, super.v2);
}
