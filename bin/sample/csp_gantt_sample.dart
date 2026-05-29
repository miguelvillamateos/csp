import 'package:equatable/equatable.dart';

import '../core/csp.dart';

// Definición de Variable
class TaskVariable extends CspVariable<String> {
  TaskVariable({required super.model});
}

// Definición de valores
class Task extends Equatable {
  final DateTime start;
  final DateTime end;
  final Resource resource;

  Task({required this.start, required this.end, required this.resource});

  @override
  String toString() {
    return "Start: ${start.toIso8601String()} End: ${end.toIso8601String()} Resource: ${resource.toString()} ";
  }

  @override
  List<Object?> get props => [start, end];
}

class TaskValue extends CspValue<Task> {
  TaskValue({required super.model});
  DateTime get start => model.start;
  DateTime get end => model.end;
  Resource get resource => model.resource;
}

class Resource extends Equatable {
  final String name;

  Resource({required this.name});
  @override
  String toString() {
    return name;
  }

  @override
  List<Object?> get props => [name];
}

// Definición de restricciones
class StartBeforeStartConstraint<VAR extends TaskVariable,
    VAL extends TaskValue> extends BinaryConstraint<VAR, VAL> {
  StartBeforeStartConstraint(super.v1, super.v2);

  @override
  bool isSatisfiedWith(CspAssignment<VAR, VAL> assignment) {
    bool result = false;
    VAL? value1 = assignment.getValue(v1);
    VAL? value2 = assignment.getValue(v2);
    if (value2 != null) {
      result = value1!.start.isBefore(value2.start);
    } else {
      result = true;
    }
    return result;
  }

  @override
  String toString() => "$v1 startBeforeStart $v2";
}

class StartBeforeEndConstraint<VAR extends TaskVariable, VAL extends TaskValue>
    extends BinaryConstraint<VAR, VAL> {
  StartBeforeEndConstraint(super.v1, super.v2);

  @override
  bool isSatisfiedWith(CspAssignment<VAR, VAL> assignment) {
    bool result = false;
    VAL? value1 = assignment.getValue(v1);
    VAL? value2 = assignment.getValue(v2);
    if (value2 != null) {
      result = value1!.start.isBefore(value2.end);
    }
    return result;
  }

  @override
  String toString() => "$v1 startBeforeEnd $v2";
}

class StartAfterStartConstraint<VAR extends TaskVariable, VAL extends TaskValue>
    extends BinaryConstraint<VAR, VAL> {
  StartAfterStartConstraint(super.v1, super.v2);

  @override
  bool isSatisfiedWith(CspAssignment<VAR, VAL> assignment) {
    bool result = false;
    VAL? value1 = assignment.getValue(v1);
    VAL? value2 = assignment.getValue(v2);
    if (value2 != null) {
      result = value1!.start.isAfter(value2.start);
    } else {
      result = true;
    }
    return result;
  }

  @override
  String toString() => "$v1 startAfterStart $v2";
}

class StartAfterEndConstraint<VAR extends TaskVariable, VAL extends TaskValue>
    extends BinaryConstraint<VAR, VAL> {
  StartAfterEndConstraint(super.v1, super.v2);

  @override
  bool isSatisfiedWith(CspAssignment<VAR, VAL> assignment) {
    bool result = false;
    VAL? value1 = assignment.getValue(v1);
    VAL? value2 = assignment.getValue(v2);
    if (value2 != null) {
      result = value1!.start.isAfter(value2.end);
    } else {
      result = true;
    }
    return result;
  }

  @override
  String toString() => "$v1 startAfterEnd $v2";
}

class StartAfterEndAndNotEqualResourceConstraint<VAR extends TaskVariable,
    VAL extends TaskValue> extends StartAfterEndConstraint<VAR, VAL> {
  StartAfterEndAndNotEqualResourceConstraint(super.v1, super.v2);

  @override
  bool isSatisfiedWith(CspAssignment<VAR, VAL> assignment) {
    bool result = super.isSatisfiedWith(assignment);
    VAL? value1 = assignment.getValue(v1);
    VAL? value2 = assignment.getValue(v2);
    return result && value1?.resource != value2?.resource;
  }

  @override
  String toString() => "$v1 startAfterEndAndNotEqualResource $v2";
}

