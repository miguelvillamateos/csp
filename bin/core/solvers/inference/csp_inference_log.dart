part of '../../csp.dart';

abstract class InferenceLog<VAR extends CspVariable, VAL> {
  bool isEmpty();
  bool inconsistencyFound();
  void undo(Csp<VAR, VAL> csp);
}

class EmptyInferenceLog<VAR extends CspVariable, VAL>
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
