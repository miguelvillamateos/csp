///
/// Clase para la definición de restricciones binarias
///
part of '../csp.dart';

abstract class BinaryConstraint<VAR extends CspVariable, VAL>
    extends CspConstraint<VAR, VAL> {
  final VAR v1;
  final VAR v2;

  BinaryConstraint(this.v1, this.v2) {
    scope.add(v1);
    scope.add(v2);
  }
}
