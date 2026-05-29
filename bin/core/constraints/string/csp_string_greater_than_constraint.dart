///
/// Clase para la definición de restricción binaria de > apara valores String
///
part of '../../csp.dart';

class StringGreaterThanConstraint<VAR extends CspVariable, STR extends CspValue<String>>
    extends BinaryConstraint<VAR, STR> {
  StringGreaterThanConstraint(super.v1, super.v2);

  @override
  bool isSatisfiedWith(CspAssignment<VAR, STR> assignment) {
    STR? value1 = assignment.getValue(v1);
    STR? value2 = assignment.getValue(v2);
    bool r = false;
    if (value1 != null && value2 != null) {
      r = (value1.toString().compareTo(value2.toString()) > 0);
    }
    return r;
  }
}
