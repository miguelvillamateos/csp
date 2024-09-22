part of '../csp.dart';

abstract class GreaterThanConstraint<VAR extends Variable, VAL>
    extends BinaryConstraint<VAR, VAL> {
  GreaterThanConstraint(super.v1,super.v2);
}
