part of './csp.dart';

class Assignment<VAR extends Variable, VAL> extends Equatable {
  final LinkedHashMap<VAR, VAL> variableToValueMap = LinkedHashMap();

  Assignment();

  Assignment.copyFrom(Assignment<VAR, VAL> a) {
    variableToValueMap.addAll(a.variableToValueMap);
  }

  List<VAR> getVariables() => variableToValueMap.keys.toList();

  VAL? getValue(VAR variable) {
    return variableToValueMap[variable];
  }

  VAL add(VAR variable, VAL value) {
    remove(variable);
    return variableToValueMap.putIfAbsent(variable, () => value);
  }

  VAL? remove(VAR variable) {
    return variableToValueMap.remove(variable);
  }

  bool contains(VAR variable) => variableToValueMap.containsKey(variable);

  bool isConsistent(List<Constraint<VAR, VAL>> constraints) {
    return constraints.every((cons) => cons.isSatisfiedWith(this));
  }

  bool isComplete(List<VAR> variables) {
    return variables.every((variable) => this.contains(variable));
  }

  bool isSolution(Csp<VAR, VAL> csp) {
    return isConsistent(csp.constraints) && isComplete(csp.variables);
  }

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
