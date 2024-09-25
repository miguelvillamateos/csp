///
/// Clase base para para la definición de la estrategia a utilizar 
/// en la selección de los valores
///
part of '../../csp.dart';

abstract class VariableSelectionStrategy<VAR extends CspVariable, VAL> {
  const VariableSelectionStrategy();

  List<VAR> apply(Csp<VAR, VAL> csp, List<VAR> vars);
}