void showGanttSample({bool showLog = false}) {
  print("----------------------------------------");
  print("Ejemplo de confección diagrama de Gantt");
  print("----------------------------------------");

  List<TaskVariable> tasks = [];

  for (int i = 0; i < 10; i++) {
    tasks.add(TaskVariable(model: "Task $i"));
  }

  List<Resource> resources = [];

  for (int i = 0; i < 3; i++) {
    resources.add(Resource(name: "Resource $i"));
  }

  List<TaskValue> domainValues = [];
  DateTime domStart = DateTime.now();
  DateTime domEnd = domStart.add(const Duration(days: 10));

  int minWorkingHour = 8;
  int maxWorkingHour = 15;

  for (Resource r in resources) {
    print(r);
    for (DateTime d = domStart; d.isBefore(domEnd);) {
      CspTimeOfDay tod = CspTimeOfDay.fromDateTime(dateTime: d);
      // limitar horario
      if (tod.hour > minWorkingHour && tod.hour < maxWorkingHour) {
        TaskValue t =
            TaskValue(model:Task(start: d, end: d.add(Duration(hours: 1)), resource: r));
        domainValues.add(t);
      }
      d = d.add(Duration(hours: 1));
    }
  }

  CspDomain<TaskValue> domain = CspDomain<TaskValue>(values: domainValues);

  final Csp<TaskVariable, TaskValue> csp = Csp<TaskVariable, TaskValue>();

  csp.addAllVariables(tasks);

  for (TaskVariable variable in csp.variables) {
    csp.setDomain(variable, domain);
  }

  print("Listado de tareas (Variables):");
  for (var v in csp.variables) {
    print(" - ${v.model}");
  }

  print("\nListado de posibles horarios (Valores):");
  print(" Total valores en dominio: ${domain.size}");
  // Solo mostramos los primeros 5 para no saturar la consola
  for (var val in domain.values.take(5)) {
    print(" - $val");
  }
  print(" ...");

  for (int j = 0; j < csp.variables.length - 1; j++) {
    TaskVariable v1 = csp.variables[j];
    TaskVariable v2 = csp.variables[j + 1];
    csp.addConstraint(
        StartAfterEndAndNotEqualResourceConstraint<TaskVariable, TaskValue>(
            v1, v2));
  }

  for (TaskVariable v1 in csp.variables) {
    for (TaskVariable v2 in csp.variables) {
      if (v1 != v2) {
        csp.addConstraint(NotEqualConstraint<TaskVariable, TaskValue>(v1, v2));
      }
    }
  }

  print("\nListado de restricciones:");
  for (var c in csp.constraints) {
    print(" - $c");
  }
  print("");

  AC3Strategy<TaskVariable, TaskValue> ac3strategy =
      AC3Strategy<TaskVariable, TaskValue>();
  MinimumRemainingValuesHeuristic<TaskVariable, TaskValue>
      minimumRemainingValuesHeuristic =
      MinimumRemainingValuesHeuristic<TaskVariable, TaskValue>();
  LeastConstrainingValueHeuristic<TaskVariable, TaskValue>
      leastConstrainingValueHeuristic =
      LeastConstrainingValueHeuristic<TaskVariable, TaskValue>();
  Heuristics<TaskVariable, TaskValue> heuristics =
      Heuristics<TaskVariable, TaskValue>(
          variableSelectionStrategy: minimumRemainingValuesHeuristic,
          valueOrderingStrategy: leastConstrainingValueHeuristic);

  FlexibleBacktrackingSolver<TaskVariable, TaskValue> solver =
      FlexibleBacktrackingSolver(
          heuristics: heuristics, inferenceStrategy: ac3strategy);

  if (showLog) {
    CspListener<TaskVariable, TaskValue> listener =
        CspListener<TaskVariable, TaskValue>();
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
