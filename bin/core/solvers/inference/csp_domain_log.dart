///
/// Clase base para para la definición de escuchadores
///
part of '../../csp.dart';

class DomainLog<VAR extends CspVariable, VAL>
    implements InferenceLog<VAR, VAL> {
  List<Pair<VAR, CspDomain<VAL>>> savedDomains = [];
  List<VAR> affectedVariables = [];
  bool emptyDomainObserved = false;

  DomainLog();

  void clear() {
    savedDomains.clear();
    affectedVariables.clear();
  }

  void storeDomainFor(VAR variable, CspDomain<VAL> domain) {
    if (!affectedVariables.contains(variable)) {
      savedDomains.add(Pair<VAR, CspDomain<VAL>>(variable, domain));
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

  List<Pair<VAR, CspDomain<VAL>>> getSavedDomains() {
    return savedDomains;
  }

  @override
  String toString() {
    String result = "";
    for (Pair<VAR, CspDomain<VAL>> pair in savedDomains) {
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
