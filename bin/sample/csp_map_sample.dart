///
/// Ejemplo de aplicación de resolución de CSP para el problema de coloreado de
/// mapas
///
import '../core/csp.dart';

void showMapSample() {
  print("--------------------------------------------------------");
  print("Ejemplo de resolución del problema de coloreado de mapa");
  print("--------------------------------------------------------");

  // Definición de las variables
  final CspVariable NSW = CspVariable(name: "NSW");
  final CspVariable NT = CspVariable(name: "NT");
  final CspVariable Q = CspVariable(name: "Q");
  final CspVariable SA = CspVariable(name: "SA");
  final CspVariable T = CspVariable(name: "T");
  final CspVariable V = CspVariable(name: "V");
  final CspVariable WA = CspVariable(name: "WA");

  // Definición de posibles valores
  final String RED = "RED";
  final String GREEN = "GREEN";
  final String BLUE = "BLUE";
  final String YELLOW = "YELLOW";

  // Se define el dominio común: valores que pueden asignarse a las variables
  CspDomain<String> domain = CspDomain<String>(values: [RED, GREEN, BLUE]);

  final Csp<CspVariable, String> csp = Csp<CspVariable, String>();
  csp.addAllVariables([SA, NT, V, T, NSW, Q, WA]);

  // se relacionan los dominioas a las variables
  for (CspVariable variable in csp.variables) {
    csp.setDomain(variable, domain);
  }

  // Defeinición de las restricciones a aplicar a las variables/valores
  csp.addConstraint(NotEqualConstraint<CspVariable, String>(WA, NT));
  csp.addConstraint(NotEqualConstraint<CspVariable, String>(WA, SA));
  csp.addConstraint(NotEqualConstraint<CspVariable, String>(NT, SA));
  csp.addConstraint(NotEqualConstraint<CspVariable, String>(NT, Q));
  csp.addConstraint(NotEqualConstraint<CspVariable, String>(SA, Q));
  csp.addConstraint(NotEqualConstraint<CspVariable, String>(SA, NSW));
  csp.addConstraint(NotEqualConstraint<CspVariable, String>(SA, V));
  csp.addConstraint(NotEqualConstraint<CspVariable, String>(Q, NSW));
  csp.addConstraint(NotEqualConstraint<CspVariable, String>(NSW, V));

  // Se establecen como condiciones adicionales un color para  dos zonas
  csp.setDomain(SA, CspDomain<String>(values: [RED]));
  csp.setDomain(T, CspDomain<String>(values: [GREEN]));

  AC3Strategy<CspVariable, String> ac3strategy =
      AC3Strategy<CspVariable, String>();
  MinimumRemainingValuesHeuristic<CspVariable, String>
      minimumRemainingValuesHeuristic =
      MinimumRemainingValuesHeuristic<CspVariable, String>();
  LeastConstrainingValueHeuristic<CspVariable, String>
      leastConstrainingValueHeuristic =
      LeastConstrainingValueHeuristic<CspVariable, String>();
  Heuristics<CspVariable, String> heuristics = Heuristics<CspVariable, String>(
      variableSelectionStrategy: minimumRemainingValuesHeuristic,
      valueOrderingStrategy: leastConstrainingValueHeuristic);

  FlexibleBacktrackingSolver<CspVariable, String> solver =
      FlexibleBacktrackingSolver(
          heuristics: heuristics, inferenceStrategy: ac3strategy);

  CspListener<CspVariable, String> listener =
      CspListener<CspVariable, String>();

  solver.addCspListener(listener);

  CspAssignment solution = solver.solve(csp);
  if (solution.isSolution(csp)) {
    print("Solution ---> ${solution.toString()}");
  } else {
    print("Partial solution ---> ${solution.toString()}");
  }
}
