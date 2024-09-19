part of './csp.dart';

class Assignment<VAR extends Variable, VAL> extends Equatable {
  final LinkedHashMap<VAR, VAL> variableToValueMap = LinkedHashMap();

  Assignment();

  Assignment.copyFrom(Assignment<VAR, VAL> a) {
    variableToValueMap.addAll(a.variableToValueMap);
  }
  List<VAR> getVariables() => variableToValueMap.keys.toList();

  VAL? getValue(VAR v) {
    return variableToValueMap[v];
  }

  VAL add(VAR v, VAL value) {
    return variableToValueMap.putIfAbsent(v, () => value);
  }

  VAL? remove(VAR v) {
    return variableToValueMap.remove(v);
  }

  bool contains(VAR v) => variableToValueMap.containsKey(v);

  bool isConsistent(List<Constraint<VAR, VAL>> constraints) {
    return constraints.every((cons) => cons.isSatisfiedWith(this));
  }

  bool isComplete(List<VAR> vars) {
    return vars.every((v) => this.contains(v));
  }

  bool isSolution(Csp<VAR, VAL> csp) {
    return isConsistent(csp.constraints) && isComplete(csp.variables);
  }

  bool isEmpty() {
    return variableToValueMap.isEmpty;
  }

  @override
  List<Object?> get props => [variableToValueMap];
}
