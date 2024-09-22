import '../../csp.dart';

class NumberLessThanConstraint<VAR extends Variable, NUMBER extends num>
    extends BinaryConstraint<VAR, NUMBER> {
  NumberLessThanConstraint(super.v1, super.v2);

  @override
  bool isSatisfiedWith(Assignment<VAR, NUMBER> assignment) {
    NUMBER? value1 = assignment.getValue(v1);
    NUMBER? value2 = assignment.getValue(v2);
    bool r = false;
    if (value1 != null && value2 != null) {
      r = value1 < value2;
    }
    return r;
  }
}
