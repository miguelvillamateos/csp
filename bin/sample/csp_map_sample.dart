///
/// Ejemplo de aplicación de resolución de CSP para el problema de coloreado de
/// mapas
///
library;

import '../core/csp.dart';

void showMapSample({bool showLog = false}) {
  print("--------------------------------------------------------");
  print("Ejemplo de resolución del problema de coloreado de mapa");
  print("--------------------------------------------------------");

  // Definición de las variables
  final CspVariable NSW = CspVariable<String>(model: "NSW");
  final CspVariable NT = CspVariable<String>(model: "NT");
  final CspVariable Q = CspVariable<String>(model: "Q");
  final CspVariable SA = CspVariable<String>(model: "SA");
  final CspVariable T = CspVariable<String>(model: "T");
  final CspVariable V = CspVariable<String>(model: "V");
  final CspVariable WA = CspVariable<String>(model: "WA");

  // Definición de posibles valores
  final CspValue<String> RED = CspValue<String>(model: "RED");
  final CspValue<String> GREEN = CspValue<String>(model: "GREEN");
  final CspValue<String> BLUE = CspValue<String>(model: "BLUE");
  // final String YELLOW = "YELLOW";

  // Se define el dominio común: valores que pueden asignarse a las variables
  CspDomain<CspValue<String>> domain =
      CspDomain<CspValue<String>>(values: [RED, GREEN, BLUE]);

  final Csp<CspVariable, CspValue<String>> csp =
      Csp<CspVariable, CspValue<String>>();
  csp.addAllVariables([SA, NT, V, T, NSW, Q, WA]);

  // se relacionan los dominioas a las variables
  for (CspVariable variable in csp.variables) {
    csp.setDomain(variable, domain);
  }

  print("Listado de zonas (Variables):");
  for (var v in csp.variables) {
    print(" - ${v.model}");
  }

  print("\nListado de colores (Valores):");
  for (var val in domain.values) {
    print(" - ${val.model}");
  }

  // Defeinición de las restricciones a aplicar a las variables/valores
  csp.addConstraint(NotEqualConstraint<CspVariable, CspValue<String>>(WA, NT));
  csp.addConstraint(NotEqualConstraint<CspVariable, CspValue<String>>(WA, SA));
  csp.addConstraint(NotEqualConstraint<CspVariable, CspValue<String>>(NT, SA));
  csp.addConstraint(NotEqualConstraint<CspVariable, CspValue<String>>(NT, Q));
  csp.addConstraint(NotEqualConstraint<CspVariable, CspValue<String>>(SA, Q));
  csp.addConstraint(NotEqualConstraint<CspVariable, CspValue<String>>(SA, NSW));
  csp.addConstraint(NotEqualConstraint<CspVariable, CspValue<String>>(SA, V));
  csp.addConstraint(NotEqualConstraint<CspVariable, CspValue<String>>(Q, NSW));
  csp.addConstraint(NotEqualConstraint<CspVariable, CspValue<String>>(NSW, V));

  print("\nListado de restricciones:");
  for (var c in csp.constraints) {
    print(" - $c");
  }
  print("");

  // Se establecen como condiciones adicionales un color para  dos zonas
  csp.setDomain(SA, CspDomain<CspValue<String>>(values: [RED]));
  csp.setDomain(T, CspDomain<CspValue<String>>(values: [GREEN]));

  AC3Strategy<CspVariable, CspValue<String>> ac3strategy =
      AC3Strategy<CspVariable, CspValue<String>>();
  MinimumRemainingValuesHeuristic<CspVariable, CspValue<String>>
      minimumRemainingValuesHeuristic =
      MinimumRemainingValuesHeuristic<CspVariable, CspValue<String>>();
  LeastConstrainingValueHeuristic<CspVariable, CspValue<String>>
      leastConstrainingValueHeuristic =
      LeastConstrainingValueHeuristic<CspVariable, CspValue<String>>();
  Heuristics<CspVariable, CspValue<String>> heuristics =
      Heuristics<CspVariable, CspValue<String>>(
          variableSelectionStrategy: minimumRemainingValuesHeuristic,
          valueOrderingStrategy: leastConstrainingValueHeuristic);

  FlexibleBacktrackingSolver<CspVariable, CspValue<String>> solver =
      FlexibleBacktrackingSolver(
          heuristics: heuristics, inferenceStrategy: ac3strategy);

  if (showLog) {
    CspListener<CspVariable, CspValue<String>> listener =
        CspListener<CspVariable, CspValue<String>>();
    solver.addCspListener(listener);
  }

  CspAssignment solution = solver.solve(csp);
  if (solution.isSolution(csp)) {
    print("Solución encontrada:");
    for (final variable in solution.getVariables()) {
      final value = solution.getValue(variable);
      if (value != null) {
        print("${variable.model} asignado a ${value.model}");
      }
    }
  } else {
    print("No se encontró una solución completa.");
  }
}
