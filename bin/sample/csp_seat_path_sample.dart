library;

import 'dart:io';
import 'dart:convert';
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

void showSeatPathSample({bool showLog = false, String? jsonPath}) {
  print("--------------------------------------------------------");
  print("Ejemplo de resolución del problema de asignación de asientos");
  print("--------------------------------------------------------");

  if (jsonPath == null || jsonPath.isEmpty) {
    print("Error: No se ha proporcionado un fichero JSON de configuración.");
    print("Uso: dart bin/main.dart -e 3 -f ruta/al/fichero.json");
    return;
  }

  final File file = File(jsonPath);
  if (!file.existsSync()) {
    print("Error: El fichero JSON no existe: $jsonPath");
    return;
  }

  Map<String, dynamic> data;
  try {
    final String content = file.readAsStringSync();
    data = jsonDecode(content);
  } catch (e) {
    print("Error al leer o procesar el fichero JSON: $e");
    return;
  }

  // 1. Personas (Variables)
  List<CspSeatPathVariable> variables = [];
  Set<int> personIds = {};
  if (data['people'] is List) {
    for (var p in data['people']) {
      final int? id = p['id'];
      final String? name = p['name'];
      if (id != null && name != null) {
        if (personIds.contains(id)) {
          print("Error de coherencia: ID de persona duplicado ($id).");
          return;
        }
        personIds.add(id);
        variables.add(CspSeatPathVariable(model: PersonModel(id: id, name: name)));
      }
    }
  }

  // 2. Grupos
  List<SeatGroup> allGroups = [];
  Set<int> groupIds = {};
  if (data['groups'] is List) {
    for (var g in data['groups']) {
      final int? id = g['id'];
      final String? name = g['name'];
      if (id != null && name != null) {
        if (groupIds.contains(id)) {
          print("Error de coherencia: ID de grupo duplicado ($id).");
          return;
        }
        groupIds.add(id);
        allGroups.add(SeatGroup(id: id, name: name));
      }
    }
  }

  // 3. Asientos (Valores)
  List<SeatModel> seatModels = [];
  Set<int> seatIds = {};
  if (data['seats'] is List) {
    for (var s in data['seats']) {
      final int? id = s['id'];
      final String? name = s['name'];
      if (id != null && name != null) {
        if (seatIds.contains(id)) {
          print("Error de coherencia: ID de asiento duplicado ($id).");
          return;
        }
        seatIds.add(id);
        
        final List<int> gIds = (s['groupIds'] as List?)?.cast<int>() ?? [];
        for (var gid in gIds) {
          if (!groupIds.contains(gid)) {
            print("Error de coherencia: El asiento $name referencia un grupo inexistente ($gid).");
            return;
          }
        }

        final List<int> nIds = (s['nextToIds'] as List?)?.cast<int>() ?? [];
        seatModels.add(SeatModel(id: id, name: name, groupIds: gIds, nextToIds: List.from(nIds)));
      }
    }
  }

  // Validar vecinos y asegurar reciprocidad
  for (var seat in seatModels) {
    for (var neighborId in seat.nextToIds) {
      if (!seatIds.contains(neighborId)) {
        print("Error de coherencia: El asiento ${seat.name} referencia un vecino inexistente (ID: $neighborId).");
        return;
      }
      final neighbor = seatModels.firstWhere((s) => s.id == neighborId);
      if (!neighbor.nextToIds.contains(seat.id)) {
        neighbor.nextToIds.add(seat.id);
      }
    }
  }

  if (variables.isEmpty || seatModels.isEmpty) {
    print("Error: No hay suficientes datos para ejecutar el problema (faltan personas o asientos).");
    return;
  }

  final domain = CspSeatPathDomain(
      values: seatModels.map((m) => CspSeatPathValue(model: m)).toList());

  if (domain.size < variables.length) {
    print("ADVERTENCIA: No hay suficientes asientos (${domain.size}) para todas las personas (${variables.length}).");
    print("Faltan ${variables.length - domain.size} asientos.\n");
  }

  final csp = Csp<CspSeatPathVariable, CspSeatPathValue>();
  csp.addAllVariables(variables);
  for (var v in variables) {
    csp.setDomain(v, domain);
  }

  // 4. Restricciones
  if (data['constraints'] is List) {
    CspSeatPathVariable? findPerson(int id) => variables.cast<CspSeatPathVariable?>().firstWhere((v) => v!.model.id == id, orElse: () => null);
    SeatModel? findSeat(int id) => seatModels.cast<SeatModel?>().firstWhere((s) => s!.id == id, orElse: () => null);

    for (var item in data['constraints']) {
      final type = item['type'];
      switch (type) {
        case 'isNextTo':
          final v1 = findPerson(item['v1']);
          final v2 = findPerson(item['v2']);
          if (v1 != null && v2 != null) csp.addConstraint(CspSeatPathIsNextToConstraint(v1, v2));
          break;
        case 'isNotNextTo':
          final v1 = findPerson(item['v1']);
          final v2 = findPerson(item['v2']);
          if (v1 != null && v2 != null) csp.addConstraint(CspSeatPathIsNotNextToConstraint(v1, v2));
          break;
        case 'isAssignedTo':
          final p = findPerson(item['person']);
          final s = findSeat(item['seat']);
          if (p != null && s != null) csp.addConstraint(CspSeatPathIsAssignedToConstraint(p, s));
          break;
        case 'isNotAssignedTo':
          final p = findPerson(item['person']);
          final s = findSeat(item['seat']);
          if (p != null && s != null) csp.addConstraint(CspSeatPathIsNotAssignedToConstraint(p, s));
          break;
        case 'isInGroup':
          final p = findPerson(item['person']);
          final int? gId = item['groupId'];
          if (p != null && gId != null) csp.addConstraint(CspSeatPathIsInGroupConstraint(p, gId));
          break;
        case 'isNotInGroup':
          final p = findPerson(item['person']);
          final int? gId = item['groupId'];
          if (p != null && gId != null) csp.addConstraint(CspSeatPathIsNotInGroupConstraint(p, gId));
          break;
        case 'isInSameGroup':
          final v1 = findPerson(item['v1']);
          final v2 = findPerson(item['v2']);
          if (v1 != null && v2 != null) csp.addConstraint(CspSeatPathIsInSameGroupConstraint(v1, v2));
          break;
      }
    }
  }

  csp.addConstraint(AllDifferentConstraint<CspSeatPathVariable, CspSeatPathValue>(variables));

  // Listados y Ejecución
  print("Listado de personas:");
  for (var v in csp.variables) print(" - ${v.model.name} (ID: ${v.model.id})");

  print("\nListado de asientos:");
  for (var val in domain.values) print(" - ${val.model.name} (ID: ${val.model.id}, Grupos: ${val.model.groupIds}, Vecinos: ${val.model.nextToIds})");

  print("\nListado de grupos:");
  for (var g in allGroups) {
    final seatsInGroup = domain.values.where((val) => val.model.isInGroup(g.id)).map((val) => val.model.name).join(", ");
    print(" - ${g.name} (ID: ${g.id}): [$seatsInGroup]");
  }

  print("\nListado de restricciones:");
  for (var c in csp.constraints) print(" - $c");
  print("");

  final solver = FlexibleBacktrackingSolver<CspSeatPathVariable, CspSeatPathValue>(
    heuristics: Heuristics(
      variableSelectionStrategy: MinimumRemainingValuesHeuristic(),
      valueOrderingStrategy: LeastConstrainingValueHeuristic()
    ),
    inferenceStrategy: AC3Strategy()
  );

  if (showLog) solver.addCspListener(CspListener<CspSeatPathVariable, CspSeatPathValue>());

  final solution = solver.solve(csp);

  if (solution.isEmpty()) {
    print("No se encontró ninguna solución válida.");
  } else {
    if (solution.isComplete(csp.variables)) {
      print("Solución completa encontrada:");
    } else {
      print("Solución parcial encontrada (satisfaciendo el máximo de restricciones posibles):");
    }

    for (final variable in csp.variables) {
      final value = solution.getValue(variable);
      if (value != null) {
        print("${variable.model.name} asignado a ${value.model.name}");
      } else {
        print("${variable.model.name} se ha quedado SIN ASIENTO");
      }
    }
  }
}
