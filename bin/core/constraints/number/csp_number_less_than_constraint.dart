///
/// Clase para la definición de restricción binaria de < apara valores numéricos
///
part of '../../csp.dart';

class NumberLessThanConstraint<VAR extends CspVariable, NUMBER extends CspValue<num>>
    extends BinaryConstraint<VAR, NUMBER> {
  NumberLessThanConstraint(super.v1, super.v2);

  @override
  bool isSatisfiedWith(CspAssignment<VAR, NUMBER> assignment) {
    num? val1 = assignment.getValue(v1)?.model;
    num? val2 = assignment.getValue(v2)?.model;
    return val1 != null && val2 != null && val1 < val2;
  }
}
