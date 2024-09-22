import '../../csp.dart';
import '../../util/csp_pair.dart';
import 'csp_inference_log.dart';

class DomainLog<VAR extends Variable, VAL> implements InferenceLog<VAR, VAL> {
  List<Pair<VAR, Domain<VAL>>> savedDomains = [];
  List<VAR> affectedVariables = [];
  bool emptyDomainObserved = false;

  DomainLog();

  void clear() {
    savedDomains.clear();
    affectedVariables.clear();
  }

  void storeDomainFor(VAR variable, Domain<VAL> domain) {
    if (!affectedVariables.contains(variable)) {
      savedDomains.add(Pair<VAR, Domain<VAL>>(variable, domain));
      affectedVariables.add(variable);
    }
  }

  void setEmptyDomainFound(bool b) {
    emptyDomainObserved = b;
  }

  DomainLog<VAR, VAL> compactify() {
    affectedVariables = [];
    return this;
  }

  @override
  bool isEmpty() {
    return savedDomains.isEmpty;
  }

  @override
  void undo(Csp<VAR, VAL> csp) {
    getSavedDomains()
        .forEach((pair) => csp.setDomain(pair.getFirst(), pair.getSecond()));
  }

  @override
  bool inconsistencyFound() {
    return emptyDomainObserved;
  }

  List<Pair<VAR, Domain<VAL>>> getSavedDomains() {
    return savedDomains;
  }

  @override
  String toString() {
    String result = "";
    for (Pair<VAR, Domain<VAL>> pair in savedDomains) {
      result += (pair.getFirst().toString()) +
          ("=") +
          (pair.getSecond().toString()) +
          (" ");
    }
    if (emptyDomainObserved) {
      result += "!";
    }
    return result;
  }
}
