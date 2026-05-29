part of '../../csp.dart';

abstract class InferenceLog<VAR extends CspVariable, VAL  extends CspValue> {
  bool isEmpty();
  bool inconsistencyFound();
  void undo(Csp<VAR, VAL> csp);
}

class EmptyInferenceLog<VAR extends CspVariable, VAL extends CspValue>
    extends InferenceLog<VAR, VAL> {
  @override
  bool inconsistencyFound() {
    return true;
  }

  @override
  bool isEmpty() {
    return true;
  }

  @override
  void undo(Csp<VAR, VAL> csp) {}
}
