import 'package:equatable/equatable.dart';

import '../core/csp.dart';

class TaskVariable extends CspVariable {
  TaskVariable({required super.name});
}

class TaskValue extends Equatable {
  final DateTime start;
  final DateTime end;

  TaskValue({required this.start, required this.end});

  @override
  String toString() {
    return "Start: ${start.toIso8601String()} End: ${end.toIso8601String()} ";
  }

  @override
  List<Object?> get props => [start, end];
}

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
}

void showGanttSample() {
  print("----------------------------------------");
  print("Ejemplo de confección diagrama de Gantt");
  print("----------------------------------------");

  List<TaskVariable> tasks = [];

  for (int i = 0; i < 3; i++) {
    tasks.add(TaskVariable(name: "Task $i"));
  }

  List<TaskValue> domainValues = [];
  DateTime domStart = DateTime.now();
  DateTime domEnd = domStart.add(const Duration(days: 7));

  int minWorkingHour = 8;
  int maxWorkingHour = 15;

  for (DateTime d = domStart; d.isBefore(domEnd);) {
    CspTimeOfDay tod = CspTimeOfDay.fromDateTime(dateTime: d);
    // limitar horario
    if (tod.hour > minWorkingHour && tod.hour < maxWorkingHour) {
      TaskValue t = TaskValue(start: d, end: d.add(Duration(hours: 1)));
      domainValues.add(t);
    }
    d = d.add(Duration(hours: 2));
  }

  CspDomain<TaskValue> domain = CspDomain<TaskValue>(values: domainValues);

  final Csp<TaskVariable, TaskValue> csp = Csp<TaskVariable, TaskValue>();

  csp.addAllVariables(tasks);

  for (TaskVariable variable in csp.variables) {
    csp.setDomain(variable, domain);
  }

  for (int j = 0; j < csp.variables.length - 1; j++) {
    TaskVariable v1 = csp.variables[j];
    TaskVariable v2 = csp.variables[j + 1];
    csp.addConstraint(StartAfterEndConstraint<TaskVariable, TaskValue>(v1, v2));
  }

  for (TaskVariable v1 in csp.variables) {
    for (TaskVariable v2 in csp.variables) {
      if (v1 != v2) {
        csp.addConstraint(NotEqualConstraint<TaskVariable, TaskValue>(v1, v2));
      }
    }
  }

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

  CspListener<TaskVariable, TaskValue> listener =
      CspListener<TaskVariable, TaskValue>();

  solver.addCspListener(listener);

  print("CSP: ${csp.toString()}");
  CspAssignment solution = solver.solve(csp);
  if (solution.isSolution(csp)) {
    print("Solution ---> ${solution.toString()}");
  } else {
    print("Partial solution ---> ${solution.toString()}");
  }
}
