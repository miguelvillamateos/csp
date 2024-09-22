library csp;

import 'dart:collection';
import 'package:equatable/equatable.dart';

part 'csp_assignment.dart';
part 'csp_constraint.dart';
part 'csp_domain.dart';
part 'csp_listener.dart';
part 'csp_solver.dart';
part 'csp_variable.dart';
part 'constraints/csp_binary_constraint.dart';
part 'constraints/csp_not_equal_constraint.dart';
part 'constraints/csp_equal_constraint.dart';
part 'constraints/csp_less_than_constraint.dart';
part 'constraints/csp_greater_than_constraint copy.dart';

class Csp<VAR extends Variable, VAL> {
  final List<VAR> variables;
  final List<Domain<VAL>> domains = [];
  final List<Constraint<VAR, VAL>> constraints = [];
  final LinkedHashMap<VAR, Domain<VAL>> variableToDomainMap =
      LinkedHashMap<VAR, Domain<VAL>>();
  final LinkedHashMap<VAR, List<Constraint<VAR, VAL>>> variableToConstrainsMap =
      LinkedHashMap<VAR, List<Constraint<VAR, VAL>>>();

  Csp({required this.variables});

  void addVariable(VAR variable) {
    if (!variables.contains(variable)) {
      Domain<VAL> emptyDomain = Domain();
      List<Constraint<VAR, VAL>> emptyConstraints = [];
      variables.add(variable);
      domains.add(emptyDomain);
      variableToDomainMap.putIfAbsent(variable, () => emptyDomain);
      variableToConstrainsMap.putIfAbsent(variable, () => emptyConstraints);
    }
  }

  Domain<VAL> getDomain(Variable variable) {
    return variableToDomainMap[variable] ?? Domain<VAL>();
  }

  void setDomain(VAR variable, Domain<VAL> domain) {
    variableToDomainMap.putIfAbsent(variable, () => domain);
  }

  bool removeValueFromDomain(VAR variable, VAL value) {
    Domain<VAL> currDomain = getDomain(variable);
    bool r = false;
    final List<VAL> values = [];

    for (VAL val in currDomain.values) {
      if (val != value) {
        values.add(val);
      }
      if (values.length < currDomain.size) {
        setDomain(variable, Domain<VAL>(values: values));
        r = true;
      }
    }
    return r;
  }

  void addConstraint(Constraint<VAR, VAL> constraint) {
    constraints.add(constraint);
    for (VAR variable in constraint.getScope) {
      if (variableToConstrainsMap.containsKey(variable)) {
        variableToConstrainsMap[variable]?.add(constraint);
      } else {
        variableToConstrainsMap.putIfAbsent(variable, () => [constraint]);
      }
    }
  }

  bool removeConstraint(Constraint<VAR, VAL> constraint) {
    bool r = false;
    if (constraints.remove(constraint)) {
      for (VAR variable in constraint.getScope) {
        variableToConstrainsMap[variable]?.remove(constraint);
      }
      r = true;
    }
    return r;
  }

  List<Constraint<VAR, VAL>> getConstraints(Variable variable) {
    return variableToConstrainsMap[variable] ?? [];
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
