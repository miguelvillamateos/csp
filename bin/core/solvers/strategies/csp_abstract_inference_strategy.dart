///
/// Clase base para para la definición de la estrategia a utilizar 
/// en inferencia de los valores
///
part of '../../csp.dart';

abstract class AbstractInferenceStrategy<VAR extends CspVariable, VAL> {
  const AbstractInferenceStrategy();
  InferenceLog<VAR, VAL> initialApply(Csp<VAR, VAL> csp);

  InferenceLog<VAR, VAL> apply(
      Csp<VAR, VAL> csp, CspAssignment<VAR, VAL> assignment, VAR variable);
}
