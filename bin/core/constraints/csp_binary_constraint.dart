part of '../csp.dart';

abstract class BinaryConstraint<VAR extends Variable, VAL>
    extends Constraint<VAR, VAL> {
  final VAR v1;
  final VAR v2;

  BinaryConstraint(this.v1, this.v2) {
    scope.add(v1);
    scope.add(v2);
  }
}
