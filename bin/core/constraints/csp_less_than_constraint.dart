part of '../csp.dart';

abstract class LessThanConstraint<VAR extends Variable, VAL>
    extends BinaryConstraint<VAR, VAL> {
  LessThanConstraint(super.v1,super.v2);
}
