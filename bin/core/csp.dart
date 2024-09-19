library csp;

import 'dart:collection';
import 'package:equatable/equatable.dart';

part 'csp_assignment.dart';
part 'csp_constraint.dart';
part 'csp_domain.dart';
part 'csp_listener.dart';
part 'csp_solver.dart';
part 'csp_variable.dart';




class Csp<VAR extends Variable, VAL> {
  final List<VAR> variables = [];
  final List<Domain<VAL>> domains = [];
  final List<Constraint<VAR, VAL>> constraints = [];
  final LinkedHashMap<VAR, Domain<VAL>> variableToDomainMap = LinkedHashMap();
  final LinkedHashMap<VAR, List<Constraint<VAR, VAL>>> variableToConstrainsMap =
      LinkedHashMap();

  Csp();

  Csp.fromVarsList(List<VAR> vars) {
    variables.addAll(vars);
  }

  void addVariable(VAR v) {
    if (!variables.contains(v)) {
      Domain<VAL> emptyDomain = Domain();
      variables.add(v);
      domains.add(emptyDomain);
    }
  }

  Domain<VAL> getDomain(Variable v) {
    return variableToDomainMap[v]?? Domain<VAL>();
  }

  void setDomain(VAR v, Domain<VAL> domain) {
    variableToDomainMap.putIfAbsent(v, () => domain);
  }

  bool removeValueFromDomain(VAR v, VAL value) {
    Domain<VAL> currDomain = getDomain(v);
    bool r = false;

    final List<VAL> values = [];

    for (VAL val in currDomain.values) {
      if (!(val == value)) {
        values.add(val);
      }
      if (values.length < currDomain.size) {
        setDomain(v, Domain<VAL>(values: values));
        r = true;
      }
    }
    return r;
  }

  void addConstraint(Constraint<VAR, VAL> constraint) {
    constraints.add(constraint);
    for (VAR v in constraint.getScope) {
      variableToConstrainsMap[v]?.add(constraint);
    }
  }

  bool removeConstraint(Constraint<VAR, VAL> constraint) {
    bool r = false;
    if (constraints.remove(constraint)) {
      for (VAR v in constraint.getScope) {
        variableToConstrainsMap[v]?.remove(constraint);
      }
      r = true;
    }
    return r;
  }

  List<Constraint<VAR, VAL>> getConstraints(Variable v) {
    return variableToConstrainsMap[v] ?? [];
  }

  VAR? getNeighbor(VAR v, Constraint<VAR, VAL> constraint) {
    List<VAR> scope = constraint.getScope;
    if (scope.length == 2) {
      if (v == scope.elementAt(0)) {
        return scope.elementAt(1);
      } else if (v == scope.elementAt(1)) {
        return scope.elementAt(0);
      }
    }
    return null;
  }

  
}
