part of '../../csp.dart';

class FlexibleBacktrackingSolver<VAR extends Variable, VAL>
    extends AbstractBacktrackingSolver<VAR, VAL> {
  final Heuristics<VAR, VAL> heuristics;
  final AbstractInferenceStrategy<VAR, VAL> inferenceStrategy;

  FlexibleBacktrackingSolver(
      {required this.heuristics, required this.inferenceStrategy});

  @override
  Assignment<VAR, VAL> solve(Csp<VAR, VAL> csp) {
    InferenceLog log = inferenceStrategy.initialApply(csp);
    if (!log.isEmpty()) {
      fireStateChanged(csp, null, null);
      if (log.inconsistencyFound()) return Assignment();
    }
    return super.solve(csp);
  }

  @override
  VAR selectUnassignedVariable(
      Csp<VAR, VAL> csp, Assignment<VAR, VAL> assignment) {
    List<VAR> vars =
        csp.variables.where((v) => !assignment.contains(v)).toList();
    vars = heuristics.variableSelectionStrategy.apply(csp, vars);
    return vars[0];
  }

  @override
  List<VAL> orderDomainValues(
      Csp<VAR, VAL> csp, Assignment<VAR, VAL> assignment, VAR variable) {
    return heuristics.valueOrderingStrategy.apply(csp, assignment, variable);
  }

  @override
  InferenceLog<VAR, VAL> inference(
      Csp<VAR, VAL> csp, Assignment<VAR, VAL> assignment, VAR variable) {
    return inferenceStrategy.apply(csp, assignment, variable);
  }
}
