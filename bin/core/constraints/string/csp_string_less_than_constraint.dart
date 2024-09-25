///
/// Clase para la definición de restricción binaria de < apara valores String
///
part of '../../csp.dart';

class StringLessThanConstraint<VAR extends CspVariable, String>
    extends BinaryConstraint<VAR, String> {
  StringLessThanConstraint(super.v1, super.v2);

  @override
  bool isSatisfiedWith(CspAssignment<VAR, String> assignment) {
    String? value1 = assignment.getValue(v1);
    String? value2 = assignment.getValue(v2);
    bool r = false;
    if (value1 != null && value2 != null) {
      r = (value1.toString().compareTo(value2.toString()) < 0);
    }
    return r;
  }
}
