part of '../../csp.dart';

class FlexibleBacktrackingSolver<VAR extends CspVariable, VAL>
    extends AbstractBacktrackingSolver<VAR, VAL> {
  final Heuristics<VAR, VAL> heuristics;
  final AbstractInferenceStrategy<VAR, VAL> inferenceStrategy;

  FlexibleBacktrackingSolver(
      {required this.heuristics, required this.inferenceStrategy});

  @override
  CspAssignment<VAR, VAL> solve(Csp<VAR, VAL> csp) {
    Csp<VAR, VAL> tempCsp = Csp<VAR, VAL>.copy(csp: csp);

    InferenceLog log = inferenceStrategy.initialApply(tempCsp);
    if (!log.isEmpty()) {
      fireStateChanged(csp, null, null, "Initial inference");
      if (log.inconsistencyFound()) {
        return CspAssignment();
      }
    }
    return super.solve(tempCsp);
  }

  @override
  VAR selectUnassignedVariable(
      Csp<VAR, VAL> csp, CspAssignment<VAR, VAL> assignment) {
    List<VAR> vars =
        csp.variables.where((v) => !assignment.contains(v)).toList();
    vars = heuristics.variableSelectionStrategy.apply(csp, vars);
    print("selectUnassignedVariable --> ${vars[0].toString()}");
    return vars[0];
  }

  @override
  List<VAL> orderDomainValues(
      Csp<VAR, VAL> csp, CspAssignment<VAR, VAL> assignment, VAR variable) {
    print("orderDomainValues --> ");
    return heuristics.valueOrderingStrategy.apply(csp, assignment, variable);
  }

  @override
  InferenceLog<VAR, VAL> inference(
      Csp<VAR, VAL> csp, CspAssignment<VAR, VAL> assignment, VAR variable) {
    return inferenceStrategy.apply(csp, assignment, variable);
  }
}
