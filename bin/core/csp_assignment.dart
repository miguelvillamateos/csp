///
/// Clase base para las asignaciones de valores a variables y comprobación de
/// cumplimiento de las restricciones
///
part of './csp.dart';

class CspAssignment<VAR extends CspVariable, VAL> extends Equatable {
  final LinkedHashMap<VAR, VAL> variableToValueMap = LinkedHashMap();

  CspAssignment();

  // Para obtenerlo a partir de otro
  CspAssignment.copyFrom(CspAssignment<VAR, VAL> a) {
    variableToValueMap.addAll(a.variableToValueMap);
  }

  // Obtener el listado de las variables incluidas en la asignación
  List<VAR> getVariables() => variableToValueMap.keys.toList();

  // Obtener el valor asociado de una variable o nulo si no existe
  VAL? getValue(VAR variable) {
    return variableToValueMap[variable];
  }

  // Añadir (variable,valor) a la asignación
  VAL add(VAR variable, VAL value) {
    remove(variable);
    return variableToValueMap.putIfAbsent(variable, () => value);
  }

  // Eliminar la variable de la asignación
  VAL? remove(VAR variable) {
    return variableToValueMap.remove(variable);
  }

  // Comprobar si la asignación contiene una variable
  bool contains(VAR variable) => variableToValueMap.containsKey(variable);

  // Comprobar si la asignación es consistente con las restricciones
  // facilitades. Será consistente si para cada restricción se cumple
  // con la asignación realizada.
  bool isConsistent(List<CspConstraint<VAR, VAL>> constraints) {
    return constraints.every((cons) => cons.isSatisfiedWith(this));
  }

  // Comprobar si es completa respecto a las variables facilitadas.
  // Será completa si todas las variables están contenidas en la asignación.
  bool isComplete(List<VAR> variables) {
    return variables.every((variable) => this.contains(variable));
  }

  // Comprobar si la asignación realizada es una solución del problema CSP
  // planteado. Lo será si es consitente con las restricciones y es completa
  // respecto de las variables
  bool isSolution(Csp<VAR, VAL> csp) {
    return isConsistent(csp.constraints) && isComplete(csp.variables);
  }

  // Comprobar si la asignación tiene algún elemento
  bool isEmpty() {
    return variableToValueMap.isEmpty;
  }

  @override
  String toString() {
    return variableToValueMap.isEmpty
        ? "Empty assigment"
        : variableToValueMap.toString();
  }

  @override
  List<Object?> get props => [variableToValueMap];
}
