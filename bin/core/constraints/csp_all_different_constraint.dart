///
/// Clase para la definición de restricción n-aria de AllDifferent
/// Asegura que todas las variables en el ámbito tengan valores distintos
///
part of '../csp.dart';

class AllDifferentConstraint<VAR extends CspVariable, VAL extends CspValue>
    extends CspConstraint<VAR, VAL> {
  AllDifferentConstraint(List<VAR> variables) : super(scope: variables);

  @override
  bool isSatisfiedWith(CspAssignment<VAR, VAL> assignment) {
    Set<VAL> assignedValues = {};
    for (VAR variable in scope) {
      VAL? value = assignment.getValue(variable);
      if (value != null) {
        if (assignedValues.contains(value)) {
          return false;
        }
        assignedValues.add(value);
      }
    }
    return true;
  }

  @override
  String toString() {
    return "Todas las personas deben tener asientos distintos ($scope)";
  }
}
