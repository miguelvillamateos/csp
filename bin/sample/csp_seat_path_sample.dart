library;

import 'package:equatable/equatable.dart';

import '../core/csp.dart';

class PersonModel extends Equatable {
  final int id;
  final String name;

  PersonModel({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}

class SeatGroup extends Equatable {
  final int id;
  final String name;

  SeatGroup({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}

class SeatModel extends Equatable {
  final int id;
  final String name;
  final List<int> groupIds;
  final List<int> nextToIds;

  SeatModel({
    required this.id,
    required this.name,
    this.groupIds = const [],
    this.nextToIds = const [],
  });

  bool isNextTo(int otherId) => nextToIds.contains(otherId);
  bool isInGroup(int groupId) => groupIds.contains(groupId);

  @override
  List<Object?> get props => [id, name, groupIds, nextToIds];
}

class CspSeatPathVariable extends CspVariable<PersonModel> {
  CspSeatPathVariable({required super.model});

  @override
  String toString() => model.name;
}

class CspSeatPathValue extends CspValue<SeatModel> {
  CspSeatPathValue({required super.model});

  @override
  String toString() => model.name;
}

class CspSeatPathDomain extends CspDomain<CspSeatPathValue> {
  CspSeatPathDomain({required super.values});
}

abstract class CspSeatPathConstraint
    extends CspConstraint<CspSeatPathVariable, CspSeatPathValue> {
  CspSeatPathConstraint({super.scope});
}

/// 1) A isNextTo B: necessarily seats assigned to A and B are neighbors.
class CspSeatPathIsNextToConstraint extends CspSeatPathConstraint {
  final CspSeatPathVariable v1;
  final CspSeatPathVariable v2;

  CspSeatPathIsNextToConstraint(this.v1, this.v2) : super(scope: [v1, v2]);

  @override
  bool isSatisfiedWith(CspAssignment<CspSeatPathVariable, CspSeatPathValue> assignment) {
    final val1 = assignment.getValue(v1);
    final val2 = assignment.getValue(v2);
    if (val1 == null || val2 == null) return true;
    return val1.model.isNextTo(val2.model.id);
  }

  @override
  String toString() => "${v1.model.name} isNextTo ${v2.model.name}";
}

/// 2) A isNotNextTo B: necessarily seats assigned to A and B are not neighbors.
class CspSeatPathIsNotNextToConstraint extends CspSeatPathConstraint {
  final CspSeatPathVariable v1;
  final CspSeatPathVariable v2;

  CspSeatPathIsNotNextToConstraint(this.v1, this.v2) : super(scope: [v1, v2]);

  @override
  bool isSatisfiedWith(CspAssignment<CspSeatPathVariable, CspSeatPathValue> assignment) {
    final val1 = assignment.getValue(v1);
    final val2 = assignment.getValue(v2);
    if (val1 == null || val2 == null) return true;
    return !val1.model.isNextTo(val2.model.id);
  }

  @override
  String toString() => "${v1.model.name} isNotNextTo ${v2.model.name}";
}

/// 3) A isAssignedTo P: Seat A must be assigned to Person P.
/// v is the variable for Person P.
class CspSeatPathIsAssignedToConstraint extends CspSeatPathConstraint {
  final CspSeatPathVariable personVar;
  final SeatModel seat;

  CspSeatPathIsAssignedToConstraint(this.personVar, this.seat) : super(scope: [personVar]);

  @override
  bool isSatisfiedWith(CspAssignment<CspSeatPathVariable, CspSeatPathValue> assignment) {
    final val = assignment.getValue(personVar);
    if (val == null) return true;
    return val.model.id == seat.id;
  }

  @override
  String toString() => "${personVar.model.name} isAssignedTo ${seat.name}";
}

/// 3b) A isNotAssignedTo P: Seat A must NOT be assigned to Person P.
class CspSeatPathIsNotAssignedToConstraint extends CspSeatPathConstraint {
  final CspSeatPathVariable personVar;
  final SeatModel seat;

  CspSeatPathIsNotAssignedToConstraint(this.personVar, this.seat) : super(scope: [personVar]);

  @override
  bool isSatisfiedWith(CspAssignment<CspSeatPathVariable, CspSeatPathValue> assignment) {
    final val = assignment.getValue(personVar);
    if (val == null) return true;
    return val.model.id != seat.id;
  }

  @override
  String toString() => "${personVar.model.name} isNotAssignedTo ${seat.name}";
}

/// 4) P isInGroup G: Person P must be in a seat belonging to group G.
class CspSeatPathIsInGroupConstraint extends CspSeatPathConstraint {
  final CspSeatPathVariable personVar;
  final int groupId;

  CspSeatPathIsInGroupConstraint(this.personVar, this.groupId) : super(scope: [personVar]);

  @override
  bool isSatisfiedWith(CspAssignment<CspSeatPathVariable, CspSeatPathValue> assignment) {
    final val = assignment.getValue(personVar);
    if (val == null) return true;
    return val.model.isInGroup(groupId);
  }

  @override
  String toString() => "${personVar.model.name} isInGroup $groupId";
}

/// 5) P isNotInGroup G: Person P must NOT be in a seat belonging to group G.
class CspSeatPathIsNotInGroupConstraint extends CspSeatPathConstraint {
  final CspSeatPathVariable personVar;
  final int groupId;

  CspSeatPathIsNotInGroupConstraint(this.personVar, this.groupId) : super(scope: [personVar]);

  @override
  bool isSatisfiedWith(CspAssignment<CspSeatPathVariable, CspSeatPathValue> assignment) {
    final val = assignment.getValue(personVar);
    if (val == null) return true;
    return !val.model.isInGroup(groupId);
  }

  @override
  String toString() => "${personVar.model.name} isNotInGroup $groupId";
}

/// 6) P1 isInSameGroup P2: Seat assigned to P1 and P2 belong to at least one common group G.
class CspSeatPathIsInSameGroupConstraint extends CspSeatPathConstraint {
  final CspSeatPathVariable v1;
  final CspSeatPathVariable v2;

  CspSeatPathIsInSameGroupConstraint(this.v1, this.v2) : super(scope: [v1, v2]);

  @override
  bool isSatisfiedWith(CspAssignment<CspSeatPathVariable, CspSeatPathValue> assignment) {
    final val1 = assignment.getValue(v1);
    final val2 = assignment.getValue(v2);
    if (val1 == null || val2 == null) return true;
    return val1.model.groupIds.any((g) => val2.model.groupIds.contains(g));
  }

  @override
  String toString() => "${v1.model.name} isInSameGroup ${v2.model.name}";
}

void showSeatPathSample({bool showLog = false}) {
  print("--------------------------------------------------------");
  print("Ejemplo de resolución del problema de asignación de asientos");
  print("--------------------------------------------------------");

  // Definición de las personas (Variables)
  final p1 = PersonModel(id: 1, name: "Alice");
  final p2 = PersonModel(id: 2, name: "Bob");
  final p3 = PersonModel(id: 3, name: "Charlie");

  final v1 = CspSeatPathVariable(model: p1);
  final v2 = CspSeatPathVariable(model: p2);
  final v3 = CspSeatPathVariable(model: p3);

  // Definición de grupos de asientos
  final g1 = SeatGroup(id: 1, name: "Zona VIP");
  final g2 = SeatGroup(id: 2, name: "Zona Estándar");
  final allGroups = [g1, g2];

  // Definición de los asientos (Valores)
  final s1 = SeatModel(id: 1, name: "A1", groupIds: [1], nextToIds: [2]);
  final s2 = SeatModel(id: 2, name: "A2", groupIds: [1], nextToIds: [1]);
  final s3 = SeatModel(id: 3, name: "B1", groupIds: [2], nextToIds: []);

  final val1 = CspSeatPathValue(model: s1);
  final val2 = CspSeatPathValue(model: s2);
  final val3 = CspSeatPathValue(model: s3);

  final domain = CspSeatPathDomain(values: [val1, val2, val3]);

  final csp = Csp<CspSeatPathVariable, CspSeatPathValue>();
  csp.addAllVariables([v1, v2, v3]);
  csp.setDomain(v1, domain);
  csp.setDomain(v2, domain);
  csp.setDomain(v3, domain);

  // Listados previos
  print("Listado de personas:");
  for (var v in csp.variables) {
    print(" - ${v.model.name} (ID: ${v.model.id})");
  }

  print("\nListado de asientos:");
  for (var val in domain.values) {
    print(" - ${val.model.name} (ID: ${val.model.id}, Grupos: ${val.model.groupIds}, Vecinos: ${val.model.nextToIds})");
  }

  print("\nListado de grupos:");
  for (var g in allGroups) {
    final seatsInGroup = domain.values
        .where((val) => val.model.isInGroup(g.id))
        .map((val) => val.model.name)
        .join(", ");
    print(" - ${g.name} (ID: ${g.id}): [$seatsInGroup]");
  }

  // Restricciones
  csp.addConstraint(CspSeatPathIsNextToConstraint(v1, v2));
  csp.addConstraint(CspSeatPathIsNotInGroupConstraint(v3, 1));
  
  // Asignación única de asiento (Cada persona en un asiento distinto)
  csp.addConstraint(NotEqualConstraint<CspSeatPathVariable, CspSeatPathValue>(v1, v2));
  csp.addConstraint(NotEqualConstraint<CspSeatPathVariable, CspSeatPathValue>(v1, v3));
  csp.addConstraint(NotEqualConstraint<CspSeatPathVariable, CspSeatPathValue>(v2, v3));

  print("\nListado de restricciones:");
  for (var c in csp.constraints) {
    print(" - $c");
  }
  print("");

  // Configuración del solver
  final ac3strategy = AC3Strategy<CspSeatPathVariable, CspSeatPathValue>();
  final mrvHeuristic = MinimumRemainingValuesHeuristic<CspSeatPathVariable, CspSeatPathValue>();
  final lcvHeuristic = LeastConstrainingValueHeuristic<CspSeatPathVariable, CspSeatPathValue>();
  final heuristics = Heuristics<CspSeatPathVariable, CspSeatPathValue>(
      variableSelectionStrategy: mrvHeuristic,
      valueOrderingStrategy: lcvHeuristic);

  final solver = FlexibleBacktrackingSolver<CspSeatPathVariable, CspSeatPathValue>(
          heuristics: heuristics, inferenceStrategy: ac3strategy);

  if (showLog) {
    solver.addCspListener(CspListener<CspSeatPathVariable, CspSeatPathValue>());
  }

  final solution = solver.solve(csp);

  if (solution.isSolution(csp)) {
    print("Solución encontrada:");
    for (final variable in solution.getVariables()) {
      final value = solution.getValue(variable);
      if (value != null) {
        print("${variable.model.name} asignado a ${value.model.name}");
      }
    }
  } else {
    print("No se encontró una solución completa.");
  }
}
