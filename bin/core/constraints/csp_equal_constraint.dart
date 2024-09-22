part of '../csp.dart';

class EqualConstraint<VAR extends Variable, VAL>
    extends BinaryConstraint<VAR, VAL> {

  EqualConstraint(super.v1,super.v2);

  @override
  bool isSatisfiedWith(Assignment<VAR, VAL> assignment) {
    return assignment.getValue(v1) == (assignment.getValue(v2));
  }
}
