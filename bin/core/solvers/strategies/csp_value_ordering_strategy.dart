///
/// Clase base para para la definición de la estrategia a utilizar 
/// en la ordenación de los valores
///
part of '../../csp.dart';

abstract class ValueOrderingStrategy<VAR extends CspVariable, VAL> {
  const ValueOrderingStrategy();

  List<VAL> apply(
      Csp<VAR, VAL> csp, CspAssignment<VAR, VAL> assignment, VAR variable);
}
