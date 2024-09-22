library csp;

import 'dart:collection';
import 'package:equatable/equatable.dart';

part 'csp_assignment.dart';
part 'csp_constraint.dart';
part 'csp_domain.dart';
part 'csp_listener.dart';
part 'csp_solver.dart';
part 'csp_variable.dart';
part 'util/csp_pair.dart';
part 'constraints/csp_binary_constraint.dart';
part 'constraints/csp_not_equal_constraint.dart';
part 'constraints/csp_equal_constraint.dart';
part 'constraints/csp_less_than_constraint.dart';
part 'constraints/csp_greater_than_constraint copy.dart';
part 'constraints/number/csp_number_greater_than_constraint.dart';
part 'constraints/number/csp_number_less_than_constraint.dart';
part 'constraints/string/csp_string_greater_than_constraint.dart';
part 'constraints/string/csp_string_less_than_constraint.dart';
part 'solvers/inference/csp_inference_log.dart';
part 'solvers/inference/csp_domain_log.dart';
part 'solvers/heuristics/csp_degree_heuristic.dart';
part 'solvers/heuristics/csp_heuristics.dart';
part 'solvers/heuristics/csp_least_constraining_value_heuristic.dart';
part 'solvers/heuristics/csp_minimum_remaining_values_heuristic.dart';
part 'solvers/strategies/csp_abstract_inference_strategy.dart';
part 'solvers/strategies/csp_ac3_strategy.dart';
part 'solvers/strategies/csp_value_ordering_strategy.dart';
part 'solvers/strategies/csp_variable_selection_strategy.dart';
part 'solvers/search/csp_abstract_backtracking_solver.dart';
part 'solvers/search/csp_flexible_backtracking_solver.dart';

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
    if (variableToDomainMap.containsKey(variable)) {
      variableToDomainMap[variable] = domain;
    } else {
      variableToDomainMap.putIfAbsent(variable, () => domain);
    }
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
