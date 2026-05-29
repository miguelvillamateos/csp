///
/// Clase base para los CSP
///
library csp;

import 'dart:core';
import 'dart:collection';
import 'package:equatable/equatable.dart';

part 'csp_assignment.dart';
part 'csp_constraint.dart';
part 'csp_domain.dart';
part 'csp_listener.dart';
part 'csp_solver.dart';
part 'csp_variable.dart';
part 'csp_value.dart';
part 'util/csp_pair.dart';
part 'util/csp_time_of_day.dart';
part 'constraints/csp_binary_constraint.dart';
part 'constraints/csp_not_equal_constraint.dart';
part 'constraints/csp_equal_constraint.dart';
part 'constraints/csp_less_than_constraint.dart';
part 'constraints/csp_greater_than_constraint.dart';
part 'constraints/number/csp_number_greater_than_constraint.dart';
part 'constraints/number/csp_number_less_than_constraint.dart';
part 'constraints/string/csp_string_greater_than_constraint.dart';
part 'constraints/string/csp_string_less_than_constraint.dart';
part 'solvers/inference/csp_inference_log.dart';
part 'solvers/inference/csp_domain_log.dart';
part 'solvers/heuristics/csp_heuristics.dart';
part 'solvers/heuristics/csp_least_constraining_value_heuristic.dart';
part 'solvers/heuristics/csp_minimum_remaining_values_heuristic.dart';
part 'solvers/strategies/csp_abstract_inference_strategy.dart';
part 'solvers/strategies/csp_ac3_strategy.dart';
part 'solvers/strategies/csp_value_ordering_strategy.dart';
part 'solvers/strategies/csp_variable_selection_strategy.dart';
part 'solvers/search/csp_abstract_backtracking_solver.dart';
part 'solvers/search/csp_flexible_backtracking_solver.dart';

class Csp<VAR extends CspVariable, VAL extends CspValue> {
  final List<VAR> variables = [];
  final List<CspDomain<VAL>> domains = [];
  final List<CspConstraint<VAR, VAL>> constraints = [];
  final Map<VAR, CspDomain<VAL>> variableToDomainMap = {};
  final Map<VAR, List<CspConstraint<VAR, VAL>>> variableToConstrainsMap = {};

  Csp();

  Csp.copy({required Csp<VAR, VAL> csp}) {
    variables.addAll(csp.variables);
    domains.addAll(csp.domains);
    constraints.addAll(csp.constraints);
    variableToDomainMap.addAll(csp.variableToDomainMap);
    variableToConstrainsMap.addAll(csp.variableToConstrainsMap);
  }

  void addAllVariables(List<VAR> variables) {
    variables.forEach(addVariable);
  }

  void addVariable(VAR variable) {
    if (!variables.contains(variable)) {
      variables.add(variable);
    }
  }

  CspDomain<VAL> getDomain(CspVariable variable) {
    return variableToDomainMap[variable] ?? CspDomain<VAL>();
  }

  void setDomain(VAR variable, CspDomain<VAL> domain) {
    if (variableToDomainMap.containsKey(variable)) {
      variableToDomainMap[variable] = domain;
    } else {
      variableToDomainMap.putIfAbsent(variable, () => domain);
    }
    if (!domains.contains(domain)) {
      domains.add(domain);
    }
  }

  bool removeValueFromDomain(VAR variable, VAL value) {
    final currDomain = getDomain(variable);
    final newValues = currDomain.values.where((val) => val != value).toList();

    if (newValues.length < currDomain.size) {
      setDomain(variable, CspDomain<VAL>(values: newValues));
      return true;
    }
    return false;
  }

  void addConstraint(CspConstraint<VAR, VAL> constraint) {
    constraints.add(constraint);
    for (VAR variable in constraint.getScope) {
      if (variableToConstrainsMap.containsKey(variable)) {
        variableToConstrainsMap[variable]?.add(constraint);
      } else {
        variableToConstrainsMap.putIfAbsent(variable, () => [constraint]);
      }
    }
  }

  bool removeConstraint(CspConstraint<VAR, VAL> constraint) {
    bool r = false;
    if (constraints.remove(constraint)) {
      for (VAR variable in constraint.getScope) {
        variableToConstrainsMap[variable]?.remove(constraint);
      }
      r = true;
    }
    return r;
  }

  List<CspConstraint<VAR, VAL>> getConstraints(CspVariable variable) {
    return variableToConstrainsMap[variable] ?? [];
  }

  VAR? getNeighbor(VAR v, CspConstraint<VAR, VAL> constraint) {
    final scope = constraint.getScope;
    if (scope.length == 2) {
      if (v == scope[0]) {
        return scope[1];
      } else if (v == scope[1]) {
        return scope[0];
      }
    }
    return null;
  }

  @override
  String toString() {
    return "CSP: \r\n Variables: ${variables.toString()} \r\n Domains: ${domains.toString()}";
  }
}
