part of '../csp.dart';

class NotEqualConstraint<VAR extends Variable, VAL>
    extends BinaryConstraint<VAR, VAL> {

  NotEqualConstraint(super.v1, super.v2);
  
  @override
  bool isSatisfiedWith(Assignment<VAR, VAL> assignment) {
    VAL? value1 = assignment.getValue(v1);
    return value1 != (assignment.getValue(v2));
  }
}
