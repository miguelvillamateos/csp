///
/// Clase para para la definición de la estrategia para comprobar
/// la consistencia por utilizando el algoritma AC3
///
part of '../../csp.dart';

class AC3Strategy<VAR extends CspVariable, VAL>
    extends AbstractInferenceStrategy<VAR, VAL> {
  @override
  InferenceLog<VAR, VAL> initialApply(Csp<VAR, VAL> csp) {
    DoubleLinkedQueue<VAR> queue = DoubleLinkedQueue();
    queue.addAll(csp.variables);
    DomainLog<VAR, VAL> log = DomainLog();
    reduceDomains(queue, csp, log);
    return log.compactify();
  }

  @override
  InferenceLog<VAR, VAL> apply(
      Csp<VAR, VAL> csp, CspAssignment<VAR, VAL> assignment, VAR variable) {
    DomainLog<VAR, VAL> log = DomainLog();
    CspDomain<VAL> domain = csp.getDomain(variable);
    VAL? value = assignment.getValue(variable);
    if (value != null) {
      if (domain.values.length > 1) {
        DoubleLinkedQueue<VAR> queue = DoubleLinkedQueue();
        queue.add(variable);
        log.storeDomainFor(variable, domain);
        csp.setDomain(variable, CspDomain(values: [value]));
        reduceDomains(queue, csp, log);
      }
    }
    return log.compactify();
  }

  void reduceDomains(DoubleLinkedQueue<VAR> queue, Csp<VAR, VAL> csp,
      DomainLog<VAR, VAL> log) {
    while (queue.isNotEmpty) {
      VAR variable = queue.removeFirst();
      for (CspConstraint<VAR, VAL> constraint in csp.getConstraints(variable)) {
        VAR? neighbor = csp.getNeighbor(variable, constraint);
        if (neighbor != null &&
            revise(neighbor, variable, constraint, csp, log)) {
          if (csp.getDomain(neighbor).isEmpty()) {
            log.setEmptyDomainFound(true);
            return;
          }
          queue.add(neighbor);
        }
      }
    }
  }

  bool revise(VAR xi, VAR xj, CspConstraint<VAR, VAL> constraint,
      Csp<VAR, VAL> csp, DomainLog<VAR, VAL> log) {
    CspDomain<VAL> currDomain = csp.getDomain(xi);
    List<VAL> newValues = [];
    CspAssignment<VAR, VAL> assignment = CspAssignment();
    for (VAL vi in currDomain.values) {
      assignment.add(xi, vi);
      for (VAL vj in csp.getDomain(xj).values) {
        assignment.add(xj, vj);
        if (constraint.isSatisfiedWith(assignment)) {
          newValues.add(vi);
          break;
        }
      }
    }
    if (newValues.length < currDomain.values.length) {
      log.storeDomainFor(xi, csp.getDomain(xi));
      csp.setDomain(xi, CspDomain<VAL>(values: newValues));
      return true;
    }
    return false;
  }
}
